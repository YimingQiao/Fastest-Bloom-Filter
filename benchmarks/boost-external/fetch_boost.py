#!/usr/bin/env python3
"""Fetch pinned Boost headers, verifying the official release archive hash."""
import hashlib
from pathlib import Path
import tarfile
import shutil
import urllib.request

ROOT = Path(__file__).resolve().parent / '.deps'
VERSION = 'boost_1_92_0'
URL = 'https://archives.boost.io/release/1.92.0/source/boost_1_92_0.tar.bz2'
SHA256 = '5c1d40cb8e19adbf740a4ec2da35b3e58f3f5804b1dce44deb53df72193cbc6c'


def main():
    ROOT.mkdir(exist_ok=True)
    archive_path = ROOT / (VERSION + '.tar.bz2')
    if not archive_path.exists():
        print('Downloading pinned Boost 1.92.0 archive', flush=True)
        temporary = archive_path.with_suffix('.part')
        urllib.request.urlretrieve(URL, temporary)
        temporary.rename(archive_path)
    # macOS installations can still use Python 3.9/3.10 (no file_digest).
    hasher = hashlib.sha256()
    with archive_path.open('rb') as source:
        for block in iter(lambda: source.read(1024 * 1024), b''):
            hasher.update(block)
    digest = hasher.hexdigest()
    if digest != SHA256:
        raise RuntimeError(f'Boost archive SHA-256 mismatch: {digest}')
    marker = ROOT / VERSION / 'boost/version.hpp'
    stamp = ROOT / VERSION / '.headers-extracted.sha256'
    if not stamp.exists() or stamp.read_text().strip() != SHA256:
        with tarfile.open(archive_path) as archive:
            members = [m for m in archive.getmembers()
                       if m.name.startswith(VERSION + '/boost/')
                       or m.name == VERSION + '/LICENSE_1_0.txt']
            for member in members:
                target = (ROOT / member.name).resolve()
                if not target.is_relative_to(ROOT.resolve()):
                    raise RuntimeError('Archive path escapes dependency directory')
                if member.isdir():
                    target.mkdir(parents=True, exist_ok=True)
                elif member.isfile():
                    target.parent.mkdir(parents=True, exist_ok=True)
                    with archive.extractfile(member) as source, target.open('wb') as dest:
                        shutil.copyfileobj(source, dest)
                else:
                    raise RuntimeError('Unexpected link or special file in headers')
        stamp.write_text(SHA256 + '\n')
    print(f'Boost 1.92.0 headers: {marker.parent.parent}')


if __name__ == '__main__':
    main()
