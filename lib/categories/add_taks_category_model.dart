enum AddFormType { task, category }

class AddTaskCatoryModel {
  AddTaskCatoryModel({this.addFormType});
  final AddFormType addFormType;

  AddTaskCatoryModel copyWith({
    AddFormType formType,
  }) {
    return AddTaskCatoryModel(addFormType: formType ?? this.addFormType);
  }
}
