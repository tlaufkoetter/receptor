import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverListPack<T> extends StatelessWidget {
  final List<T> _data;
  final Widget Function(BuildContext context, T item) _itemBuilder;

  BorderRadius _getRadius(int listIndex) {
    if (listIndex == 0) {
      return BorderRadius.vertical(top: Radius.circular(10));
    } else if (listIndex == _data.length - 1) {
      return BorderRadius.vertical(bottom: Radius.circular(10));
    } else {
      return BorderRadius.zero;
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == 0 && _data == null) {
      return CupertinoActivityIndicator();
    }
    final listIndex = index ~/ 2;
    if (_data == null || listIndex >= _data.length) {
      return null;
    }

    if (index % 2 == 1) {
      return Divider(
        height: 0,
      );
    }
    return ClipRRect(
        borderRadius: _getRadius(listIndex),
        child: _itemBuilder(context, _data[listIndex]));
  }

  SliverListPack(this._data, this._itemBuilder);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(_buildItem),
    );
  }
}
