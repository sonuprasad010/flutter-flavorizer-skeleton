import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavorizer_skeleton/flavours/config/flavour_config.dart';
import 'package:flutter_flavorizer_skeleton/flavours/main_common.dart';

void main() async {
  await dotenv.load(fileName: ".env.staging");
  mainCommon(flavour: FlutterFavour.staging);
}
