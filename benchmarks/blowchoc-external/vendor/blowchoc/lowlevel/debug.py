"""
Define debugging/timing tools.
"""

from datetime import datetime as dt
from numba import njit


def _do_nothing(*args):
    pass


def _do_nothing_assert(statement, module_name, statement_string, parameters, message=None):
    pass


def _do_nothing_ts(*args, **kwargs):
    pass


def _timestamp(previous=None, msg=None, minutes=False):
    now = dt.now()
    if previous is not None and msg is not None:
        elapsed_sec = (now - previous).total_seconds()
        if minutes:
            elapsed_min = elapsed_sec / 60.0
            print(f"{msg}: {elapsed_min:.2f} min")
        else:
            print(f"{msg}: {elapsed_sec:.1f} sec")
    elif msg is not None:
        print(f"{msg} [{now:%Y-%m-%d %H:%M:%S}]")
    return now

#__line__ __name__
def dassert1(statement, module_name, statement_string, parameters, message=None):
    assert statement


def dassert2(statement, module_name, statement_string, parameters, message=None):
    if not statement:
        print()
        print(f'ASSERTION in module {module_name}')
        if message:
            print(message)
        print(f'Checking {statement_string}')
        print(f'Parameters: {parameters}')
        print()
    assert statement


def set_debugfunctions(*, debug=0, timestamps=0, compile=True):
    # debug = 0: No debug prints and asserts
    # debug = 1: No debug prints level 1 and asserts are checked
    # debug = 2: No debug prints level 2 and asserts are checked
    # debug = 3: No debug prints level 3 and asserts are checked
    # debug = 4: No debug prints level 3 and asserts are checked in combination with print messages and position

    # define different debug print level
    dp0 = print if debug >= 0 else njit(nogil=True)(_do_nothing) if compile else _do_nothing
    dp1 = print if debug >= 1 else njit(nogil=True)(_do_nothing) if compile else _do_nothing
    dp2 = print if debug >= 2 else njit(nogil=True)(_do_nothing) if compile else _do_nothing
    # define different debug timestamp level
    ts0 = _timestamp if timestamps >= 0 else _do_nothing_ts
    ts1 = _timestamp if timestamps >= 1 else _do_nothing_ts
    ts2 = _timestamp if timestamps >= 2 else _do_nothing_ts
    # define different debug assert level
    if debug == 0:
        da = njit(nogil=True)(_do_nothing_assert) if compile else _do_nothing_assert
    elif debug <= 3:
        da = njit(nogil=True)(dassert1) if compile else dassert1
    elif debug >= 4:
        da = njit(nogil=True)(dassert2) if compile else dassert2

    global debugprint
    global timestamp
    global dassert
    debugprint = dp0, dp1, dp2
    timestamp = ts0, ts1, ts2
    dassert = da

    return debugprint, timestamp, dassert


set_debugfunctions()


def deprecated(msg):
    if isinstance(msg, str):
        def _decorator(f):
            def _wrapped_f(*args, **kwargs):
                raise RuntimeError(msg)
            return _wrapped_f
        return _decorator
    else:
        def _wrapped_f(*args, **kwargs):
            raise RuntimeError(msg)
        return _wrapped_f
