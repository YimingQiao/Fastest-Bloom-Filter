"""Offline source guards: no compiler, filter, performance data or subprocess tests."""
import ast
import unittest
from unittest.mock import patch
import repair_guard as guard


class RepairTests(unittest.TestCase):
    def test_exact_wrapper_six_names(self):
        text = guard.wrapper()
        self.assertEqual(text.count('using bloom_filters::'), 6)
        self.assertNotIn('using namespace', text)
        self.assertTrue(text.endswith('#include "../caller/main.cpp"\n'))
        self.assertEqual((guard.HERE / 'main.cpp').read_text(), text)

    def test_include_order_unchanged(self):
        includes = [line for line in (guard.PARENT / 'adapters.hpp').read_text().splitlines()
                    if line.startswith('#include')][:7]
        expected = ['#include "' + name + '"' for name in guard.NATIVE_HEADERS]
        self.assertEqual(includes, expected)

    def test_products_exact_and_cmake_unchanged(self):
        guard.verify_products()
        self.assertEqual((guard.HERE / 'CMakeLists.txt').read_bytes(),
                         (guard.PARENT / 'CMakeLists.txt').read_bytes())

    def test_driver_exec_body_unchanged(self):
        old = (guard.PARENT / 'validate.py').read_text()
        new = (guard.HERE / 'validate.py').read_text()
        self.assertEqual(old[old.index('    commands=[];'):], new[new.index('    commands=[];'):])
        self.assertIn("PARENT=HERE.parent/'caller'", new)
        self.assertIn("OUT=HERE/'validation-v2'", new)
        self.assertNotIn('validation-v1', new)
        self.assertIn("str((PARENT/name).resolve())", new)
        self.assertIn("str((HERE/'main.cpp').resolve())", new)

    def test_parent_drift_rejected(self):
        old = (guard.PARENT / 'validate.py').read_text()
        with self.assertRaisesRegex(ValueError, 'unexpected parent driver substitution'):
            guard.driver(old.replace("OUT=HERE/'validation-v1'", "OUT=HERE/'unknown'"))

    def test_immutable_ref_rejected_without_git(self):
        with patch.object(guard.subprocess, 'check_output') as git:
            for value in ('HEAD', 'd0b9a90', 'A' * 40):
                with self.assertRaises(ValueError):
                    guard.blob(value, guard.PARENT / 'main.cpp')
            git.assert_not_called()

    def test_python_sources_parse(self):
        for name in ('derive.py', 'repair_guard.py', 'validate.py', 'test_repair.py'):
            ast.parse((guard.HERE / name).read_text(), filename=name)


if __name__ == '__main__':
    unittest.main()
