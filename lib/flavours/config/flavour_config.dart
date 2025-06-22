
enum FlutterFavour { development, staging, production }

class FlavourConfig {
  final FlutterFavour flavour;
  final String name;

  static FlavourConfig? _instance;

  FlavourConfig._({required this.flavour, required this.name});

  factory FlavourConfig({
    required FlutterFavour flavour,
    required String name,
  }) {
    _instance ??= FlavourConfig._(flavour: flavour, name: name);

    return _instance!;
  }

  static FlavourConfig get instance {
    if (_instance == null) {
      throw Exception("Not initilized");
    }
    return _instance!;
  }
}
