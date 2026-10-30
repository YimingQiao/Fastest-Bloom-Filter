#include <functional>
template<class Word> struct Test { std::function<void(__restrict Word*)> f; };
Test<unsigned> object;
