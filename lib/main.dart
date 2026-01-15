import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider_api/provider/todo_provider.dart';
import 'package:todo_provider_api/todoScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter todo provider api',
        debugShowCheckedModeBanner: false,
        home: const TodoScreen(),
      ),
    );
  }
}
