import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> todos = [];

  void addTodo(String desc) {
    todos.add(Todo.add(desc));
    notifyListeners();
  }

  void toggleTodo(String id) {
    var todo = todos.firstWhere((p) => p.id == id);
    todo.completed = !todo.completed;
    notifyListeners();
  }

  void removeTodo(String id) {
    todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

// class TodosNotifier extends StateNotifier<List<Todo>> {
//   TodosNotifier() : super([]);

//   void addTodo(String desc) {
//     state = [...state, Todo.add(desc: desc)];
//     // state.add(Todo.add(desc: desc));
//     // print('in addTodo: $state');
//   }

//   void toggleTodo(String id) {
//     state = [
//       for (final todo in state)
//         if (todo.id == id) todo.copyWith(completed: !todo.completed) else todo,
//     ];
//   }

//   void removeTodo(String id) {
//     state = [
//       for (final todo in state)
//         if (todo.id != id) todo,
//     ];
//   }
// }

// final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
//   return TodosNotifier();
// });
final todosProvider = ChangeNotifierProvider<TodosProvider>((ref) {
  return TodosProvider();
});
