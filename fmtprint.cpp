#include "fmtprint.h"

int main(int argc, char** argv) {
  fmt::print("Hello World. argc={}. called as: {}", argc, argv[0]);
}
