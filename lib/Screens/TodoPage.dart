import 'package:flutter/material.dart';
import 'package:todoapp_codesoft/Screens/AddtodoPage.dart';
import 'package:todoapp_codesoft/database/LocalStorage.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<LocalStorage> notes = [];
  List<int> selectedIndices = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    List<LocalStorage> loadedNotes = await getNotesFromLocal();
    setState(() {
      notes = loadedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "ToDo List",
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            var editedNote = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddtodoPage(),
              ),
            );
            if (editedNote != null) {
              await _loadNotes();
            }
          },
          label: Text("Add to do")),
      body: notes.isEmpty
          ? Center(
              child: Text(
                "No data available.",
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedIndices.contains(index);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Row(children: [
                    Text(
                      notes[index].title,
                      style: TextStyle(
                        decoration: isSelected
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: isSelected ? 3.0 : 0.0,
                      ),
                    ),
                    Spacer(),
                    Text(
                      " ${getPriorityLabel(notes[index].priority)}",
                      style: TextStyle(
                        color: getColorForPriority(notes[index].priority),
                        fontSize: 15,
                      ),
                    ),
                  ]),
                  subtitle: Text(
                    notes[index].description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String choice) {
                      if (choice == 'complete') {
                        setState(() {
                          if (isSelected) {
                            selectedIndices.remove(index);
                          } else {
                            selectedIndices.add(index);
                          }
                        });
                      } else if (choice == 'edit') {
                        _editNote(notes[index], index);
                      } else if (choice == 'delete') {
                        _deleteNote(index);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'complete',
                          child: Text(isSelected ? 'Incomplete' : 'Complete'),
                        ),
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _deleteNote(int index) async {
    await deleteNoteFromLocal(index);

    setState(() {
      selectedIndices.remove(index);
      notes.removeAt(index);
    });
  }

  void _editNote(LocalStorage note, int index) async {
    var editedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddtodoPage(initialNote: note),
      ),
    );
    if (editedNote != null) {
      await updateNoteToLocal(editedNote, index);
      await _loadNotes();
    }
  }

  String getPriorityLabel(int priority) {
    if (priority == 2) {
      return "Important";
    } else if (priority == 1) {
      return "Urgent";
    } else {
      return "Normal";
    }
  }

  Color getColorForPriority(int priority) {
    if (priority == 1) {
      return Colors.red;
    } else if (priority == 2) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
