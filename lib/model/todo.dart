class TaskEntity {
  String uid;
  String title;
  String? description;
  String? audioRef;
  bool isComplete;

  TaskEntity({required this.uid, required this.title, this.description, this.audioRef, required this.isComplete});
}
