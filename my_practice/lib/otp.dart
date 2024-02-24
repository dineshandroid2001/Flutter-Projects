import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_practice/main_page.dart';

class OtpVerify extends StatefulWidget {
  String verficationid;
  OtpVerify({super.key, required this.verficationid});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Chat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: otp,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter Otp",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (otp.text.isNotEmpty && otp.text.length == 6) {
                try {
                  PhoneAuthCredential credential =
                      await PhoneAuthProvider.credential(
                    verificationId: widget.verficationid,
                    smsCode: otp.text.toString(),
                  );
                  FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  });
                } catch (ex) {
                  print(ex);
                }
              } else {
                // Handle invalid OTP input
                print('Invalid OTP');
              }
            },
            child: const Text('Enter'),
          ),
        ],
      ),
    );
  }
}

/*
try {
              PhoneAuthCredential credential = await PhoneAuthProvider.credential(
                verificationId: widget.verficationid,
                smsCode: otp.text.toString());
                FirebaseAuth.instance.signInWithCredential(credential).then((value){
                  Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const MainPage()));
                });
            }
            catch(ex) {
              log(ex.toString() as num);
            }
*/