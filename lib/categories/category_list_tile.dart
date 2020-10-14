import 'package:flutter/material.dart';
import 'package:todo_v3/categories/category.dart';
import 'package:todo_v3/constants.dart';

class CategoryListTile extends StatelessWidget {
  CategoryListTile(
      {@required this.category, @required this.categoryColor, this.onTap});
  final Category category;
  final int categoryColor;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: DARK_BLUE,
        ),
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "10 Tasks",
                style: TextStyle(color: LIGHT_ACCENT, fontSize: 12),
              ),
              Text(
                category.category ?? "NULL",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Divider(
                color: Color(categoryColor),
                thickness: 3,
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
