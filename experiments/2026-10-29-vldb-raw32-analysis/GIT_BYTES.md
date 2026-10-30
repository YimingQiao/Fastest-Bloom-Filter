# Preserve the measured analysis bytes in Git

The first report commit, `2127fd10c02c255332769305ea55b3a40fc128b4`, allowed Git's
text normalization to turn the six generated CSV files' CRLF line endings into
LF. Their working files and the sealed `FINAL_ANALYSIS_ARCHIVE.json` remained
unchanged, but those six initial Git blobs did not match the archive hashes.

The additive repair sets `*.csv -text` and stages those original working bytes.
It verifies every staged archive member against the original manifest before
commit. No values, analysis rules, input records, raw evidence, or manifest were
changed. The original report commit remains in history; use the repaired commit
or its descendants to reproduce the exact archived CSV bytes.
