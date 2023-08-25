import 'package:flutter/material.dart';
import 'package:todoapp_codesoft/Screens/TodoPage.dart';
import 'package:todoapp_codesoft/database/LocalStorage.dart';

class AddtodoPage extends StatefulWidget {
  final LocalStorage? initialNote;
  const AddtodoPage({this.initialNote, super.key});

  @override
  State<AddtodoPage> createState() => _AddtodoPageState();
}

class _AddtodoPageState extends State<AddtodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedPriority = 'Normal';

  Map<String, int> priorityValues = {
    'Urgent': 1,
    'Important': 2,
    'Normal': 3,
  };
  void initState() {
    super.initState();
    if (widget.initialNote != null) {
      titleController.text = widget.initialNote!.title;
      descriptionController.text = widget.initialNote!.description;
      selectedPriority = getPriorityLabel(widget.initialNote!.priority);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(widget.initialNote == null ? "Add To do" : "Edit to do")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey,
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter Title",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              cursorColor: Colors.grey,
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Enter description",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              maxLines: 6,
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedPriority = newValue;
                  });
                }
              },
              items: priorityValues.keys.map<DropdownMenuItem<String>>(
                (String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                },
              ).toList(),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  String title = titleController.text;
                  String description = descriptionController.text;
                  int? priorityValue = priorityValues[selectedPriority]!;

                  LocalStorage note = LocalStorage(
                    title: title,
                    description: description,
                    priority: priorityValue,
                  );
                  if (widget.initialNote != null) {
                    await updateNoteToLocal(note, widget.initialNote!.priority);
                  } else {
                    await saveNoteToLocal(note);
                  }
                  titleController.clear();
                  descriptionController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        widget.initialNote == null
                            ? 'Saved data'
                            : 'Updated data',
                      ),
                      backgroundColor: Color.fromARGB(255, 16, 197, 70),
                    ),
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TodoPage()));
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey.shade900),
                ),
                child: Text(
                  widget.initialNote == null ? "Submit" : "Update",
                  style: TextStyle(fontSize: 15),
                )),
          ],
        ),
      ),
    );
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
}
