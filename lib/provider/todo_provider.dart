import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoItem {
  String title;
  bool completed;
  bool isEditing;
  bool isEditingAnyTodo = false;

  TodoItem({
    required this.title,
    required this.completed,
    this.isEditing = false,
  });
}

class TodoProvider extends ChangeNotifier {
  List<TodoItem> todos = [];

  TodoProvider() {
    fetchTodos();
  }

  final TextEditingController addController = TextEditingController();
  final TextEditingController editController = TextEditingController();

  void dispose() {
    addController.dispose();
    editController.dispose();
    super.dispose();
   
  }

  /// Fetch todos from API
  Future<void> fetchTodos() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos?_limit=10'),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      todos = data.map<TodoItem>((item) {
        return TodoItem(title: item['title'], completed: item['completed']);
      }).toList();

      List<TodoItem> pending = [];
      List<TodoItem> completed = [];

      for (var todo in todos) {
        if (todo.completed) {
          completed.add(todo);
        } else {
          pending.add(todo);
        }
      }

      todos = [...pending, ...completed];

      // todos.clear();
      // todos.addAll(pending);
      // todos.addAll(completed);

      notifyListeners();
    } else {
      print("Failed to load todos");
    }
  }

  /// Add todo
  void addTodo() {
    if (addController.text.trim().isEmpty) return;

    todos.insert(
      0,
      TodoItem(title: addController.text.trim(), completed: false),
    );

    addController.clear();
    notifyListeners();
  }

  /// Toggle completed
  void toggleTodo(int index) {
    final item = todos[index];
    item.completed = !item.completed;
    if (item.completed) {
      final doneItem = todos.removeAt(index);
      todos.add(doneItem);
    } else {
      item.completed = true;
      return;
    }
  }

  // Reorder logic
  void reorderTodo(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // Find boundary (first completed task)
    int boundaryIndex = todos.indexWhere((item) => item.completed);
    if (boundaryIndex == -1) boundaryIndex = todos.length;

    // Allow reorder ONLY for pending tasks
    if (!todos[oldIndex].completed && newIndex < boundaryIndex) {
      final item = todos.removeAt(oldIndex);
      todos.insert(newIndex, item);
      notifyListeners();
    }
  }

  /// Start editing one item (only one at a time)
  void startEditing(int index) {
    for (var item in todos) {
      item.isEditing = false;
    }
    todos[index].isEditing = true;

    notifyListeners();
  }

  /// Save edited title
  void saveEdit(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    todos[index].title = newTitle.trim();
    todos[index].isEditing = false;

    notifyListeners();
  }

  /// Cancel editing
  void cancelEdit(int index) {
    todos[index].isEditing = false;
    notifyListeners();
  }
}
