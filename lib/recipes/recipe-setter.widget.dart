import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:receptor/recipes/recipes.model.dart';
import 'package:receptor/recipes/recipes.repository.dart';

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
    final tags = await RecipesRepository().getAllTags(false);
    return tags
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  final _newTags = <String>[];
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _newTags.addAll(widget._recipe.tags);
    _nameController.text = widget._recipe.name;

    final theme = Theme.of(context);
    var children = List<Widget>();
    children.add(Center(
        child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Form(
                key: _formKey,
                child: TextFormField(
                    decoration: InputDecoration(labelText: "Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Bitte einen Namen eingeben";
                      else
                        return null;
                    },
                    controller: _nameController,
                    onChanged: (_) => _formKey.currentState.validate(),
                    style: theme.textTheme.headline5)))));
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
    if (widget._recipe.id != null) {
      children.add(Padding(
          padding: EdgeInsets.only(top: 100),
          child: MaterialButton(
            child: Text("Rezept Löschen"),
            color: Colors.red,
            onPressed: () async {
              await RecipesRepository().deleteRecipe(widget._recipe);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )));
    }
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
              onPressed: () async {
                if (!_formKey.currentState.validate()) return;
                widget._recipe.tags = _newTags;
                widget._recipe.name = _nameController.text;
                Navigator.of(context).pop(
                    await RecipesRepository().updateRecipe(widget._recipe));
              },
            )
          ],
        ),
        body: Container(
            child: ListView(children: children),
            padding: EdgeInsets.only(left: 20, right: 20)));
  }
}
