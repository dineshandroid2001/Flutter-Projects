import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:my_practice/main_page.dart';
import 'package:my_practice/otp.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final _formKey = GlobalKey<FormState>();
  final mobilenocontrol = TextEditingController();
  @override
  void initState() {
    super.initState();
    
  }
  void checking()async {
    final isValid = _formKey.currentState?.validate();
    if (isValid!) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException ex){},
        codeSent: (String verficationid,int? resendtoken) {
          Navigator.push(
          context, MaterialPageRoute(builder: (context) => OtpVerify(verficationid: verficationid,)));
        },
        codeAutoRetrievalTimeout: (String verficationid){},
        phoneNumber: mobilenocontrol.text.toString()
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
