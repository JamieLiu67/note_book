import 'package:flutter/material.dart';
import 'package:note_book/models/note.dart';
import 'package:note_book/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textControler = TextEditingController();

  void initState() {
    super.initState();
    readNotes();
  }

  void createNote() {
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            content: TextField(
              controller: textControler,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  context.read<NoteDatabase>().addNote(textControler.text);
                  Navigator.pop(context);
                },
                color: Colors.green,
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )),
    );
  }

  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  void updateNote(Note note) {
    textControler.text = note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Update Note'),
              content: TextField(
                controller: textControler,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    context
                        .read<NoteDatabase>()
                        .updateNote(note.id, textControler.text);
                    textControler.clear();
                    Navigator.pop(context);
                  },
                  color: Colors.amber,
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ));
  }

  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();

    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          title: Text('Notes'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNote,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemBuilder: (context, index) {
              final note = currentNotes[index];
              return ListTile(
                title: Text(note.text),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () => updateNote(note),
                        icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () => deleteNote(note.id),
                        icon: Icon(Icons.delete)),
                  ],
                ),
              );
            },
            itemCount: currentNotes.length));
  }
}
