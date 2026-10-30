"""Exact parallel benchmark family names; optional layouts require explicit selection."""

DEFAULT_FAMILIES = ("FastPattern", "FourSector", "Split64", "ByteSplit")
OPTIONAL_FAMILIES = ("Split64Range", "FourSectorRange12")
AVAILABLE_FAMILIES = DEFAULT_FAMILIES + OPTIONAL_FAMILIES


def selected_families(value):
    families = list(DEFAULT_FAMILIES) if value == "all" else value.split(",")
    if len(set(families)) != len(families) or not set(families) <= set(AVAILABLE_FAMILIES):
        raise ValueError("unknown, empty or duplicate filter families")
    return families


def mode_names(family):
    if family not in AVAILABLE_FAMILIES:
        raise ValueError("unknown filter family")
    modes = ("Serial", "Partitioned", "Atomic") if family == "FastPattern" else ("Serial", "Partitioned")
    return {family + mode for mode in modes}


def family_rows(rows, family):
    # Prefix matching would merge Split64Range with Split64 (and K12 with FourSector).
    names = mode_names(family)
    return [row for row in rows if row["filter"] in names]
