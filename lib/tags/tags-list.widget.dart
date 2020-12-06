import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receptor/tags/tags.repository.dart';

class TagsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TagsListState();
  }
}

class _TagsListState extends State<TagsList> {
  List<String> _tags;

  @override
  void initState() {
    TagsRepository()
        .getAllTags(false)
        .then((tags) => setState(() => _tags = tags));
    super.initState();
  }

  BorderRadius _getClip(int index) {
    if (index == 0) return BorderRadius.vertical(top: Radius.circular(10));
    if (index == _tags.length - 1)
      return BorderRadius.vertical(bottom: Radius.circular(10));
    return BorderRadius.zero;
  }

  Widget _buildList(BuildContext context, int index) {
    if (_tags == null) {
      return CupertinoActivityIndicator();
    }
    if (index ~/ 2 >= _tags.length) {
      return null;
    }

    if (index % 2 == 1) {
      return Divider(height: 0);
    }

    return ClipRRect(
        borderRadius: _getClip(index ~/ 2),
        child: ListTile(
            dense: true,
            tileColor: Theme.of(context).canvasColor,
            title: Text(_tags[index ~/ 2])));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            _tags = await TagsRepository().getAllTags(true);
            setState(() {});
          },
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: EdgeInsets.all(15),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(_buildList),
            ),
          ),
        )
      ],
    );
  }
}
