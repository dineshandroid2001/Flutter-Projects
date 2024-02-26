import 'package:country_picker/country_picker.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_practice/main_page.dart';
//import 'package:my_practice/otp.dart';

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
  @override
  void initState() {
    super.initState();
    
  }
  void checking() {
    final isValid = _formKey.currentState?.validate();
    if (isValid!) {
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );
    }
    else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Country country = Country(
      phoneCode: '91',
      countryCode: 'IN',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'India',
      example: 'India',
      displayName: 'India',
      displayNameNoCountryCode: 'IN',
      e164Key: '',
      );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(0, 255, 59, 59),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.brown,
          title: const Text(
            'Start Chat',
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
                const SizedBox(height: 40),
                Container(
                  height: 200,
                  width: 300,
                  child: Image.asset(
                    'image/phone.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    controller: mobilenocontrol,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow),
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 300,
                              ),
                              context: context,
                              onSelect: (value) {
                                setState(() {
                                  country = value;
                                });
                              });
                          },
                          child: Text('${country.flagEmoji} + ${country.phoneCode}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
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
                const SizedBox(height: 30.0),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: const BoxDecoration(
                    color: Colors.brown,
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
      ),
    );
  }
}
