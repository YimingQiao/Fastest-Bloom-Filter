# Preserved first attempt

Source b7bec22fe6b88fe0b0382c6fb53a939dcf97f211 stopped at the first native translation-unit compilation. The copied caller directly included ../candidate.hpp, while the conditional proposal exposes conditional.hpp. The geometry include was correct but did not remove the earlier direct include. No project executable or filter run occurred; five command records and exact failure logs are retained. The repair is an additive include-routing-only caller source, with unchanged timed helper/body, filter kernels, flags and workload.
