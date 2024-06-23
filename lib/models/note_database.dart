import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:note_book/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  //初始化
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  //笔记列表
  final List<Note> currentNotes = [];

  //添加笔记
  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser;
    await isar.writeTxn(() => isar.notes.put(newNote)); //保存
    fetchNotes(); //重新拉取
  }

  //合并所有笔记
  Future<void> fetchNotes() async {
    final notes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(notes);
    notifyListeners();
  }

  //修改笔记
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  //删除笔记
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
