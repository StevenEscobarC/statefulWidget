import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TaskModel> _tasks = [];
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _taskTitle = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tasks.add(TaskModel(title: 'Tarea 1', completed: false));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de tareas'),
      ),
      body: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_tasks[index].title),
              leading: Checkbox(
                value: _tasks[index].completed,
                onChanged: (value) {
                  setState(() {
                    _tasks[index].completed = value!;
                  });
                },
              ),
              trailing: Container(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _tasks.removeAt(index);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _textEditingController.text = _tasks[index].title;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Nueva tarea'),
                                content: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _textEditingController,
                                    onChanged: (value) {
                                      setState(() {
                                        _taskTitle = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Ingrese una nueva tarea',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese una tarea';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        _textEditingController.clear();

                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancelar')),
                                  TextButton(
                                      onPressed: () {
                                        if (!_formKey.currentState!.validate())
                                          return;

                                        if (_taskTitle.isNotEmpty) {
                                          setState(() {
                                            _tasks[index].title = _taskTitle;
                                          });
                                          _textEditingController.clear();
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text('Editar'))
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Nueva tarea'),
                  content: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _textEditingController,
                      onChanged: (value) {
                        setState(() {
                          _taskTitle = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Ingrese una nueva tarea',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una tarea';
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _textEditingController.clear();
                        },
                        child: Text('Cancelar')),
                    TextButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;

                          if (_taskTitle.isNotEmpty) {
                            setState(() {
                              _tasks.add(TaskModel(
                                  title: _taskTitle, completed: false));
                              _textEditingController.clear();
                              _taskTitle = '';
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Agregar'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
