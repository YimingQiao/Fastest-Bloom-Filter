# Isolated natural-Poppy dependency resolution

The one offline Cargo metadata resolution completed with exit0, preserving all initial source bytes and the original parent lock. The new combined lock SHA is `0217d5c027f316089b1e3403c3081249ff7df5faca90160eaa0e67304ec19870`; it resolves 87 packages.

All 31 existing raw8 registry/git package identities and checksums remain. Comparing structured metadata independently shows no changed feature sets or resolved dependency identities for any of those 31 packages. Seven existing textual lock records gain version-disambiguation suffixes because parallel versions are newly present; they do not switch the original dependency. Cargo adds 53 packages (52 external packages plus the Poppy path crate); the renamed root accounts for the 54th added lock record. The complete added versions and both old/new records remain in package-diff.json, and normalized-graph-diff.json records the graph comparison. The two retained local dependency graphs (native and fastbloom-rs) also have unchanged features and resolved edges. No parent tree was edited.

All 87 existing parent source anchors and 32 tracked pinned-Poppy files match their recorded commits. Prepared package source trees contain 4,483 files across 87 packages, with per-file SHA256 and per-package attribution in prepared-package-trees.json. This is a prepared-source inventory, not a claim about actual compiler consumption. The focused driver must bind actual Cargo artifacts/dep-info before executing any test/filter.

Only Cargo version/metadata and source hashing ran under the socket1 CPU3 lock. No build, test, filter, calibration or timing command ran. Exact stdout/stderr, Cargo argv/version/hash, package metadata, source hashes and actual terminal tool outcomes are retained. The brief lease is released. The earlier source README/plan remains the immutable pre-resolution record.

Normal/ASan actual-caller correctness, full 28 public-form fixtures, typed/byte8 codegen and the bounded 146-row caller proposal still require final driver/source review and a separate execution grant. No performance or new quality conclusion follows from dependency resolution.
