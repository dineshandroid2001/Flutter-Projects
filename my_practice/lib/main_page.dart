import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_practice/SQflite/sqlite.dart';
import 'package:my_practice/addevent.dart';
import 'package:my_practice/jsonmodel/events.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File? selectimage;
  List<dynamic> users = [];
  //events
  late DatabaseHelper handler;
  late Future<List<EventModel>> details;
  final db = DatabaseHelper();

  final name = TextEditingController();
  final place = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    details = handler.getNotes();

    handler.initDB().whenComplete(() {
      details = getAllNotes();
    });
    super.initState();
  }

  Future<List<EventModel>> getAllNotes() {
    return handler.getNotes();
  }

  //Search method here
  //First we have to create a method in Database helper class
  Future<List<EventModel>> searchNote() {
    return handler.searchNotes(keyword.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      details = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.camera_alt)),
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.event)),
                Tab(icon: Icon(Icons.list)),
              ],
            ),
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: const Text(
              'Start Chat',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          body: TabBarView(children: [
            Column(
              children: [
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    pickimagefromcamera();
                  },
                  child: const Text(
                    'Take Photo from Camera',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    imagefromgallery();
                  },
                  child: const Text(
                    'Select Photo from Gallery',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 400.0,
                  width: 400.0,
                  child: selectimage == null
                      ? const SizedBox()
                      : Center(child: Image.file(selectimage!)),
                ),
              ],
            ),
            Column(
              children: [
                TextButton(
                    onPressed: () async {
                      const url = 'https://randomuser.me/api/?results=20';
                      final uri = Uri.parse(url);
                      final response = await http.get(uri);
                      final body = response.body;
                      final json = jsonDecode(body);
                      setState(() {
                        users = json['results'];
                      });
                    },
                    child: const Text(
                      'Call API',
                      style: TextStyle(color: Colors.white),
                    )),
                Expanded(
                  child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final name = user['name']['first'];
                        final email = user['email'];
                        final image = user['picture']['thumbnail'];
                        return Card(
                          child: ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(125),
                                child: Image.network(image)),
                            title: Text(
                              name,
                              style: const TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              email,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 8),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateNote()))
                          .then((value) {
                        if (value) {
                          //This will be called
                          _refresh();
                        }
                      });
                    },
                    child: const Text('Add Event',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.brown,
                    ),
                    )),
                    const SizedBox(height: 8),
                //Search Field here
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    controller: keyword,
                    onChanged: (value) {
                      //When we type something in textfield
                      if (value.isNotEmpty) {
                        setState(() {
                          details = searchNote();
                        });
                      } else {
                        setState(() {
                          details = getAllNotes();
                        });
                      }
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                        hintText: "Search"),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: FutureBuilder<List<EventModel>>(
                    future: details,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<EventModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const Center(child: Text("No data"));
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        final items = snapshot.data ?? <EventModel>[];
                        return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 6,
                                child: ListTile(
                                  subtitle: Text(DateFormat("yMd").format(
                                      DateTime.parse(items[index].createdAt))),
                                  title: Text(items[index].eventName),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      //We call the delete method in database helper
                                      db
                                          .deleteNote(items[index].eventId!)
                                          .whenComplete(() {
                                        //After success delete , refresh notes
                                        //Done, next step is update notes
                                        _refresh();
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    //When we click on note
                                    setState(() {
                                      name.text = items[index].eventName;
                                      place.text = items[index].eventPlace;
                                      date.text = items[index].eventDate;
                                      time.text = items[index].eventTime;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actions: [
                                              Row(
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      //Now update method
                                                      db
                                                          .updateNote(
                                                              name.text,
                                                              place.text,
                                                              date.text,
                                                              time.text,
                                                              items[index].eventId)
                                                          .whenComplete(() {
                                                        //After update, note will refresh
                                                        _refresh();
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: const Text("Update"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            title: const Text("Update note"),
                                            content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller: name,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Event Name is required";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text("Name of Events"),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: place,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Place is required";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text("Place"),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: date,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Date is required";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text("Date"),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: time,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Event Time is required";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text("Time of that Events"),
                                                    ),
                                                  ),
                                                ]),
                                          );
                                        });
                                  },
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
              ],
            ),
            Text('end'),
          ]),
        ),
      ),
    );
  }

  //picking image from camera
  Future pickimagefromcamera() async {
    final returnimg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnimg == null) {
      return;
    }
    setState(() {
      selectimage = File(returnimg.path);
    });
  }

  //select image from gallery
  Future imagefromgallery() async {
    final returngallery =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returngallery == null) {
      return;
    }
    setState(() {
      selectimage = File(returngallery.path);
    });
  }
}

/* asking permission for camera access
onPressed: () async {
                    var status = await Permission.photos.request();
                    if (status.isGranted) {
                      imagefromgallery();
                    } else {
                      openAppSettings();
                    }
                  },


ElevatedButton(onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => EventAdd(tabindex:2)));},
            child: Text('click'),
            ),
*/
