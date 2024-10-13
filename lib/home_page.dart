import 'package:flutter/material.dart';

import 'db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DBHelper dbHelper = DBHelper.getInstance();

// DBHelper se aaye data k object allNotes

  List<Map<String, dynamic>> allNotes = [];
  @override
  void initState() {
    super.initState();
    getMyNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Note App"),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        //update//
                        IconButton(
                            onPressed: () async {
                              titleController.text =
                                  allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                              descController.text =
                                  allNotes[index][DBHelper.COLUMN_NOTE_DESC];
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return getBottomSheetUi(
                                        isUpdate: true,
                                        id: allNotes[index]
                                            [DBHelper.COLUMN_NOTE_ID]);
                                  });
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () async {
                              bool check = await dbHelper.deleteNote(
                                  id: allNotes[index][DBHelper.COLUMN_NOTE_ID]);

                              if (check) {
                                getMyNotes();
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No Notes Yet"),
                  OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return getBottomSheetUi();
                            });
                      },
                      child: const Text("Add First Note")),
                ],
              ),
            ),
      floatingActionButton: allNotes.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                titleController.clear();
                descController.clear();
                showModalBottomSheet(
                    isDismissible: false,
                    enableDrag: false,
                    context: context,
                    builder: (_) {
                      return getBottomSheetUi();
                    });
              },
              child: const Icon(
                Icons.add,
                color: Colors.green,
              ),
            )
          : null,
    );
  }

  getMyNotes() async {
    allNotes = await dbHelper.getAllNotes();
    setState(() {});
  }

  Widget getBottomSheetUi({bool isUpdate = false, int id = 0}) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(isUpdate ? 'update Note' : "add Notes"),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4)),
                  labelText: "Title",
                  hintText: "Title Note"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4)),
                  labelText: "Description",
                  hintText: "Description Note"),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            descController.text.isNotEmpty) {
                          bool check = false;

                          if (isUpdate) {
                            check = await dbHelper.updateNote(
                                Updatedtitle: titleController.text,
                                Updateddesc: descController.text,
                                id: id);
                          } else {
                            check = await dbHelper.addNote(
                              title: titleController.text,
                              desc: descController.text,
                            );
                          }

                          if (check) {
                            getMyNotes();
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text("Save"))),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("cancel")),
              ),
            ],
          )
        ],
      ),
    );
  }
}
