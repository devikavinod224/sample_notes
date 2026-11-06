import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class Note {
  final String title;
  final String content;

  Note({required this.title, required this.content});
}

/// Manages the collection of notes using ChangeNotifier for state management.
class NotesData extends ChangeNotifier {
  final List<Note> _notes = [];

  // Initial dummy data for demonstration
  NotesData() {
    _notes.add(Note(title: 'Welcome', content: 'This is your first note!'));
    _notes.add(Note(title: 'notes List', content: 'python,java,c++'));
    _notes.add(
      Note(
        title: 'Important Task',
        content: 'complete a flutter tutorial',
      ),
    );
  }
  List<Note> get notes => List.unmodifiable(_notes);
  void addNote(String title, String content) {
    if (title.isNotEmpty || content.isNotEmpty) {
      _notes.add(Note(title: title, content: content));
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesData>(
      create: (context) => NotesData(),
      builder: (context, child) {
        return MaterialApp(
          title: 'Notes App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample Notes')),
      body: Consumer<NotesData>(
        builder: (context, notesData, child) {
          if (notesData.notes.isEmpty) {
            return const Center(
              child: Text(
                'No notes yet. Add one!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: notesData.notes.length,
            itemBuilder: (context, index) {
              final note = notesData.notes[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                elevation: 2.0,
                child: ListTile(
                  title: Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(note.content),
                  // Optionally add more actions like edit/delete
                  onTap: () {
                    // Could navigate to a detail screen or show a bottom sheet for editing
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  void _showAddNoteDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use a different context name to avoid confusion
        return AlertDialog(
          title: const Text('Add Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final notesData = Provider.of<NotesData>(
                  dialogContext,
                  listen: false,
                );
                notesData.addNote(
                  titleController.text.trim(),
                  contentController.text.trim(),
                );
                Navigator.of(dialogContext).pop(); 
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
