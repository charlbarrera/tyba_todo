import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tyba_todo/audio/simple_recorder.dart';
import 'package:tyba_todo/model/todo.dart';
import 'package:tyba_todo/services/database_services.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _formKey = GlobalKey<FormState>();
  dynamic _formValues = {
    'uid': '',
    'title': '',
    'description': '',
    'audioRef': null
  };
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<TaskEntity>?>(
            stream: DatabaseService().tasks(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                    child: Text(
                  'There isnt data available',
                  style: TextStyle(color: Colors.white),
                ));
              }
              List<TaskEntity> tasks = snapshot.data as List<TaskEntity>;
              return Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(),
                    const SizedBox(height: 10),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[800],
                        ),
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(tasks[index].title),
                            background: Container(
                              padding: const EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              color: Colors.red,
                              child: const Icon(Icons.delete),
                            ),
                            onDismissed: (direction) async {
                              await DatabaseService()
                                  .removeTodo(tasks[index].uid);
                              //
                            },
                            child: _item(tasks, index, context, width),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          setState(() {
            _formValues = {
              'uid': null,
              'title': '',
              'description': '',
              'audioRef': null
            };
          });
          _formTask(context, width, 'create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Text _title() {
    return const Text(
      'All Tasks',
      style: TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  ListTile _item(
      List<TaskEntity> tasks, int index, BuildContext context, double width) {
    return ListTile(
      onTap: () {
        setState(() {
          _formValues = {
            'uid': tasks[index].uid,
            'title': tasks[index].title,
            'description': tasks[index].description,
            'audioRef': tasks[index].audioRef
          };
        });
        _formTask(context, width, 'edit');
      },
      leading: GestureDetector(
        onTap: () {
          DatabaseService().updateTask(
              tasks[index].uid, {'isComplete': !tasks[index].isComplete});
        },
        child: Container(
          padding: const EdgeInsets.all(2),
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: tasks[index].isComplete
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Container(),
        ),
      ),
      title: Text(
        tasks[index].title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[200],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<dynamic> _formTask(BuildContext context, double width, action) {
    String text = action == 'create' ? 'Add task' : 'Edit task';
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const Divider(),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: Colors.white,
                    ),
                    initialValue: _formValues['title'],
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'eg. exercise',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      _formValues['title'] = val;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: Colors.white,
                    ),
                    initialValue: _formValues['description'],
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'eg. go with my best friend',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      _formValues['description'] = val;
                    },
                  ),
                  const SizedBox(height: 20),
                  SimpleRecorder(
                      audioRef: _formValues['audioRef'],
                      onSave: _handleSaveAudio),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width,
                    height: 50,
                    child: TextButton(
                      child: const Text('save', style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          if (action == 'create') {
                            DatabaseService().createTask(
                                title: _formValues['title']!.trim(),
                                description: _formValues['description']?.trim(),
                                audioRef: _formValues['audioRef']);
                          }
                          if (action == 'edit') {
                            DatabaseService()
                                .updateTask(_formValues['uid'], _formValues);
                          }
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Updating task list'),
                                backgroundColor: Colors.green),
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _handleSaveAudio(name, url) async {
    await DatabaseService().saveAudio(name, url);
    _formValues['audioRef'] = name;
  }
}
