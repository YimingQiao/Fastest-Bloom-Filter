# Native snapshot object availability

The actual-native proof source is committed at
`26232ad9b1412e64346e09f40de15f8ef77c52f7`. Its immutable inputs use native before
`e8b89cd3c7c090287d1d4222db981ec7f8fb86ab` and native after
`2b3469f02c8dafc2219a132c681c14529e79995d`.

The parent will publish the isolated after branch as
`refs/heads/experiment/native-build-policy-port`. A fresh clone must fetch that
reference before running the exact commit-identity checks:

```sh
git fetch origin refs/heads/experiment/native-build-policy-port
git cat-file -e e8b89cd3c7c090287d1d4222db981ec7f8fb86ab^{commit}
git cat-file -e 2b3469f02c8dafc2219a132c681c14529e79995d^{commit}
```

The guard uses the exact objects above, never a moving branch tip. Publishing
this experimental reference preserves reproducibility without merging the
bounded policy into the default branch. The source snapshots are also archived
locally in `proof/native/`; derivation still verifies their committed origins.
This additive note changes neither frozen manifest nor any measured source and
makes no claim that native performance confirmation has completed.
