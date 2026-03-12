#include "fmtformat.h"
#include <cstdio>

int main(int argc, char** argv) {
  puts(fmt::format("argc={}", argc).c_str());
}
