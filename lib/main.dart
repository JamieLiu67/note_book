import 'package:flutter/material.dart';
import 'package:note_book/models/note_database.dart';
import 'package:provider/provider.dart';
import 'pages/notes_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(ChangeNotifierProvider(
    create: (context) => NoteDatabase(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}
