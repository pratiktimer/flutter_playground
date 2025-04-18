import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_nofifier_provider/pages/todos_provider.dart';

class TodosPage extends ConsumerWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var todods = ref.watch(todosProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Center(
        child: ListView(children: [
          AddTodo(),
          SizedBox(
            height: 20,
          ),
          for (var todo in todods)
            ListTile(
              title: Text(
                todo.desc,
                style: TextStyle(
                  decoration: todo.isComplete
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref.read(todosProvider.notifier).removeTodo(todo.id);
                },
              ),
              leading: Checkbox(
                value: todo.isComplete,
                onChanged: (value) {
                  ref.read(todosProvider.notifier).toggleTodo(todo.id);
                },
              ),
            )
        ]),
      ),
    );
  }
}

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Add Todo',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) {
          if (value.isEmpty) return;
          ref.read(todosProvider.notifier).addTodo(value);
          controller.clear();
        },
      ),
    );
  }
}
