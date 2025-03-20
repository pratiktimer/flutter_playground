import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'todo.freezed.dart';

var uuid = new Uuid();

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String desc,
    @Default(false) bool isComplete,
  }) = _Todo;

  factory Todo.add(String desc) {
    return Todo(id: uuid.v4(), desc: desc);
  }
}
