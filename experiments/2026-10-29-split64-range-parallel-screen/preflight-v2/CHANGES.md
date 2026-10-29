# Versioned preflight retry

V1 commit `c4232dc35f057e4b681154fdc68151e6cbee26a7` failed while compiling `dense_current`: `array` was ambiguous with `std::array`. No filter test ran. All original54 files, V1's13 prepared artifacts and `validation-v1` failure logs remain unchanged; the new failure manifest records their exact observed bytes.

V2 changes only the fixture JSON helper name (`array` to `WriteDenseArray`) in C++. The driver uses new `build/split64-range-parallel-preflight-v2-*` build directories and `validation-v2`. Source guards additionally bind all13 original preflight artifacts to the committed V1 preparation. The unchanged timer/native/external APIs are still compiled from the original63ff706 stage. The same planned checks and exact142 configuration selection apply. No executable from the failed attempt is substituted or reused.
