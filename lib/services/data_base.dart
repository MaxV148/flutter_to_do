import 'package:flutter/cupertino.dart';
import 'package:todo_v3/categories/category.dart';
import 'package:todo_v3/services/api_path.dart';
import 'package:todo_v3/services/firestore_service.dart';
import 'package:todo_v3/tasks/task.dart';

abstract class DataBase {
  Future<void> setTask(Task task);
  Future<void> deleteTask(Task task);
  Stream<List<Task>> tasksStream();
  Future<void> setCategory(Category category);
  Stream<List<Category>> categoriesStream();
  Future<void> deleteCategory(Category category);
}

class FirestoreDatabase implements DataBase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setTask(Task task) async {
    await _service.setData(
      path: APIPath.task(uid, task.id),
      data: task.toMap(),
    );
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _service.deleteData(path: APIPath.task(uid, task.id));
  }

  @override
  Stream<List<Task>> tasksStream() => _service.collectionStream(
      path: APIPath.tasks(uid),
      builder: (data, documentId) => Task.fromMap(data, documentId));

  @override
  Future<void> setCategory(Category category) async {
    await _service.setData(
      path: APIPath.category(uid, category.id),
      data: category.toMap(),
    );
  }

  @override
  Future<void> deleteCategory(Category category) async {
    await _service.deleteData(path: APIPath.category(uid, category.id));
  }

  @override
  Stream<List<Category>> categoriesStream() => _service.collectionStream(
      path: APIPath.categories(uid),
      builder: (data, documentId) => Category.fromMap(data, documentId));
}
