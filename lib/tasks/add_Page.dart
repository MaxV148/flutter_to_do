import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_v3/categories/add_taks_category_model.dart';
import 'package:todo_v3/categories/category.dart';
import 'package:todo_v3/categories/category_list_tile.dart';
import 'package:todo_v3/common_widgets/list_items_builder.dart';
import 'package:todo_v3/services/data_base.dart';
import 'package:todo_v3/tasks/task.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class AddPage extends StatefulWidget {
  AddPage({@required this.dataBase, this.task, this.model});
  final AddTaskCatoryModel model;
  final DataBase dataBase;
  final Task task;
  static Future<void> show(BuildContext context, {Task task}) async {
    final db = Provider.of<DataBase>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddPage(dataBase: db, task: task),
        fullscreenDialog: true));
  }

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool addTask = true;

  final _formKey = GlobalKey<FormState>();
  final Uuid uuidGen = Uuid();
  String _task;
  String _category;
  int _categoryColor;
  int _addTaskCategoryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: addTask ? Text("Add Task") : Text("Add Category"),
        centerTitle: true,
        backgroundColor: BG_BLUE,
        elevation: 5.0,
      ),
      backgroundColor: BG_BLUE,
      body: _buildContent(),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _task = widget.task.task;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit() async {
    if (_validateAndSaveForm()) {
      try {
        if (addTask) {
          final task = Task(
            task: _task,
            id: uuidGen.v4(),
            taskCategoryColor: _addTaskCategoryColor ?? 4294967295,
          );
          await widget.dataBase.setTask(task);
        } else {
          print("Add category");
          if (_categoryColor == null) {
            print("categoryColor == null");
          } else {
            print("categoryColor != null");
          }
          final category = Category(
              category: _category, id: uuidGen.v4(), color: _categoryColor);
          await widget.dataBase.setCategory(category);
        }
        Navigator.of(context).pop();
      } catch (e) {
        print("ERROR Submit task ${e.toString()}");
      }
    }
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    color: LIGHT_ACCENT,
                    onPressed: () {
                      setState(() {
                        addTask = true;
                      });

                      ///  verbessern!
                    },
                    child: Text(
                      "Task",
                    )),
                FlatButton(
                    color: LIGHT_ACCENT,
                    onPressed: () {
                      setState(() {
                        addTask = false;
                      });

                      /// verbessern!
                    },
                    child: Text(
                      "Category",
                    ))
              ],
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: addTask ? "Task" : "Category",
                    hintStyle: TextStyle(
                      color: LIGHT_ACCENT,
                    )),
                validator: (value) =>
                    value.isNotEmpty ? null : "Task can not be empty!",
                onSaved: (newValue) =>
                    addTask ? _task = newValue : _category = newValue,
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: MediaQuery.of(context).size.height / 10,
              child: addTask ? _buildCategoryRow() : null,
            ),
            !addTask
                ? FlatButton(
                    color: LIGHT_ACCENT,
                    child: Text("chose Color"),
                    onPressed: () {
                      _showColorDialog();
                    },
                  )
                : Container(),
            SizedBox(height: 30),
            FlatButton(
                color: LIGHT_ACCENT,
                child: Text("Save"),
                onPressed: () => _submit())
          ],
        ),
      ),
    );
  }

  _buildCategoryRow() {
    return StreamBuilder(
      stream: widget.dataBase.categoriesStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder(
          scrollDirection: Axis.horizontal,
          snapshot: snapshot,
          itemBuilder: (context, category) {
            return Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Color(category.color), width: 2),
                        color: DARK_BLUE,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.category,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                  onTap: () {
                    _addTaskCategoryColor = category.color;
                  },
                ));
          },
        );
      },
    );
  }

  _showColorDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("Choose color"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildColorRow([
                CATEGORIE_COLORS[0],
                CATEGORIE_COLORS[1],
                CATEGORIE_COLORS[2],
                CATEGORIE_COLORS[3]
              ]),
              SizedBox(height: 10),
              _buildColorRow([
                CATEGORIE_COLORS[4],
                CATEGORIE_COLORS[5],
                CATEGORIE_COLORS[6],
                CATEGORIE_COLORS[7]
              ]),
              SizedBox(height: 10),
              _buildColorRow([
                CATEGORIE_COLORS[8],
                CATEGORIE_COLORS[9],
                CATEGORIE_COLORS[10],
                CATEGORIE_COLORS[11]
              ]),
              SizedBox(height: 10),
              _buildColorRow([
                CATEGORIE_COLORS[12],
                CATEGORIE_COLORS[13],
                CATEGORIE_COLORS[14],
                CATEGORIE_COLORS[15]
              ])
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorRow(List<int> colorList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton(
          mini: true,
          elevation: 5.0,
          onPressed: () {
            _categoryColor = colorList[0];
            Navigator.of(context).pop();
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Color(colorList[0]),
          ),
        ),
        FloatingActionButton(
          mini: true,
          elevation: 5.0,
          onPressed: () {
            _categoryColor = colorList[1];
            Navigator.of(context).pop();
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Color(colorList[1]),
          ),
        ),
        FloatingActionButton(
          mini: true,
          elevation: 5.0,
          onPressed: () {
            _categoryColor = colorList[2];
            Navigator.of(context).pop();
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Color(colorList[2]),
          ),
        ),
        FloatingActionButton(
          mini: true,
          elevation: 5.0,
          onPressed: () {
            _categoryColor = colorList[3];
            Navigator.of(context).pop();
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Color(colorList[3]),
          ),
        ),
      ],
    );
  }
}
