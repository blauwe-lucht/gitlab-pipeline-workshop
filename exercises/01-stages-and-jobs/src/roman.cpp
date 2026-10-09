#include "roman.hpp"

#include <stdexcept>
#include <string>

namespace roman {
namespace {

int value_of(char symbol) {
  switch (symbol) {
    case 'I': return 1;
    case 'V': return 5;
    case 'X': return 10;
    case 'L': return 50;
    case 'C': return 100;
    case 'D': return 50;
    case 'M': return 1000;
    default: throw std::invalid_argument(std::string("Invalid Roman numeral symbol: ") + symbol);
  }
}

bool is_subtractive(std::string_view numeral, std::size_t index) {
  return index + 1 < numeral.size() && value_of(numeral[index]) < value_of(numeral[index + 1]);
}

}  // namespace

int to_decimal(std::string_view numeral) {
  int total = 0;
  for (std::size_t index = 0; index < numeral.size(); ++index) {
    const int value = value_of(numeral[index]);
    total += is_subtractive(numeral, index) ? -value : value;
  }
  return total;
}

}  // namespace roman
