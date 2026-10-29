import unittest
from pathlib import Path
from dependencies import select_dep_base

class WorkspaceBase(unittest.TestCase):
    def setUp(self):
        self.owner=dict(manifest='/workspace/control/Cargo.toml',source='/workspace/control/src/lib.rs',workspace_root='/workspace')
    def test_workspace_relative(self):
        self.assertEqual(select_dep_base(['control/src/lib.rs','control/src/module.rs'],self.owner),Path('/workspace'))
    def test_package_relative(self):
        self.assertEqual(select_dep_base(['src/lib.rs','src/module.rs'],self.owner),Path('/workspace/control'))
    def test_root_deduplicated(self):
        owner=dict(manifest='/workspace/Cargo.toml',source='/workspace/main.rs',workspace_root='/workspace')
        self.assertEqual(select_dep_base(['main.rs'],owner),Path('/workspace'))
    def test_ambiguous_rejected(self):
        with self.assertRaises(ValueError):select_dep_base(['src/lib.rs','control/src/lib.rs'],self.owner)
    def test_absent_rejected(self):
        with self.assertRaises(ValueError):select_dep_base(['other/src/lib.rs'],self.owner)
    def test_wrong_workspace_rejected(self):
        with self.assertRaises(ValueError):select_dep_base(['control/src/lib.rs'],dict(self.owner,workspace_root='/wrong'))

if __name__=='__main__':unittest.main()
