enum FlutterFavour { development, staging, production }

class FlavourConfig {
  final FlutterFavour flavour;
  final String name;
  final String baseUrl;
  final String assetUrl;

  static FlavourConfig? _instance;

  FlavourConfig._({
    required this.flavour,
    required this.name,
    required this.baseUrl,
    required this.assetUrl,
  });

  factory FlavourConfig({
    required FlutterFavour flavour,
    required String environment,
    required String baseUrl,
    required String assetUrl,
  }) {
    _instance ??= FlavourConfig._(
      flavour: flavour,
      name: environment,
      baseUrl: baseUrl,
      assetUrl: assetUrl,
    );

    return _instance!;
  }

  static FlavourConfig get instance {
    if (_instance == null) {
      throw Exception("Not initilized");
    }
    return _instance!;
  }
}
