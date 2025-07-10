import 'package:flutter_flavorizer_skeleton/core/utils/date_time_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
abstract class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    required int age,
    required bool isActive,
    @DateTimeConverter() DateTime? createdAt,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
}

/**
 * Following code is example code to showcase
 * freezed and json_serializable to generate
 * code for variable with snakecase in server
 * for example: first_name, last_name
 * NOTE: Remove this in production in not needed
 */
// @freezed
// abstract class Person with _$Person {
//   const factory Person({
//     @JsonKey(name: 'first_name') required String firstName,
//     @JsonKey(name: 'last_name') required String lastName,
//     @JsonKey(name: 'age') required int age,
//   }) = _Person;

//   factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
// }