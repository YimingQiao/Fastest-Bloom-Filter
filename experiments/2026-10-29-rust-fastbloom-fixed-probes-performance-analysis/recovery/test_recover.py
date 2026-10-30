import copy
import unittest
from recover import COMMIT,IMMUTABLE,restore

class Recovery(unittest.TestCase):
    def fixtures(self):
        final={key:'fixed'for key in IMMUTABLE}
        final.update(source_commit=COMMIT,complete=True,cases=18,rows=336)
        checkpoint=copy.deepcopy(final);checkpoint.update(complete=False,cases=[dict(complete=True,returncode=0,index=i)for i in range(18)])
        return final,checkpoint
    def test_only_exact_ledger_restored(self):
        final,checkpoint=self.fixtures();before=copy.deepcopy(final)
        result=restore(final,checkpoint)
        self.assertEqual(final,before);self.assertEqual(result['cases'],checkpoint['cases']);self.assertEqual(result['case_count'],18)
        for field in final:
            if field!='cases':self.assertEqual(final[field],result[field])
    def test_partial_or_failed_checkpoint_rejected(self):
        for kind in ['missing','failed','notcomplete','alreadyfinal']:
            final,checkpoint=self.fixtures()
            if kind=='missing':checkpoint['cases'].pop()
            elif kind=='failed':checkpoint['cases'][0]['returncode']=1
            elif kind=='notcomplete':checkpoint['cases'][0]['complete']=False
            else:checkpoint['complete']=True
            with self.assertRaises(ValueError):restore(final,checkpoint)
    def test_changed_identity_rejected(self):
        for key in IMMUTABLE:
            final,checkpoint=self.fixtures();checkpoint[key]='changed'
            with self.assertRaises(ValueError):restore(final,checkpoint)
    def test_not_completed_rejected(self):
        final,checkpoint=self.fixtures();final['complete']=False
        with self.assertRaises(ValueError):restore(final,checkpoint)

if __name__=='__main__':unittest.main()
