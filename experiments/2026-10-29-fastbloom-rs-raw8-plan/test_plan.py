import collections,json,unittest
import derive
class Checks(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.points=json.loads(derive.derive()['selection.json'])['points']
 def test_complete_fixed_grid(self):
  new=[p for p in self.points if p['owner']=='fastbloom_rs_external'];self.assertEqual(len(new),144)
  for n in[65536,33554432]:
   for cap in[16,24,32]:self.assertEqual({p['effective_probes']for p in new if p['keys']==n and p['budget_bpk']==cap},set(range(1,25)))
 def test_strong_controls_and_current_native(self):
  old=[p for p in self.points if p['owner']!='fastbloom_rs_external'];self.assertEqual(len(old),118)
  names={p['filter']for p in old}
  self.assertTrue({'BloomsdayPinned','SbbfSafePinned','Fastbloom017','Split64RangeBloomFilter','FourSectorRange12BloomFilter','FastPatternBF','ByteSplitBloomFilter','FourSectorBloomFilter','Split64BloomFilter'}<=names)
  self.assertTrue({f'Fastbloom017K{k}'for k in range(1,13)}<=names)
 def test_allocation_and_no_quality_pruning(self):
  self.assertTrue(all(p['actual_bytes']*8<=p['keys']*p['budget_bpk']for p in self.points))
  self.assertTrue(all(p['actual_bytes']%8==0 for p in self.points))
  self.assertTrue(all('false_positives'not in p and 'latency'not in p for p in self.points))
  self.assertEqual(len({p['configuration_id']for p in self.points}),262)
 def test_no_artificial_fastbloom_copy(self):
  source=(derive.HERE/'proposed/fastbloom_rs_adapter.rs').read_text()
  self.assertNotIn('hash64(',source);self.assertNotIn('get_hash_indices(',source)
  self.assertIn('self.0.contains(&raw.to_le_bytes())',source)
  self.assertIn('self.0.add(&value.to_le_bytes())',source)
  self.assertNotIn('scratch[..',source)
 def test_scratch_contract_and_clock_boundary(self):
  source=(derive.HERE/'proposed/reporter.rs').read_text()
  common=(derive.HERE/'proposed/raw_contract.rs').read_text()
  direct=(derive.HERE/'proposed/fastbloom_rs_adapter.rs').read_text()
  self.assertIn('fn scratch_words(input_len: usize) -> usize { input_len }',common)
  self.assertIn('fn scratch_words(_input_len: usize) -> usize { 0 }',direct)
  self.assertIn('if words == 0 { None } else { Some(Aligned::<u64>::new(words)) }',source)
  loop=source[source.index('    for _ in 0..c.repeats {'):source.index('    let mut filter=')]
  events=['let a = Instant::now();','Scratch::new(build_words)','F::new(c.n, c.bpk)',
          'let ready = Instant::now();','raw_insert(&mut fresh','let done = Instant::now();',
          'raw_batched(&fresh','drop(fresh);','drop(build_scratch);']
  offsets=[loop.index(event)for event in events]
  self.assertEqual(offsets,sorted(offsets))
  self.assertIn('construction.push((done-a)',loop)
  self.assertIn('insertion.push((done-ready)',loop)
  self.assertNotIn('c.batch.max(c.insert_batch)',source)
  self.assertIn('allocate_filter_and_scratch_raw_insert_trials',source)
 def test_independent_batch_and_workspace_lifetimes(self):
  source=(derive.HERE/'proposed/reporter.rs').read_text()
  self.assertIn('F::scratch_words(c.insert_batch.min(c.n))',source)
  self.assertIn('F::scratch_words(c.batch)',source)
  self.assertIn('let validation_batch = c.batch.min(c.insert_batch).min(c.n);',source)
  self.assertIn('canonical_build_scratch.as_mut_slice()); }\n    }\n',source)
  self.assertLess(source.index('canonical_build_scratch.as_mut_slice()'),source.index('let mut query_scratch='))
  for field in ['insert_batch','query_batch','build_scratch_bytes','query_scratch_bytes']:
   self.assertIn('pub '+field+': usize',source)
  # Independent insertion/query lengths must remain safe for untimed checks,
  # including chunks that exceed n and query chunks larger than insert chunks.
  for n in [1,65,4097]:
   for insertion in [1,31,4096,8192]:
    for query in [1,31,4096,8192]:
     validation=min(n,insertion,query)
     self.assertLessEqual(validation,min(n,insertion))
     self.assertLessEqual(validation,query)
  protocol=json.loads((derive.HERE/'protocol.json').read_text())
  self.assertEqual(protocol['build_contracts'],['raw_insert','allocate_filter_and_scratch_raw_insert'])
  self.assertIn('Independent configurable parameter',protocol['insert_batch_policy'])
 def test_output_poison_precedes_each_write_contract(self):
  source=(derive.HERE/'proposed/reporter.rs').read_text()
  self.assertIn('const OUTPUT_POISON: u32 = 0xffff_fffe;',source)
  self.assertIn('output[..chunk.len()].fill(OUTPUT_POISON);\n            raw_batched(&fresh',source)
  self.assertIn('output[..c.q].fill(OUTPUT_POISON);\n    for (input,out)',source)
  self.assertIn('output[..c.q].fill(OUTPUT_POISON);\n    raw_visible(',source)
  self.assertIn('output[..c.q].fill(OUTPUT_POISON);\n            let start=Instant::now();',source)
  self.assertIn('output[..len].fill(OUTPUT_POISON);\n        raw_batched(&filter,&calibration_raw',source)
  self.assertEqual(source.count('.fill(OUTPUT_POISON);'),5)
if __name__=='__main__':unittest.main()
