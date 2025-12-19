enum AreaUnit { acre, bigha, hectare }

// Conversion factors to acre
const double _bighaToAcre = 0.61983471;
const double _hectareToAcre = 2.47105;

// Helper class for area unit conversions and utility functions
class AreaUnitUtils {
  // Converts a value from any unit TO acres
  static double convertToAcre(double value, AreaUnit fromUnit) {
    switch (fromUnit) {
      case AreaUnit.bigha:
        return value * _bighaToAcre;
      case AreaUnit.hectare:
        return value * _hectareToAcre;
      case AreaUnit.acre:
      default:
        return value;
    }
  }

  // Converts a value FROM acres to a target unit
  static double convertFromAcre(double acreValue, AreaUnit toUnit) {
    switch (toUnit) {
      case AreaUnit.bigha:
        return acreValue / _bighaToAcre;
      case AreaUnit.hectare:
        return acreValue / _hectareToAcre;
      case AreaUnit.acre:
      default:
        return acreValue;
    }
  }

  // Gets the string representation of a unit
  static String getUnitString(AreaUnit unit) {
    switch (unit) {
      case AreaUnit.bigha:
        return 'Bigha';
      case AreaUnit.hectare:
        return 'Hectare';
      case AreaUnit.acre:
      default:
        return 'Acre';
    }
  }
}
