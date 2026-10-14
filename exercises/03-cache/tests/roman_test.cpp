#include "roman.hpp"

#include <gtest/gtest.h>

#include <stdexcept>

TEST(ToDecimal, ConvertsSingleSymbol) {
  // Arrange
  const auto numeral = "X";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 10);
}

TEST(ToDecimal, ConvertsFiveHundred) {
  // Arrange
  const auto numeral = "D";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 500);
}

TEST(ToDecimal, AddsSymbolsInDescendingOrder) {
  // Arrange
  const auto numeral = "LXVIII";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 68);
}

TEST(ToDecimal, SubtractsSmallerSymbolBeforeLargerOne) {
  // Arrange
  const auto numeral = "XC";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 90);
}

TEST(ToDecimal, ConvertsYear) {
  // Arrange
  const auto numeral = "MCMXCIV";

  // Act
  const auto value = roman::to_decimal(numeral);

  // Assert
  EXPECT_EQ(value, 1994);
}

TEST(ToDecimal, RejectsInvalidSymbol) {
  // Arrange
  const auto numeral = "XIZ";

  // Act
  const auto convert = [&] { roman::to_decimal(numeral); };

  // Assert
  EXPECT_THROW(convert(), std::invalid_argument);
}
