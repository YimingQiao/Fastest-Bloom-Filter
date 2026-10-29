#!/usr/bin/env python3
"""Source-only repair derivation; never invokes a compiler or filter."""
import argparse
import repair_guard as guard


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    guard.parents()
    if args.write:
        for name, expected in guard.products().items():
            (guard.HERE / name).write_bytes(expected)
    guard.verify_products()
    print('Exact namespace-only wrapper and V2 driver derivation verified.')


if __name__ == '__main__':
    main()
