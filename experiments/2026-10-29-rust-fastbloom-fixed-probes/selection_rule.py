#!/usr/bin/env python3
"""Prespecified quality-only K selection for one size/allocation group.

This module never reads latency, constructs a Bloom filter or pools samples.
The future driver must first establish one complete K1..12 group from the
committed accuracy output. Each group keeps its own size and allocation.
"""
import math

KS = tuple(range(1, 13))
CEILINGS = (0.01, 0.001, 0.0001)
Z = 1.959963984540054


def wilson_upper(false_positives, negatives):
    if type(false_positives) is not int or type(negatives) is not int:
        raise ValueError("integer counts required")
    if negatives <= 0 or not 0 <= false_positives <= negatives:
        raise ValueError("invalid Bernoulli counts")
    if false_positives == negatives:
        return 1.0
    p = false_positives / negatives
    denominator = 1 + Z * Z / negatives
    center = (p + Z * Z / (2 * negatives)) / denominator
    radius = Z * math.sqrt((p * (1 - p) + Z * Z / (4 * negatives)) / negatives) / denominator
    return min(1.0, center + radius)


def select_neighborhood(rows):
    """Return all three target decisions and their fixed-K union.

    `rows` is exactly twelve dictionaries containing only K, false_positives
    and negatives. No performance field is accepted or consulted. Missing or
    duplicated K, different sample counts and malformed counts fail closed.
    """
    rows = list(rows)
    if any(set(row) != {"K", "false_positives", "negatives"} for row in rows):
        raise ValueError("only the three declared quality fields are accepted")
    if any(type(row["K"]) is not int for row in rows):
        raise ValueError("integer K required")
    if sorted(row["K"] for row in rows) != list(KS):
        raise ValueError("one complete K1..12 group required")
    if len({row["negatives"] for row in rows}) != 1:
        raise ValueError("each K must use the same independent negative stream length")
    uppers = {row["K"]: wilson_upper(row["false_positives"], row["negatives"]) for row in rows}
    targets, selected = [], set()
    for ceiling in CEILINGS:
        qualifying = [k for k in KS if uppers[k] <= ceiling]
        minimum = min(qualifying) if qualifying else None
        neighbors = [k for k in KS if minimum is not None and abs(k - minimum) <= 1]
        selected.update(neighbors)
        targets.append({"fpr_ceiling": ceiling, "qualifying_K": qualifying,
                        "minimum_qualifying_K": minimum, "timing_neighborhood_K": neighbors})
    return {"targets": targets, "selected_fixed_K": sorted(selected),
            "wilson_upper_by_K": uppers,
            "retained_original_controls": "always retained separately, independent of this selection"}
