import 'package:flutter/material.dart';
import 'package:my_practice/jsonmodel/events.dart';
import 'package:my_practice/SQflite/sqlite.dart';
import 'package:path/path.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final name = TextEditingController();
  final place = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ))!;

    if (picked != null && picked != DateTime.now()) {
      date.text = picked.toString(); // You can format the date as needed
    }
  }

  Future<void> pickTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      // Format the selected time and set it to the controller
      String formattedTime = selectedTime.format(context);
      time.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Start Chat",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Form(
          //I forgot to specify key
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Event Name is required';
                    }
                    return null;
                  },
                  obscureText: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.games),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter the Event Name',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextFormField(
                  controller: place,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Place is required';
                    }
                    return null;
                  },
                  obscureText: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_city),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter the Place',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextFormField(
                  controller: date,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Date is required';
                    }
                    return null;
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                        onPressed: () {
                          selectDate(context);
                        },
                        icon: const Icon(Icons.calendar_today)),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter the Date',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextFormField(
                  controller: time,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Time is required';
                    }
                    return null;
                  },
                  //obscureText: false,
                  readOnly: true,
                  onTap: () {
                    pickTime(context).then((_) {
                      // Handle any additional logic after picking the time
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.timelapse),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter the Time',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width * .9,
                decoration: const BoxDecoration(
                  //borderRadius: BorderRadius.zero,
                  color: Colors.blue,
                ),
                child: TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      db
                          .createNote(EventModel(
                              eventName: name.text,
                              eventPlace: place.text,
                              eventDate: date.text,
                              eventTime: time.text,
                              createdAt: DateTime.now().toIso8601String()))
                          .whenComplete(() {
                        Navigator.of(context).pop(true);
                      });
                    }
                  },
                  child: const Text(
                    'Create Event',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
