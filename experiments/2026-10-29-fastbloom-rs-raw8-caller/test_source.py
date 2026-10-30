import unittest,re
import source_guard as guard
class SourceTests(unittest.TestCase):
 def test_closed_source_recipes_and_dependency_identities(self):
  result=guard.verify();self.assertEqual(result['raw_apis'],45)
 def test_release_body_excludes_only_test_observation(self):
  guard.release_identity()
  value='value();\n#[cfg(test)] crate::tests::lifecycle("event");\nnext();'
  self.assertEqual(guard.strip_test_hooks(value),'value();\nnext();')
  self.assertIn('fn run_raw', (guard.HERE/'benchmark/src/reporter.rs').read_text())
 def test_required_faults_and_allocation_events_are_present(self):
  tests=(guard.HERE/'authored/reporter_tests.rs').read_text()
  self.assertIn('skip_last_and_wrong_value_faults_fail_after_valid_warmups_in_both_modes',tests)
  self.assertIn('trace_check::<crate::raw_contract::CommonHash<PreparedSpy>>',tests)
  self.assertIn('trace_check::<DirectSpy>',tests)
  for phase in ['complete_start','scratch_ready','filter_ready','insert_done','validated','build_dropped','canonical_scratch_dropped','query_scratch_ready']:
   self.assertIn('"'+phase+'"',tests)
if __name__=='__main__':unittest.main()
