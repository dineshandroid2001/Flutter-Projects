import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
//import 'package:permission_handler/permission_handler.dart';
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
          backgroundColor: const Color.fromARGB(0, 255, 59, 59),
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
                  onPressed: () {imagefromgallery();},
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
                        return ListTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(125),
                              child: Image.network(image)),
                          title: Text(name,style: const TextStyle(color: Colors.white),),
                          subtitle: Text(
                            email,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                ),
              ],
            ),
            const Text('Add Events',style: TextStyle(color: Colors.white),),
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
*/
