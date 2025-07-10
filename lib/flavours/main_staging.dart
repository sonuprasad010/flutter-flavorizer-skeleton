import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavorizer_skeleton/features/login/domain/entity/user_entity.dart';
import 'package:flutter_flavorizer_skeleton/flavours/main_common.dart';

import '../features/login/data/model/user.dart';
import 'config/flavour_config.dart';

void main() async {
  await dotenv.load(fileName: ".env.staging");
  final user = User.fromJson({"email": "password", "password": "password"});
  final UserEntity entity = user;
  // mainCommon(flavour: FlutterFavour.staging);
}
