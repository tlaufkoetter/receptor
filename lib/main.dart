import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receptor/recipes/recipes.repository.dart';
import 'package:receptor/tags/tags-list.widget.dart';

import 'recipes/recipe-list.widget.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  runApp(ChangeNotifierProvider(
      create: (context) => RecipesRepository(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                  label: "Rezepte", icon: Icon(CupertinoIcons.list_bullet)),
              BottomNavigationBarItem(
                  label: "Tags", icon: Icon(CupertinoIcons.tags))
            ],
          ),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return CupertinoTabView(
                    defaultTitle: "Rezepte",
                    builder: (context) => RecipesList());
              case 1:
                return CupertinoTabView(
                    defaultTitle: "Tags", builder: (context) => TagsList());
              default:
                assert(false, "No tab");
                return null;
            }
          },
        ),
        title: 'Rezeptor',
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        builder: (context, child) => CupertinoTheme(
              data: CupertinoThemeData(),
              child: Material(child: child),
            ));
  }
}
