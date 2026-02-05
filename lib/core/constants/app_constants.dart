/// Application constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Hudas 3D Buddy';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String printersKey = 'printers_data';
  static const String filamentsKey = 'filaments_data';
  static const String generalSettingsKey = 'general_settings';
  static const String preProcessingKey = 'pre_processing_settings';
  static const String postProcessingKey = 'post_processing_settings';
  static const String printJobsKey = 'print_jobs_data';

  // Default Values
  static const double defaultElectricityRate = 0.12; // per kWh
  static const double defaultMarkupPercent = 100.0;
  static const double defaultFailureRate = 5.0;
  static const double defaultLaborRate = 15.0; // per hour
  static const String defaultCurrency = 'PHP';

  // Filament Defaults
  static const double defaultFilamentDiameter = 1.75;
  static const double defaultFilamentDensity = 1.24; // g/cm³ for PLA
  static const double defaultFilamentWastage = 5.0; // percent

  // Printer Defaults
  static const double defaultPrinterWattage = 200.0;
  static const int defaultDepreciationHours = 2000;
}

/// Currency options available in the app
class CurrencyOptions {
  static const List<String> currencies = [
    'PHP',
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
  ];

  static const Map<String, String> currencySymbols = {
    'PHP': '₱',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'AUD': 'A\$',
    'CAD': 'C\$',
  };
}

/// Filament material types
class FilamentMaterials {
  static const List<String> materials = [
    'PLA',
    'ABS',
    'PETG',
    'TPU',
    'Nylon',
    'ASA',
    'PC',
    'PVA',
    'HIPS',
    'Wood Fill',
    'Carbon Fiber',
    'Metal Fill',
    'Other',
  ];

  /// Density in g/cm³
  static const Map<String, double> densities = {
    'PLA': 1.24,
    'ABS': 1.04,
    'PETG': 1.27,
    'TPU': 1.21,
    'Nylon': 1.14,
    'ASA': 1.07,
    'PC': 1.20,
    'PVA': 1.23,
    'HIPS': 1.04,
    'Wood Fill': 1.15,
    'Carbon Fiber': 1.30,
    'Metal Fill': 2.00,
    'Other': 1.24,
  };
}
