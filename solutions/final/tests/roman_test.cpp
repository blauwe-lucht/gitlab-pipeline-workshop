#include "roman.hpp"

#include <gtest/gtest.h>

#include <stdexcept>
#include <string_view>

TEST(ToDecimal, ConvertsSingleSymbol) {
  // Arrange
  constexpr std::string_view numeral = "X";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 10);
}

TEST(ToDecimal, ConvertsFiveHundred) {
  // Arrange
  constexpr std::string_view numeral = "D";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 500);
}

TEST(ToDecimal, AddsSymbolsInDescendingOrder) {
  // Arrange
  constexpr std::string_view numeral = "LXVIII";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 68);
}

TEST(ToDecimal, SubtractsSmallerSymbolBeforeLargerOne) {
  // Arrange
  constexpr std::string_view numeral = "XC";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 90);
}

TEST(ToDecimal, ConvertsYear) {
  // Arrange
  constexpr std::string_view numeral = "MCMXCIV";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 1994);
}

TEST(ToDecimal, RejectsInvalidSymbol) {
  // Arrange
  constexpr std::string_view numeral = "XIZ";

  // Act
  const auto convert = [&] { roman::to_decimal(numeral); };

  // Assert
  EXPECT_THROW(convert(), std::invalid_argument);
}
