import 'package:flutter/cupertino.dart';

class Category {
  Category({@required this.category, @required this.id, @required this.color});
  final String category;
  final String id;
  final int color;

  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String category = data['category'];
    final int color = data['color'];
    final String id = documentId;
    return Category(category: category, id: id, color: color);
  }

  Map<String, dynamic> toMap() {
    return {'category': category, 'color': color};
  }
}
