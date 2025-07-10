// ignore_for_file: dangling_library_doc_comments

/**______________________________________
 * | Use this file only if you are not using
 * | CLEAN Code architecture
 * | OR Want to move user to a core folder in
 * | stead of features
*  |____________________________________
 */

// import 'package:flutter_flavorizer_skeleton/core/utils/date_time_converter.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'user.freezed.dart';
// part 'user.g.dart';

// @freezed
// abstract class User with _$User {
//   const factory User({
//     required String firstName,
//     required String lastName,
//     required int age,
//     required bool isActive,
//     @DateTimeConverter() DateTime? createdAt,
//   }) = _User;

//   factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
// }

/**
 * Following code is example code to showcase
 * freezed and json_serializable to generate
 * code for variable with snakecase in server
 * for example: first_name, last_name
 * NOTE: Remove this in production in not needed
 */
// @freezed
// abstract class User with _$User {
//   const factory User({
//     @JsonKey(name: 'first_name') required String firstName,
//     @JsonKey(name: 'last_name') required String lastName,
//     @JsonKey(name: 'age') required int age,
//   }) = _User;

//   factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
// }