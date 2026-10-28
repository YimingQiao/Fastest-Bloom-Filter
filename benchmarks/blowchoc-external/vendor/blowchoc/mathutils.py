"""
mathutils.py
This module provides math utility functions:

bitsfor(n) = number of bits needed to distinguish n numbers, ceil(log2(n))
nextpower(n) = smallest 2**m >= n
nextodd(n) = n if n is odd, else n+1

lngamma(x) = ln(Gamma(x))
lnbinom(n,k) = ln(n choose k)

logsum(x) = log(sum(exp(x)) for an array x
logsum2(x,y) = log(exp(x)+exp(y)) for two numbers x,y

inversemodprime(a, p) = multiplicative inverse of a (mod prime p)
inversemodpow2(a, m) = multiplicative inverse of a (mod m==2**k for some k)
"""


from math import ceil, exp, log, log2, log1p, sqrt, pi
import numpy as np
from numba import njit, float64, int64


def bitsfor(k):
    """Return number of bits required to distinguish k objects (e.g., 0..(k-1))"""
    if k == 0:
        return 0
    return int(ceil(log2(k)))


def xbitsfor(k):
    """Return integer and fractional number of bits required to distinguish k objects (e.g., 0..(k-1))"""
    if k == 0:
        return (0, 0.0)
    f = log2(k)
    return (int(ceil(f)), f)


def nextpower(k):
    """Return the smallest power of 2 that is >= k"""
    if k <= 1:
        return 1  # 2 ** 0
    b = int(ceil(log2(k)))
    return 2 ** b


def prevpower(k):
    """Return the largest power of 2 that is < k (or 1 if k==0)"""
    # TODO: check what this does exactly and what is needed
    return nextpower(k) // 2


def nextodd(n):
    """return n if n is odd; otherweise return n+1"""
    n = int(n)
    return n if (n % 2 != 0) else n + 1


def compile_lngamma_lnbinom():
    """
    Lanczos's approximation to log(Gamma).
    This works by taking Stirling's formula, with Gamma(1+n) = n!, and putting
    in corrections for the first few poles in Gamma: for some whole g, N:
      Gamma(z+1) = pow(z +g +.5, z +.5)*exp(-(z +g +.5)) *sqrt(2*pi) *series
      with series = a + b/(z+1) +... +c/(z+N)
      for suitable constants a, b, ..., c
    Substitute x = z+1 to turn this into
      Gamma(x) = pow(x +g -.5, x -.5) *exp(-(x +g -.5)) *sqrt(2*pi) *series
      with series = a + sum(: coefficients[i]/(x+i) &larr; i :)
      for suitable a.
    Interestingly, Numerical Recipies (without explaining itself) uses Gamma(z)
    = Gamma(z+1)/z rather than substitution, as here; it also asserts that the
    error in the above requires a correction of less than 2e-10 in the series,
    for z with positive real part.
    """
    coefficients = (76.18009172947146, -86.50532032941677,
        24.01409824083091, -1.231739572450155,
        0.1208650973866179e-2, -0.5395239384953e-5)
    scale = sqrt(2 * pi)
    ln = log
    MINF = -np.inf

    @njit(nogil=True, locals=dict(
        x=float64, base=float64, s=float64, c=float64))
    def lngamma(x):
        base = x + 4.5
        base = (x - 0.5) * ln(base) - base
        s = 1.000000000190015
        for c in coefficients:
            s += c / x
            x = 1.0 + x
        return base + ln(scale * s)

    @njit(
        nogil=True, locals=dict(x=float64))
    def lnbinom(n, k):
        """return ln(n choose k) by approximation via lngamma."""
        # (n choose k) = n! / (k! * (n-k)!)
        if k > n or k < 0:
            return MINF
        x = lngamma(n + 1) - lngamma(k + 1) - lngamma(n - k + 1)
        return x

    return lngamma, lnbinom


lngamma, lnbinom = compile_lngamma_lnbinom()


@njit(nogil=True, locals=dict(z=float64))
def logsum2(x, y):
    # log(a+b) = log(a) + log1p(exp(log(b)-log(a)))
    if x < y:
        z = y + log1p(exp(x - y))
    else:
        z = x + log1p(exp(y - x))
    return z


@njit(nogil=True, locals=dict(L=int64, ibig=int64, big=float64, s=float64))
def logsum(x):
    """
    Return log(sum(exp(x))) without actually exponentiating all of x.
    In other words, compute the log sum of the elements in x
    when only their logarithms are given.
    The idea is to factor out the largest element.
    """
    L = x.size
    if L >= 3:
        ibig = np.argmax(x)
        y = x[:ibig]
        z = x[ibig + 1:]
        big = x[ibig]
        s = np.sum(np.exp(y - big)) + np.sum(np.exp(z - big))
        return big + np.log1p(s)
    if L == 2:
        return logsum2(x[0], x[1])
    if L == 1:
        return x[0]
    return -np.inf


"""
General note on multiplicative inverseses:
a has an inverse mod m iff gcd(a,m) == 1.

If p = m is prime, every a in 1..p-1  has an inverse.
If m is a power of 2, every odd number a has an inverse.

The multiplicative inverse y of a can be computed as follows
- by the extended euclidean algorithm,
- using Euler's totient function phi: y = a**(phi(m)-1),
  because a*y == a**phi(m) == 1 iff gcd(a,m) == 1.
The totient function phi(m) 
is the number of integers i in {1..m} with gcd(i,m) = 1.
If p=m is prime, then y = a**(m-2) because phi(p) == m-1.
If m is a power of 2, then all odd numbers i satisfy gcd(i,m) = 1,
hence phi(m) = m//2.
"""


def inversemodprime(a, p):
    """
    compute multiplicative inverse of a mod p,
    i.e. y such that ay=ya=1 (mod p) when p is prime.
    (This will fail if p is not prime!)
    """
    y = pow(a, p - 2, p)
    assert (a * y) % p == 1, f"p={p} is not prime"
    return y


def inversemodpow2(a, m):
    """
    compute multiplicative inverse of a mod m,
    i.e. y such that ay=ya=1 (mod m) when m is a power of 2.
    (This will fail if m is not a power of 2, or if a is even.)
    """
    y = pow(a, m // 2 - 1, m)
    assert (a * y) % m == 1, f"either a={a} is even or m={m} is not a power of 2"
    return y


def nextprime(n):
    raise RuntimeError("nextprime() not available")


# counting and occupancy ###############################

def print_histogram(hist, *, title=None, shorttitle="",
        fractions=None, average="",
        zeros=False, nonzerofrac=False, emptyline=True):
    """
    Print histogram 'hist' (a numpy array or list) to stdout,
    with optional formatting (title), percentages or fractions.
    """
    if shorttitle:
        shorttitle += " "
    hist_string = []

    s0 = np.sum(hist)
    s1 = s0 - hist[0]
    if s0 == 0.0:
        s0 = 1.0
    if s1 == 0.0:
        s1 = 1.0
    if not fractions:
        s = s0
    elif "+" in fractions:
        s = s1
        nonzerofrac = True
    else:
        s = s0

    BASIC_FORMAT = "{}: {}"
    if not fractions:
        FRAC_FORMAT = ""
    elif "%" in fractions:
        FRAC_FORMAT = " ({:.3%})"
    elif "." in fractions:
        FRAC_FORMAT = " ({:.4f})"
    fmt = BASIC_FORMAT + FRAC_FORMAT

    n = hist.shape[0]
    if average is False or average == "":
        a = atype = None
    elif average is True or "0" in average:
        div = np.sum(hist)
        a = np.dot(np.arange(n), hist) / div if div > 0.0 else 0.0
        atype = "all"
    elif "+" in average:
        div = np.sum(hist[1:])
        a = np.dot(np.arange(1, n), hist[1:]) / div if div > 0.0 else 0.0
        atype = "positive"

    # loop
    for i, freq in enumerate(hist):
        if freq == 0 and not zeros:
            continue  # skip zeros
        rel = freq / s
        myfmt = BASIC_FORMAT if (i == 0 and nonzerofrac) else fmt
        hist_string.append(myfmt.format(i, freq, rel))
        myfmt = fmt

    if nonzerofrac:
        hist_string.append(("{}nonzero: {}" + FRAC_FORMAT).format(shorttitle, s1, s1 / s0))
    if a is not None:
        hist_string.append(f"{shorttitle}average [{atype}]: {a:.4f}")
    print(title, "\n")
    hist_string = "- " + "\n- ".join(hist_string)
    print(hist_string)
    if emptyline:
        print()


def print_histogram_tail(hist, counts, *, title=None, shorttitle="",
            average="", emptyline=True):
    """
    Print extreme tail of histogram 'hist' (a numpy array or list) to stdout,
    with optional formatting (title), or average.
    """
    # if title: print(title)
    if shorttitle:
        shorttitle += " "
    hist_string = []

    counts = sorted(counts)
    m = len(counts)
    j = 0
    s = 0
    n = hist.shape[0]  # last value is n-1
    for i in range(n - 1, -1, -1):
        c = hist[i]
        s += c
        while j < m and s >= counts[j]:
            hist_string.append(f"{i}+: {s}x")
            j += 1

    if average is False or average == "":
        a = atype = None
    elif average is True or "0" in average:
        a = np.dot(np.arange(n), hist) / np.sum(hist)
        atype = "all"
    elif "+" in average:
        a = np.dot(np.arange(1, n), hist[1:]) / np.sum(hist[1:])
        atype = "positive"

    if a is not None:
        hist_string.append(f"{shorttitle}average [{atype}]: {a:.4f}")
    # hist_string = "\n".join(hist_string)
    print("##", title, "\n")
    hist_string = "- " + "\n- ".join(hist_string)
    print(hist_string)
    if emptyline:
        print()
