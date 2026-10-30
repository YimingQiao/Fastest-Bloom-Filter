import collections,copy,csv,json,tempfile,unittest
from unittest.mock import patch
from pathlib import Path
from contract import validate,geometry_cases,validate_geometry,schedule,domains
from startup_guards import require_new_build_root,require_inherited_write_lock
P=json.loads((Path(__file__).parent/'protocol.json').read_text())

class ContractTests(unittest.TestCase):
    def test_build_root_must_be_absent(self):
        with tempfile.TemporaryDirectory() as root:
            p=Path(root)
            require_new_build_root(p/'new-build')
            (p/'file').write_text('stale');(p/'dangling').symlink_to(p/'missing')
            for existing in (p,p/'file',p/'dangling'):
                with self.assertRaises(ValueError):require_new_build_root(existing)
    def test_actual_inherited_flock(self):
        with patch('startup_guards.os.sched_getaffinity',return_value={2}), \
             patch('startup_guards.os.listdir',return_value=['7']), \
             patch('startup_guards.os.readlink',return_value='/tmp/fastest-bf-socket0.lock'), \
             patch('startup_guards.Path.read_text',return_value='pos:\t0\nlock:\t1: FLOCK ADVISORY WRITE 123 00:01:23 0 EOF\n'):
            self.assertEqual(require_inherited_write_lock(2,'socket0'),[7])
    def test_open_or_shared_or_posix_fd_is_not_lease(self):
        for info in ('pos:\t0\n','lock:\t1: FLOCK ADVISORY READ 123 00:01:23 0 EOF\n',
                     'lock:\t1: POSIX ADVISORY WRITE 123 00:01:23 0 EOF\n'):
            with patch('startup_guards.os.sched_getaffinity',return_value={2}), \
                 patch('startup_guards.os.listdir',return_value=['7']), \
                 patch('startup_guards.os.readlink',return_value='/tmp/fastest-bf-socket0.lock'), \
                 patch('startup_guards.Path.read_text',return_value=info):
                with self.assertRaises(ValueError):require_inherited_write_lock(2,'socket0')
    def test_wrong_lease_or_affinity_rejected(self):
        with self.assertRaises(ValueError):require_inherited_write_lock(3,'socket1')
        with patch('startup_guards.os.sched_getaffinity',return_value={2,4}):
            with self.assertRaises(ValueError):require_inherited_write_lock(2,'socket0')
    def test_registry(self):
        validate(P);self.assertEqual(len(geometry_cases(P)),56)
        self.assertEqual(len(P['workers']['legacy']['original_configs'])*3+4,25)
        self.assertEqual(len(P['workers']['modern']['external'])+4,23)
    def test_selection_is_frozen_leader_union(self):
        root=Path(__file__).resolve().parents[2]
        a,b=P['selection']['source_files']
        with (root/a).open() as stream: rows=list(csv.DictReader(stream))
        exact={r['filter'] for r in rows if r['implementation_origin']=='external'}
        visible=json.loads((root/b).read_text())
        single={r['external']['filter'] for r in visible['comparisons'] if r['external']}
        self.assertEqual(sorted(exact),P['selection']['exact_external_union'])
        self.assertEqual(sorted(single),P['selection']['visible_external_union'])
    def test_complete_phase_schedule(self):
        for seed in (0,1,42,0xffffffff):
            s=schedule(seed,6)
            self.assertEqual(len(set(s)),6)
            for pos in range(3): self.assertEqual(collections.Counter(x[pos] for x in s),{0:2,1:2,2:2})
            self.assertEqual(set(collections.Counter((x[i],x[i+1]) for x in s for i in range(2)).values()),{2})
    def test_incomplete_phase_block_rejected(self):
        for n in (0,1,5,7):
            with self.assertRaises(ValueError):schedule(42,n)
    def test_no_context_correction(self):
        p=copy.deepcopy(P);p['screen']['context_shift_correction']=True
        with self.assertRaises(ValueError):validate(p)
    def test_both_launch_orders(self):
        p=copy.deepcopy(P);p['screen']['worker_orders'][1]=['legacy','modern']
        with self.assertRaises(ValueError):validate(p)
    def test_no_alias_pooling(self):
        p=copy.deepcopy(P);p['screen']['pool_alias_calibration']=True
        with self.assertRaises(ValueError):validate(p)
    def test_disjoint_domains(self):
        self.assertEqual(domains(1<<25,1<<22,1<<24,50),(2097154,2097150))
        with self.assertRaises(ValueError):domains(0xffffffff,2,1,0)
    def test_geometry_padding_and_metadata(self):
        case=('sector32-u1',16,12)
        row=dict(budget_bytes=98304,constructor_bits=3071*32*8,logical_bytes=3071*32,backing_bytes=98304,block_count=3071,address='magic',digest=0,bitmap_digest=0,
                 upstream_metadata=dict(size=3071*32,word_size=4,w=8,s=8,k=8,u=1,addr='magic'))
        validate_geometry(row,case)
        for field,value in [('backing_bytes',98305),('address','pow2'),('logical_bytes',98304)]:
            bad=copy.deepcopy(row);bad[field]=value
            with self.assertRaises(ValueError):validate_geometry(bad,case)
        bad=copy.deepcopy(row);bad['upstream_metadata']['u']=4
        with self.assertRaises(ValueError):validate_geometry(bad,case)
    def test_paired_native_controls(self):
        p=copy.deepcopy(P);p['workers']['legacy']['native_controls'].pop()
        with self.assertRaises(ValueError):validate(p)

if __name__=='__main__':unittest.main()
