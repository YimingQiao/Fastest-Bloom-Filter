#!/usr/bin/env python3
"""Create only the pre-data execution source/binary manifest."""
from pins import HERE,save,make_freeze
if __name__=='__main__':save(HERE/'freeze.json',make_freeze());print('Frozen exact actual caller, proposal, host and runner sources')
