import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavorizer_skeleton/flavours/config/flavour_config.dart';

import '../main.dart';

void mainCommon({
  required FlutterFavour flavour,
}) {
  FlavourConfig(
    flavour: FlutterFavour.staging,
    environment: dotenv.env['ENVIRONMENT']!,
    baseUrl: dotenv.env['BASE_URL']!,
    assetUrl: dotenv.env['ASSET_URL']!,
  );
  runApp(MyApp());
}
