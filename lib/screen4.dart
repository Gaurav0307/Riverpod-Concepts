import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_concepts/screen1.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.read(titleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        foregroundColor: Colors.black87,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final todoProvider = ref.watch(todoNotifierProvider);

          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: todoProvider.todos[index].isDone,
                  onChanged: (value) {
                    final todoController = ref.read(
                      todoNotifierProvider.notifier,
                    );

                    todoController.markDone(
                      todoProvider.todos[index].id,
                      value!,
                    );
                  },
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                ),
                title: Text(
                  todoProvider.todos[index].title,
                  style: TextStyle(
                    decoration: todoProvider.todos[index].isDone
                        ? TextDecoration.lineThrough
                        : null,
                    color: todoProvider.todos[index].isDone
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    final todoController = ref.read(
                      todoNotifierProvider.notifier,
                    );

                    todoController.removeTodo(todoProvider.todos[index].id);
                  },
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final todoController = ref.read(todoNotifierProvider.notifier);

          todoController.addTodo(
            title: "New Todo - ${DateTime.now().millisecondsSinceEpoch}",
          );
        },
      ),
    );
  }
}

final todoNotifierProvider = StateNotifierProvider<TodoNotifier, TodoState>(
  (ref) => TodoNotifier(),
);

class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier() : super(TodoState([]));

  void addTodo({String title = "", bool isDone = false}) {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      isDone: isDone,
    );
    state.todos.add(todo);
    state = TodoState(state.todos);
  }

  void removeTodo(int id) {
    state.todos.removeWhere((todo) => todo.id == id);
    state = TodoState(state.todos);
  }

  void markDone(int id, bool isDone) {
    int index = state.todos.indexWhere((todo) => todo.id == id);
    state.todos[index] = state.todos[index].copyWith(isDone: isDone);
    state = TodoState(state.todos);
  }
}

class TodoState {
  final List<Todo> todos;

  TodoState(this.todos);
}

class Todo {
  final int id;
  final String title;
  final bool isDone;

  const Todo({required this.id, required this.title, required this.isDone});

  Todo copyWith({int? id, String? title, bool? isDone}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
