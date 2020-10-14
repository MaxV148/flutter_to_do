import 'package:flutter/material.dart';
import 'package:todo_v3/tasks/task.dart';

import '../constants.dart';

class TaskListTile extends StatelessWidget {
  TaskListTile({@required this.task, this.color});
  final Task task;
  final int color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.circle, color: Color(color), size: 30),
          Icon(Icons.circle, color: DARK_BLUE, size: 25)
        ],
      ),
      title: Text(
        task.task,
        style: TextStyle(color: Colors.white),
      ),
      tileColor: DARK_BLUE,
    );
  }
}
