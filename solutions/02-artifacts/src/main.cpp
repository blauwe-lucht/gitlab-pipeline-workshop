#include "roman.hpp"

#include <iostream>
#include <stdexcept>

int main(int argc, char* argv[]) {
  if (argc != 2) {
    std::cerr << "Usage: roman <numeral>\n";
    return 2;
  }

  try {
    std::cout << roman::to_decimal(argv[1]) << '\n';
    return 0;
  } catch (const std::invalid_argument& error) {
    std::cerr << error.what() << '\n';
    return 1;
  }
}
