import 'package:flutter/cupertino.dart';

class Task {
  Task({@required this.task, @required this.id, this.taskCategoryColor});
  final String task;
  final String id;
  final int taskCategoryColor;

  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String task = data['task'];
    final String taskId = documentId;
    final int taskCategoryColor = data['color'];
    return Task(id: taskId, task: task, taskCategoryColor: taskCategoryColor);
  }

  Map<String, dynamic> toMap() {
    return {'task': task, 'color': taskCategoryColor};
  }
}
