#include "format.h"
#include <cstdio>

int main(int argc, char** argv) {
  std::puts(std::format("argc={}", argc).c_str());
}
