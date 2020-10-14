import 'package:flutter/cupertino.dart';
import 'package:todo_v3/categories/add_taks_category_model.dart';

class AddTaskCategoryChangeModel with ChangeNotifier {
  AddTaskCategoryChangeModel({this.formType});
  AddFormType formType;

  void toggleFormType() {
    final formtype = this.formType == AddFormType.task
        ? AddFormType.category
        : AddFormType.task;
  }

  void updateWith(AddFormType formType) {
    this.formType = formType ?? this.formType;
    notifyListeners();
  }
}
