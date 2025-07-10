import 'package:flutter_flavorizer_skeleton/features/login/domain/entity/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User  with _$User implements UserEntity {
  const factory User({required String email, required String password}) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
