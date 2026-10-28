# Unforced direct-Boost preflight V2

This immutable intermediate preserves all sources, logs, freeze data and all 120 outer-loop assembly functions before adding BOOST_FORCEINLINE to the local forwarding shim. Native18, ASan18 and full60 correctness passed. The assembly audit records six calls to the local ScalarContains shim (three Boost configurations, raw and pure), and deliberately failed its no-adapter-call assertion. The upstream may_contain API already uses BOOST_FORCEINLINE. No performance matrix was run.

path-map.json maps repository paths to archived files and verifies the 12 original V2 binaries retained in build/inline-single-v2-{native,asan,full}. They are not overwritten by final v2-direct builds. External dependencies remain the same pinned inputs archived under ../preflight-v1; experiment/freeze-v2.json records the complete non-system source closure used by validation.
