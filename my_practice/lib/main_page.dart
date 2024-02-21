import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_practice/jsonmodel/users.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File? selectimage;
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.brown,
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.camera_alt)),
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.event)),
                Tab(icon: Icon(Icons.list)),
              ],
            ),
            backgroundColor: Colors.green,
            centerTitle: true,
            title: const Text(
              'Application',
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
                  onPressed: () async {
                    var status = await Permission.photos.request();
                    if (status.isGranted) {
                      imagefromgallery();
                    } else {
                      //openAppSettings();
                    }
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
                      style: TextStyle(color: Colors.black),
                    )),
                Expanded(
                  child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final name = user['name']['first'];
                        final email = user['email'];
                        final image = user['picture']['thumbnail'];
                        return ListTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(125),
                              child: Image.network(image)),
                          title: Text(name),
                          subtitle: Text(
                            email,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }),
                ),
              ],
            ),
            const Text('chat'),
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
