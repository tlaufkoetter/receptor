import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receptor/recipes/recipe-setter.widget.dart';
import 'package:receptor/recipes/recipes.model.dart';

class RecipesDetail extends StatefulWidget {
  final Recipe _recipe;
  RecipesDetail(this._recipe);
  _RecipesDetailState createState() {
    return _RecipesDetailState(_recipe);
  }
}

class _RecipesDetailState extends State<RecipesDetail> {
  Recipe _recipe;
  _RecipesDetailState(this._recipe);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var children = List<Widget>();
    children.add(Center(
        child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(_recipe.name, style: theme.textTheme.headline5))));
    children.add(Text("Tags", style: theme.textTheme.headline6));
    if (_recipe.tags.isEmpty) {
      children
          .add(Text("keine Tags vorhanden", style: theme.textTheme.subtitle1));
    } else {
      var tags = _recipe.tags
          .map((t) => Padding(
              padding: EdgeInsets.only(right: 5),
              child: InputChip(label: Text(t), onSelected: (bool value) {})))
          .toList();
      children.add(Wrap(children: tags));
    }
    children.add(Divider());
    children.add(Text("Zutaten", style: theme.textTheme.headline6));
    children
        .add(Text("keine Zutaten vorhanden", style: theme.textTheme.subtitle1));
    if (_recipe.cookBook != null) {
      children.add(Divider());
      children.add(Text("Quelle", style: theme.textTheme.headline6));
      var name = _recipe.cookBook.name;
      if (_recipe.cookBook.pageNumber != null) {
        name += " (S. ${_recipe.cookBook.pageNumber})";
      }

      children.add(Text(
        name,
        style: theme.textTheme.subtitle1,
      ));
    }
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text("Bearbeiten"),
          onPressed: () async {
            var result = await Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) =>
                    RecipeSetter(_recipe, key: ObjectKey(this))));
            if (result is Recipe) {
              setState(() => _recipe = result);
            }
          },
        ),
      ),
      child: Container(
        child: ListView(
          children: children,
        ),
        padding: EdgeInsets.only(left: 20, right: 20),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.edit),
      //   onPressed: () async {
      //     var result = await Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) =>
      //             RecipeSetter(_recipe, key: ObjectKey(this))));
      //     if (result is Recipe) {
      //       setState(() => _recipe = result);
      //     }
      //   },
      // ),
    );
  }
}
