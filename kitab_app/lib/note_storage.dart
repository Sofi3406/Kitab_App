import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NoteStorage {
  static String _notesKey(String lessonKey) => 'notes_$lessonKey';

  static Future<List<String>> loadNotes(String lessonKey) async {
    final prefs = await SharedPreferences.getInstance();
    final rawNotes = prefs.getString(_notesKey(lessonKey));
    if (rawNotes == null || rawNotes.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(rawNotes);
    if (decoded is List) {
      return decoded.whereType<String>().toList();
    }

    return [];
  }

  static Future<void> saveNotes(String lessonKey, List<String> notes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey(lessonKey), jsonEncode(notes));
  }
}
