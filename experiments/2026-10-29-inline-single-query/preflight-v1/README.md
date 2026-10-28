# Inline single-query preflight v1 archive

The experiment sources, logs, assembly audit, freeze and validation records are retained under `experiment/`. `path-map.json` maps every original file path to its archived copy and SHA-256, including pinned transitive non-system headers found in compiler dependency files. System headers are identified with the compiler version instead of copied. The three original build directories and all twelve binaries are retained in place with verified hashes; v2 must use different build directories. No timing matrix ran in v1.

Dependency files are content-addressed to preserve ignored downloaded headers without copying unrelated Boost distribution files. The mapping permits restoration of the original paths into a separate checkout.
