import 'package:flutter_flavorizer_skeleton/flavours/config/flavour_config.dart';
import 'package:flutter_flavorizer_skeleton/flavours/main_common.dart';

void main() {
  mainCommon(
    flavour: FlutterFavour.staging,
    baseUrl: "base",
    name: "Staging",
  );
}
