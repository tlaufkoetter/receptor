import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:receptor/recipes/recipes.model.dart';

class RecipeSetter extends StatefulWidget {
  final Recipe _recipe;
  RecipeSetter(this._recipe, {Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RecipeSetterState();
  }
}

class _RecipeSetterState extends State<RecipeSetter> {
  Future<List<String>> _findSuggestions(String query) async {
    return query.isNotEmpty ? [query] : [];
  }

  final _newTags = <String>[];
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _newTags.addAll(widget._recipe.tags);
    _nameController.text = widget._recipe.name;

    final theme = Theme.of(context);
    var children = List<Widget>();
    children.add(Center(
        child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: TextFormField(
                style: theme.textTheme.headline5,
                controller: _nameController))));
    children.add(Text("Tags", style: theme.textTheme.headline6));

    children.add(ChipsInput(
      initialValue: widget._recipe.tags,
      decoration: InputDecoration(
        labelText: "Tags bearbeiten",
      ),
      findSuggestions: _findSuggestions,
      onChanged: (List<String> data) {
        _newTags.clear();
        _newTags.addAll(data);
      },
      chipBuilder: (context, state, tag) {
        return InputChip(
          key: ObjectKey(tag),
          label: Text(tag),
          onDeleted: () => state.deleteChip(tag),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      },
      suggestionBuilder: (context, state, tag) {
        return ListTile(
          key: ObjectKey(tag),
          title: Text(tag),
          onTap: () => state.selectSuggestion(tag),
        );
      },
    ));
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 150,
          leading: FlatButton(
            child: Text("Abbrechen"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            FlatButton(
              child: Text("Fertig"),
              onPressed: () {
                widget._recipe.name = _nameController.text;
                widget._recipe.tags = _newTags;
                Navigator.of(context).pop(widget._recipe);
              },
            )
          ],
        ),
        body: Container(
            child: ListView(children: children),
            padding: EdgeInsets.only(left: 20, right: 20)));
  }
}
