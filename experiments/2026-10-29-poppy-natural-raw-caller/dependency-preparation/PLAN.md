# Combined dependency graph preparation

No Cargo command has run for the new caller. `parent-raw8-Cargo.lock` is the exact d237912 source lock; `parent-poppy-Cargo.lock` is the exact2350904 prehashed-Poppy caller lock. `parent-package-comparison.json` compares source package sets only. A name with different version sets is not automatically a replacement: separate transitive versions may coexist. The final report must distinguish additions from removal or replacement of an existing raw8 package identity.

The new Cargo.toml references the immutable raw8 native and fastbloom-rs source directories, unchanged public Fastbloom0.17/Bloomsday/SBBF dependencies, and Poppy's existing checkout at exact992a13e27e8b09b2a832333a4ba3d160545fa866. No upstream private API or crate edit is needed. Existing source dependencies stay unchanged.

After this concrete source/package comparison is reviewed, copy the original raw8 lock into the new benchmark directory and resolve metadata without compiling. Record exact Cargo argv/tool identity, upstream revision/clean state, full output/error and final lock. Compare every original registry/git package identity (name/version/source/checksum) with the new graph; any removed/replaced package or changed feature/target set must be reviewed explicitly. Pin every resolved package tree and local manifest before the later focused compiler gate. Do not silently regenerate or mutate a parent's lock.

The combined graph is a new actual caller context. The old raw8 ELF and old Poppy ELF do not prove new inlining, native/portable behavior or performance. Normal/ASan correctness and exact-address ASM must follow the final locked source and consumed-input proof. No formal panel is selected by dependency resolution.
