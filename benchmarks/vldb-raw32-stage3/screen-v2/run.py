#!/usr/bin/env python3
"""Delegate to the frozen728-row runner with additional retry-source guards."""
from guards import verify,checked_freeze
import run_screen as original

original_frozen=original.frozen
original.verify=verify
original.frozen=lambda commit:checked_freeze(original_frozen,commit)

if __name__=='__main__':original.main()
