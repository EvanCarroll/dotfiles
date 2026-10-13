"""Shared slice, state, and Unicode mapping for ChaosStarVector fonts."""

from __future__ import annotations

import math


# Direction bit order matches font-gen.py's clockwise spoke construction.
ARROWS = "↑↗→↘↓↙←↖"
ARROW_TO_BIT = {arrow: 1 << index for index, arrow in enumerate(ARROWS)}
BIT_TO_ARROW = {bit: arrow for arrow, bit in ARROW_TO_BIT.items()}
ALL_DIRECTIONS = (1 << len(ARROWS)) - 1

# Boundary spokes are deliberately shared by adjacent slices. This makes the
# horizontal/vertical split lines, including their arrowheads, visible.
SLICE_SPOKES = {
    "full": (0, 1, 2, 3, 4, 5, 6, 7),
    "top": (0, 1, 2, 6, 7),
    "right": (0, 1, 2, 3, 4),
    "bottom": (2, 3, 4, 5, 6),
    "left": (0, 4, 5, 6, 7),
    "upper-right": (0, 1, 2),
    "lower-right": (2, 3, 4),
    "lower-left": (4, 5, 6),
    "upper-left": (0, 6, 7),
}

# Small slices are listed first for autosize. Opposite horizontal workspaces tie
# between top/bottom and choose top; opposite vertical workspaces choose right.
SLICE_ORDER = (
    "upper-right", "lower-right", "lower-left", "upper-left",
    "top", "right", "bottom", "left", "full",
)
PUA_BASE = 0xF0000
LEGACY_BASE = 0xE000
LEGACY_COUNT = 256


def slice_mask(slice_name: str) -> int:
    """Return the direction bitmask included in a slice."""
    try:
        return sum(1 << bit for bit in SLICE_SPOKES[slice_name])
    except KeyError as error:
        raise ValueError(f"unknown star slice: {slice_name}") from error


def encode_glyph(slice_name: str, background_mask: int, foreground_mask: int) -> int:
    """Encode absent/background/foreground states into a supplementary PUA codepoint.

    A foreground spoke must also be present in the background. In the per-spoke
    base-3 encoding, 0=absent, 1=background only, and 2=foreground selected.
    """
    if background_mask & ~ALL_DIRECTIONS or foreground_mask & ~ALL_DIRECTIONS:
        raise ValueError("direction mask has bits outside the eight spokes")
    if foreground_mask & ~background_mask:
        raise ValueError("foreground arrows must be a subset of background arrows")

    spokes = SLICE_SPOKES.get(slice_name)
    if spokes is None:
        raise ValueError(f"unknown star slice: {slice_name}")
    included_mask = sum(1 << bit for bit in spokes)
    if background_mask & ~included_mask:
        raise ValueError(f"background arrows fall outside the {slice_name} slice")

    offset = 0
    code = 0
    place = 1
    for name in SLICE_ORDER:
        if name == slice_name:
            for bit in spokes:
                direction = 1 << bit
                state = 2 if foreground_mask & direction else 1 if background_mask & direction else 0
                code += state * place
                place *= 3
            return PUA_BASE + offset + code
        offset += 3 ** len(SLICE_SPOKES[name])
    raise AssertionError("slice order and slice definitions diverged")


def decode_glyph(codepoint: int) -> tuple[str, int, int]:
    """Decode a generated PUA codepoint to slice, background, and foreground masks."""
    offset = codepoint - PUA_BASE
    if offset < 0:
        raise ValueError(f"not a generated star codepoint: U+{codepoint:04X}")

    for name in SLICE_ORDER:
        count = 3 ** len(SLICE_SPOKES[name])
        if offset < count:
            background = foreground = 0
            for bit in SLICE_SPOKES[name]:
                state = offset % 3
                offset //= 3
                if state:
                    background |= 1 << bit
                if state == 2:
                    foreground |= 1 << bit
            return name, background, foreground
        offset -= count
    raise ValueError(f"not a generated star codepoint: U+{codepoint:04X}")


def legacy_masks(codepoint: int) -> tuple[int, int]:
    """Decode the original BMP mapping: all arrows light, mask arrows bold."""
    mask = codepoint - LEGACY_BASE
    if not 0 <= mask < LEGACY_COUNT:
        raise ValueError(f"not a legacy star codepoint: U+{codepoint:04X}")
    return ALL_DIRECTIONS, mask


def choose_slice(workspace_mask: int) -> str:
    """Choose the smallest containing slice with stable tie preferences."""
    if workspace_mask == 0:
        return "full"
    if workspace_mask & ~ALL_DIRECTIONS:
        raise ValueError("direction mask has bits outside the eight spokes")

    for name in SLICE_ORDER:
        candidate = slice_mask(name)
        if workspace_mask & ~candidate == 0:
            return name
    raise AssertionError("the full slice must contain every valid direction")


def nearest_direction(x: int, y: int) -> int | None:
    """Map a nonzero coordinate to the nearest clockwise spoke bit."""
    if x == 0 and y == 0:
        return None
    index = round((math.pi / 2 - math.atan2(y, x)) / (math.pi / 4)) % 8
    return 1 << index


def unicode_arrow(direction_bit: int) -> str:
    try:
        return BIT_TO_ARROW[direction_bit]
    except KeyError as error:
        raise ValueError("expected a single direction bit") from error


def fit_transform(bbox: tuple[float, float, float, float], mode: str) -> tuple[float, float, float, float, float, float]:
    """Return FontForge affine matrix fitting a bbox into a centered 900-unit box."""
    xmin, ymin, xmax, ymax = bbox
    width, height = xmax - xmin, ymax - ymin
    if width <= 0 or height <= 0:
        raise ValueError("slice template has an empty bounding box")
    if mode == "proportional":
        sx = sy = min(900 / width, 900 / height)
    elif mode == "fill":
        sx, sy = 900 / width, 900 / height
    else:
        raise ValueError(f"unknown slice scale mode: {mode}")

    # All glyphs share the existing em box and center (500, 250); 50 units of
    # margin on every side protect the outlines from rasterizer clipping.
    tx = 500 - sx * (xmin + xmax) / 2
    ty = 250 - sy * (ymin + ymax) / 2
    return sx, 0, 0, sy, tx, ty


GLYPH_COUNT = sum(3 ** len(spokes) for spokes in SLICE_SPOKES.values())
