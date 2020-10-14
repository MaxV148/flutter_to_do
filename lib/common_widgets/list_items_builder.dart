import 'package:flutter/material.dart';
import 'package:todo_v3/common_widgets/emptyContent.dart';

/// funtion wird als Objekt definiert
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

/// listitemsbuilder kann für verschiede typen verwendet werden <T>
class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder(
      {@required this.snapshot,
      @required this.itemBuilder,
      this.scrollDirection});
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    /// Error handling
    /// wenn der übgebene snapshot daten enthält
    /// wird eine liste erstellt
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;

      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    /// list wird um 2 elemente verlängert um am anfang und ende
    /// zwei künstliche listen elemente zu erstellen
    /// damit oben und unten ein Divider entsteht
    return ListView.separated(
      /// list.builder erstellt on fly eine list aus den snapshot items
      /// return itemBuilder => erstellt das ListTile
      scrollDirection: scrollDirection ?? Axis.vertical,
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
