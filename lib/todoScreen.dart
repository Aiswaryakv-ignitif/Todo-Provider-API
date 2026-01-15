import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider_api/provider/todo_provider.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 221, 164, 226),
          appBar: AppBar(
            title: const Text(
              'My To-Do List',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 110, 6, 129),
            foregroundColor: Colors.white,
            toolbarHeight: 90,
            
          ),

          body: Column(
            children: [
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: provider.todos.length,
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) => provider.reorderTodo(oldIndex, newIndex),

                  itemBuilder: (context, index) {
                    final item = provider.todos[index];
                    final bool isDraggable = !item.completed; //false cases

                    Widget cardContent = Card(
                      key: ValueKey(item),
                      color: item.completed
                          ? const Color.fromARGB(255, 175, 116, 195)
                          : CupertinoColors.extraLightBackgroundGray,

                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            if (!item.isEditing)
                              Checkbox(
                              
                                activeColor: Colors.white,
                                checkColor: Colors.purple,
                                value: item.completed,
                                onChanged: (bool? value) {
                                  provider.toggleTodo(index);
                                },
                              ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: item.isEditing
                                  ? TextField(
                                      controller: provider.editController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        // hintText: "Add new task",
                                        hintStyle: TextStyle(
                                          color: CupertinoColors.systemGrey,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      item.title,
                                      style: TextStyle(
                                        decoration: item.completed
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                            ),

                            SizedBox(width: 10),

                            if (item.isEditing)
                              Row(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: const CircleBorder(),
                                    ),
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      provider.saveEdit(
                                        index,
                                        provider.editController.text,
                                      );
                                    },
                                  ),

                                  SizedBox(width: 10),

                                  IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: const CircleBorder(),
                                    ),
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      provider.cancelEdit(index);
                                    },
                                  ),
                                ],
                              )
                            else if (!item.completed)
                              IconButton(
                                onPressed: () {
                                  provider.editController.text = item.title;

                                  provider.startEditing(index);
                                },
                                icon: const Icon(Icons.edit),
                              ),

                            // if (isDraggable)
                            // const Icon(Icons.drag_handle, color: Colors.grey),
                          ],
                        ),
                      ),
                    );

                    if (isDraggable && !item.isEditing) {
                      return ReorderableDragStartListener(
                        key: ValueKey(provider.todos[index]),
                        index: index,
                        child: cardContent,
                      );
                    } else {
                      return cardContent;
                    }
                  },
                ),
              ),

             
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: provider.addController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Background color
                          hintText: "Add new task",
                          hintStyle: TextStyle(
                            color: CupertinoColors.systemGrey,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 20),

                    FloatingActionButton(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      mini: true,
                      onPressed: () {
                        provider.addTodo();
                      },
                      child: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
