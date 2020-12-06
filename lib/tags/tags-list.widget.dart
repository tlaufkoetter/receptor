import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receptor/shared/lists/sliver-list-pack.widget.dart';
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
            sliver: SliverListPack(
                _tags,
                (context, data) => ListTile(
                    dense: true,
                    tileColor: Theme.of(context).canvasColor,
                    title: Text(data))),
          ),
        )
      ],
    );
  }
}
