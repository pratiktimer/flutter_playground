import 'package:state_nofifier_provider/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosProvider extends StateNotifier<List<Todo>> {
  TodosProvider() : super([]);

  void addTodo(String desc) {
    state = [...state, Todo.add(desc)];
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(isComplete: !todo.isComplete) else todo
    ];
  }

  void removeTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id != id) todo
    ];
  }
}

final todosProvider = StateNotifierProvider<TodosProvider, List<Todo>>((ref) {
  return TodosProvider();
});
