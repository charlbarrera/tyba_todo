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

  Future createTask(
      {required String title, String? description, dynamic audioRef}) async {
    return await tasksCollection.add({
      'title': title,
      'description': description,
      'audioRef': audioRef,
      'isComplete': false,
    });
  }

  Future<String> saveAudio(String name, String path) async {
    Reference audio = storage.ref('records').child('/$name');
    try {
      await audio.putFile(File(path));
    } catch (e) {
      print(e);
    }
    return name;
  }

  Future<String> downloadAudio(name) async {
    final audioRef = storage.ref('records').child('/$name');

    final appDocDir = await getApplicationDocumentsDirectory();
    final dir = appDocDir.absolute.path;
    String filePath = "$dir/$name";
    final file = File(filePath);

    try {
      await audioRef.writeToFile(file);
    } catch (e) {
      print(name);
      print(e);
    }

    return filePath;
  }

  Future updateTask(uid, task) async {
    await tasksCollection.doc(uid).update({...task});
  }

  Future removeTodo(uid) async {
    await tasksCollection.doc(uid).delete();
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
