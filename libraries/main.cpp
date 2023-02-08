#include "tools.hpp"
#include <iostream>

// clang++ -std=c++17 -c tools.cpp -o tools.o        (Complile tools.cpp into binary code, creates tools.o)
// ar rcs libtools.a tools.o                         (Organize the modules into a library, creates libtools.a)
// clang++ -std=c++17 main.cpp -L . -ltools -o main  (Link libraries and build executable, creates main)

int main()
{
  MakeItRain();
  MakeItSunny();
  return 0;
}