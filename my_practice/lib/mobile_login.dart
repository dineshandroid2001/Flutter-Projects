import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_practice/main_page.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final _formKey = GlobalKey<FormState>();
  final mobilenocontrol = TextEditingController();
  final digit1 = TextEditingController();
  final digit2 = TextEditingController();
  final digit3 = TextEditingController();
  final digit4 = TextEditingController();
  void checking() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter the OTP'),
            content: Row(
              children: [
                SizedBox(
                  height: 60,
                  width: 50,
                  child: TextFormField(
                    controller: digit1,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    style: Theme.of(context).textTheme.headlineSmall,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 50,
                  child: TextFormField(
                    controller: digit2,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    style: Theme.of(context).textTheme.headlineSmall,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 50,
                  child: TextFormField(
                    controller: digit3,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    style: Theme.of(context).textTheme.headlineSmall,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 50,
                  child: TextFormField(
                    controller: digit4,
                    style: Theme.of(context).textTheme.headlineSmall,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Re-Genrate OTP'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPage()));
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          'Phone Number Login',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 25.0,
          ),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextFormField(
                  controller: mobilenocontrol,
                  obscureText: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 10) {
                      return 'Enter a valid Phone Number!,';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width * .9,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                ),
                child: TextButton(
                  onPressed: () {
                    checking();
                  },
                  child: const Text(
                    'Generate OTP',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
