#include "print.h"

int main(int argc, char** argv) {
  std::print("Hello World. argc={}. called as: {}", argc, argv[0]);
}
