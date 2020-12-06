import 'dart:convert';

import 'package:receptor/http/backend.service.dart';
import 'package:receptor/tags/tag.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagsRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<String>> getAllTags(bool forceRefresh) async {
    var prefs = await _prefs;

    String data;
    if (!forceRefresh) {
      if (prefs.containsKey("seasons")) {
        data = prefs.getString("seasons");
      }
    }

    if (data == null) {
      try {
        final response = await BackendService().get("api/getAllSeasons.php");
        data = response.data;
        final SharedPreferences prefs = await _prefs;
        prefs.setString("seasons", data);
      } on ServerUnreachableError catch (e) {
        if (!prefs.containsKey("seasons")) throw e;
        data = prefs.getString("seasons");
      }
    }
    final jsonResponse = jsonDecode(data) as List;
    final tags =
        jsonResponse.map((recipe) => Season.fromJson(recipe).name).toList();
    tags.sort((a, b) => a.compareTo(b));
    return tags;
  }
}
