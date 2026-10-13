#!/usr/bin/env python3
"""Render i3 origin workspaces with their occupied satellite directions."""

import base64
import argparse
import json
import re
import shlex
import subprocess
import sys
import time
from pathlib import Path

from spatial_glyphs import (
    ARROW_TO_BIT,
    ALL_DIRECTIONS,
    choose_slice,
    encode_glyph,
    nearest_direction,
    slice_mask,
)


FONT_TAG = "%{T2}"
ARROW_TOKEN = re.compile(r"([←→↑↓↖↗↘↙])(\d*)")
COORDINATES = re.compile(r"\(\s*(-?\d+)\s*,\s*(-?\d+)\s*\)")
SCRIPT_PATH = str(Path(__file__).resolve())


def location_bit(location):
    """Map an arrow or coordinate location to the nearest of the 8 glyph spokes."""
    location = location.strip()
    if location in ARROW_TO_BIT:
        return ARROW_TO_BIT[location]

    coordinate_match = COORDINATES.fullmatch(location)
    if coordinate_match:
        x, y = map(int, coordinate_match.groups())
    else:
        tokens = list(ARROW_TOKEN.finditer(location))
        if not tokens or "".join(match.group(0) for match in tokens) != location.replace(" ", ""):
            return None
        x = y = 0
        for match in tokens:
            arrow, distance_text = match.groups()
            distance = int(distance_text or 1)
            if arrow == "←": x -= distance
            elif arrow == "→": x += distance
            elif arrow == "↑": y += distance
            elif arrow == "↓": y -= distance
            elif arrow == "↖": x -= distance; y += distance
            elif arrow == "↗": x += distance; y += distance
            elif arrow == "↘": x += distance; y -= distance
            elif arrow == "↙": x -= distance; y -= distance

    return nearest_direction(x, y)


def workspace_parts(name):
    """Return (origin name, direction bit), or treat name as an origin."""
    if ":" in name:
        origin, location = name.rsplit(":", 1)
        bit = location_bit(location)
        if bit is not None:
            return origin, bit
    return name, 0


def polybar_escape(text):
    # Polybar interprets %{...} sequences in custom script output.
    return text.replace("%", "%%")


def switch_command(origin):
    encoded = base64.urlsafe_b64encode(origin.encode("utf-8")).decode("ascii").rstrip("=")
    return f"python3 {shlex.quote(SCRIPT_PATH)} --switch {encoded}"


def render(workspaces, autosize="on", background_arrows="workspaces",
           foreground_arrows="focus"):
    groups = {}
    for workspace in workspaces:
        origin, bit = workspace_parts(workspace["name"])
        group = groups.setdefault(
            origin, {"mask": 0, "focused_mask": 0, "focused": False, "number": None}
        )
        group["mask"] |= bit
        group["focused"] |= bool(workspace.get("focused"))
        if workspace.get("focused"):
            group["focused_mask"] |= bit
        match = re.match(r"^(\d+):", origin)
        if match:
            group["number"] = int(match.group(1))

    result = []
    for origin, group in sorted(
        groups.items(), key=lambda item: (item[1]["number"] is None,
                                          item[1]["number"] or 0,
                                          item[0].casefold())
    ):
        workspace_mask = group["mask"]
        uses_icon_font = False
        if autosize == "on" and workspace_mask == 0:
            icon = ""
        else:
            if autosize == "off" or bin(workspace_mask).count("1") == 1:
                # Keep a lone arm centered in the full-star footprint; the
                # font glyph supplies both its regular and focused weights.
                slice_name = "full"
            else:
                slice_name = choose_slice(workspace_mask)
            included = slice_mask(slice_name)
            background_mask = (
                workspace_mask
                if background_arrows == "workspaces"
                else included & ALL_DIRECTIONS
            )
            foreground_mask = (
                workspace_mask
                if foreground_arrows == "workspaces"
                else group["focused_mask"]
            )
            foreground_mask &= background_mask
            icon = chr(encode_glyph(slice_name, background_mask, foreground_mask))
            uses_icon_font = True
        color = "#00FFCC" if group["focused"] else "#D0D0D0"
        action = switch_command(origin)
        icon_markup = ""
        if icon:
            if uses_icon_font:
                icon_markup = f" {FONT_TAG}{icon}%{{T-}}"
            else:
                icon_markup = f" {icon}"
        result.append(
            f"%{{A1:{action}:}}%{{F{color}}}"
            f"{polybar_escape(origin)}{icon_markup}"
            f"%{{F-}}%{{A}}"
        )
    return "  ".join(result)


def current_output(args):
    output = subprocess.check_output(
        ["i3-msg", "-t", "get_workspaces"], text=True,
        stderr=subprocess.DEVNULL,
    )
    return render(
        json.loads(output),
        autosize=args.autosize,
        background_arrows=args.background_arrows,
        foreground_arrows=args.foreground_arrows,
    )


def watch(args):
    """Stream a fresh rendering whenever i3 reports a workspace event."""
    while True:
        events = None
        try:
            events = subprocess.Popen(
                ["i3-msg", "-t", "subscribe", "-m", '["workspace"]'],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True,
                bufsize=1,
            )

            # i3-msg consumes the subscription acknowledgement internally and
            # writes only event notifications to stdout in monitor mode.
            print(current_output(args), flush=True)
            for line in events.stdout:
                event = json.loads(line)
                if "change" in event:
                    print(current_output(args), flush=True)
            events.wait()
            raise RuntimeError("i3 workspace event subscription ended")
        except (OSError, subprocess.CalledProcessError, json.JSONDecodeError,
                RuntimeError) as error:
            if events is not None and events.poll() is None:
                events.terminate()
                events.wait()
            print(f"i3 workspace switcher: {error}; reconnecting", file=sys.stderr)
            time.sleep(1)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--watch", action="store_true",
                      help="stream workspace output for Polybar's tail mode")
    mode.add_argument("--switch", metavar="BASE64_ORIGIN",
                      help="switch to the encoded origin workspace")
    parser.add_argument("--autosize", choices=("on", "off"), default="on")
    parser.add_argument(
        "--background-arrows", choices=("workspaces", "on"), default="workspaces"
    )
    parser.add_argument(
        "--foreground-arrows", choices=("workspaces", "focus"), default="focus"
    )
    args = parser.parse_args()

    if args.switch:
        encoded = args.switch
        encoded += "=" * (-len(encoded) % 4)
        origin = base64.urlsafe_b64decode(encoded).decode("utf-8")
        return subprocess.call(["i3-msg", f"workspace {json.dumps(origin)}"])

    return watch(args)


if __name__ == "__main__":
    raise SystemExit(main())
