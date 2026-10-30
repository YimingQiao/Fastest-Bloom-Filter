import unittest
from recover import instructions
class Checks(unittest.TestCase):
    def test_empty_header_is_not_instructions(self):
        self.assertEqual(instructions('Disassembly of section .text:\n000056060 <name>:\n'),[])
    def test_actual_address_lines(self):
        self.assertEqual(instructions('0000000000056060 <name>:\n   56060:\tpush %rbp\n   56061: mov %rsp,%rbp\n'),[0x56060,0x56061])
if __name__=='__main__':unittest.main()
