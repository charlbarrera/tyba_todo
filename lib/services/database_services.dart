import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tyba_todo/model/todo.dart';

class DatabaseService {
  CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');
  FirebaseStorage storage = FirebaseStorage.instance;

  Future createTask(TaskEntity task) async {
    final taskDTO = task.toMap();
    return await tasksCollection.add(taskDTO);
  }

  Future<String> saveAudio(String name, String path) async {
    try {
      Reference audio = storage.ref('records').child('/$name');
      await audio.putFile(File(path));
      return name;
    } catch (e) {
      throw Exception('databaseService/saveAudio $e');
    }
  }

  Future<String> downloadAudio(String name) async {
    try {
      Reference audioRef = storage.ref('records').child('/$name');
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String dir = appDocDir.absolute.path;
      String filePath = '$dir/$name';
      File file = File(filePath);
      await audioRef.writeToFile(file);
      return filePath;
    } catch (e) {
      throw Exception('databaseService/downloadAudio $e');
    }
  }

  void updateTask(String uid, TaskEntity task) {
    Map taskDTO = task.toMap();
    try {
      tasksCollection.doc(uid).update({...taskDTO});
    } catch (e) {
      throw Exception('databaseService/updateTask $e');
    }
  }

  void removeTodo(String uid) {
    try {
      tasksCollection.doc(uid).delete();
    } catch (e) {
      throw Exception('databaseService/removeTodo $e');
    }
  }

  List<TaskEntity>? taskFromFirestore(QuerySnapshot snapshot) {
    if (snapshot.docs != null) {
      return snapshot.docs.map((e) {
        return TaskEntity(
          description: (e.data() as dynamic)['description'],
          isComplete: (e.data() as dynamic)['isComplete'],
          title: (e.data() as dynamic)['title'],
          audioRef: (e.data() as dynamic)['audioRef'],
          uid: e.id,
        );
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<TaskEntity>?> tasks() {
    return tasksCollection.snapshots().map(taskFromFirestore);
  }
}
