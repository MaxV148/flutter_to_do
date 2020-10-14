import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_v3/categories/category.dart';
import 'package:todo_v3/categories/category_list_tile.dart';
import 'package:todo_v3/common_widgets/list_items_builder.dart';
import 'package:todo_v3/constants.dart';
import 'package:todo_v3/services/auth.dart';
import 'package:todo_v3/services/data_base.dart';
import 'package:todo_v3/tasks/add_Page.dart';
import 'package:todo_v3/tasks/task.dart';
import 'package:todo_v3/tasks/task_list_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _updatedTask;
  int _updatedCategoryColor;

  final _formKey = GlobalKey<FormState>();
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      backgroundColor: BG_BLUE,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: BG_BLUE,
        elevation: 0.0,
        actions: [
          FlatButton(
            child: Icon(Icons.exit_to_app, size: 30, color: LIGHT_ACCENT),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              "What's up, ${auth.userName}!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 6,
            child: _buildContentCategoryList(context),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: _buildContentTaskList(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LIGHT_ACCENT,
        child: Icon(
          Icons.add,
          color: PINK,
        ),
        onPressed: () => AddPage.show(context),
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context, Task task) async {
    try {
      final database = Provider.of<DataBase>(context, listen: false);
      await database.deleteTask(task);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _deleteCategory(DataBase dataBase, Category category) async {
    try {
      //final database = Provider.of<DataBase>(context, listen: false);
      await dataBase.deleteCategory(category);
    } catch (e) {
      print(e.toString());
    }
  }

  _buildContentCategoryList(BuildContext context) {
    final dataBase = Provider.of<DataBase>(context, listen: false);
    return StreamBuilder(
      stream: dataBase.categoriesStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder(
          scrollDirection: Axis.horizontal,
          snapshot: snapshot,
          itemBuilder: (context, category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 20),
              child: CategoryListTile(
                category: category,
                categoryColor: category.color,
                onTap: () {
                  _showDelteCategoryDialog(context, category.color, category);
                },
              ),
            );
          },
        );
      },
    );
  }

  _showTaskDialog(BuildContext context, Task task) {
    final database = Provider.of<DataBase>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: DARK_BLUE,
          elevation: 0.0,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${task.task}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 10),
                Divider(
                  color: Color(_updatedCategoryColor ?? task.taskCategoryColor),
                  thickness: 2,
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    initialValue: task.task,
                    onSaved: (newValue) {
                      _updatedTask = newValue;
                      _updateTask(task, database);
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height / 8,
                  child: _buildCategoryRow(database),
                ),
                SizedBox(height: 20),
                FlatButton(
                  color: LIGHT_ACCENT,
                  child: Text("Save"),
                  onPressed: () {
                    _formKey.currentState.save();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _updateTask(Task task, DataBase dataBase) async {
    final Task updatedTask = Task(
        task: _updatedTask,
        id: task.id,
        taskCategoryColor: _updatedCategoryColor ?? task.taskCategoryColor);
    await dataBase.setTask(updatedTask);
    Navigator.of(context).pop();
  }

  _showDelteCategoryDialog(BuildContext context, int color, Category category) {
    final DataBase dataBase = Provider.of<DataBase>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0.0,
          backgroundColor: DARK_BLUE,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category.category,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 25),
                Divider(color: Color(color), thickness: 2),
                SizedBox(height: 25),
                IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    _deleteCategory(dataBase, category);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _buildCategoryRow(DataBase dataBase) {
    return StreamBuilder(
      stream: dataBase.categoriesStream(),
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
                    setState(() {
                      _updatedCategoryColor = category.color;
                    });
                    print(_updatedCategoryColor);
                  },
                ));
          },
        );
      },
    );
  }

  _buildContentTaskList(BuildContext context) {
    final dataBase = Provider.of<DataBase>(context, listen: false);
    return StreamBuilder(
      stream: dataBase.tasksStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder(
            snapshot: snapshot,
            itemBuilder: (context, task) {
              return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 5, left: 20, right: 20),
                  child: Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key('task-${task.id}'),
                    child: GestureDetector(
                      child: TaskListTile(
                          task: task, color: task.taskCategoryColor),
                      onTap: () => _showTaskDialog(context, task),
                    ),
                    background: Container(
                      padding: EdgeInsets.only(right: 15),
                      alignment: Alignment.centerRight,
                      color: LIGHT_ACCENT,
                      child:
                          Icon(Icons.delete_sweep, color: Colors.red, size: 30),
                    ),
                    onDismissed: (direction) => _deleteTask(context, task),
                  ));
            });
      },
    );
  }
}
