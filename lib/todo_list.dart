import 'package:flutter/material.dart';
import 'package:tyba_todo/audio/simple_recorder.dart';
import 'package:tyba_todo/model/todo.dart';
import 'package:tyba_todo/services/database_services.dart';
import 'package:tyba_todo/utils/constants.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _formKey = GlobalKey<FormState>();

  dynamic _formValues = {
    'uid': '',
    'title': '',
    'description': '',
    'audioRef': null,
    'isComplete': false
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
                  style: TextStyle(color: COLOR_TEXT),
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
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete),
                            ),
                            onDismissed: (direction) {
                              DatabaseService().removeTodo(tasks[index].uid);
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
              'audioRef': null,
              'isComplete': false
            };
          });
          _formTask(context, width, FormAction.create);
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
        color: COLOR_TEXT,
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
            'audioRef': tasks[index].audioRef, 
            'isComplete': tasks[index].isComplete,
          };
        });
        _formTask(context, width, FormAction.edit);
      },
      leading: GestureDetector(
        onTap: () {
          tasks[index].isComplete = !tasks[index].isComplete;
          DatabaseService().updateTask(tasks[index].uid, tasks[index]);
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
                  color: COLOR_ICON,
                )
              : Container(),
        ),
      ),
      title: Text(
        tasks[index].title,
        style: TextStyle(
          fontSize: 20,
          color: COLOR_TEXT_LIGHT,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<dynamic> _formTask(
      BuildContext context, double width, FormAction action) {
    String actionText = action == FormAction.create ? 'Add task' : 'Edit task';
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          backgroundColor: BACKGROUND_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Text(
                actionText,
                style: const TextStyle(
                  fontSize: SUBTITLE_SIZE,
                  color: COLOR_TEXT,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: COLOR_ICON,
                  size: ICON_SIZE,
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
                      color: COLOR_TEXT,
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
                      color: COLOR_TEXT,
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
                          TaskEntity task = TaskEntity(
                              uid: '',
                              title: _formValues['title']!.trim(),
                              description: _formValues['description']?.trim(),
                              audioRef: _formValues['audioRef'],
                              isComplete: _formValues['isComplete']);
                          if (action == FormAction.create) {
                            DatabaseService().createTask(task);
                          }
                          if (action == FormAction.edit) {
                            DatabaseService()
                                .updateTask(_formValues['uid'], task);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Updating task list'),
                                backgroundColor: BACKGROUND_SUCCESS),
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
