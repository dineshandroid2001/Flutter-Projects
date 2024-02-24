import 'package:flutter/material.dart';
import 'package:my_practice/SQflite/sqlite.dart';
import 'package:my_practice/jsonmodel/users.dart';
import 'package:my_practice/main_page.dart';
import 'package:my_practice/mobile_login.dart';
import 'package:my_practice/sign_up.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usernamecontrol = TextEditingController();
  final passwordcontrol = TextEditingController();
  final otpcontrol = TextEditingController();
  bool isvisible = true;
  final db = DatabaseHelper();
  bool logincheck = false;
  login() async {
    var response = await db.login(
        Users(username: usernamecontrol.text, password: passwordcontrol.text));
    if (response == true) {
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    } else {
      setState(() {
        logincheck = true;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.green,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //const SizedBox(height: 10.0),
                  // Container(
                  //   height: 100,
                  //   width: 230,
                  //   child: Image.asset(
                  //     'image/welcome1.png',
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Welcomes You!',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  //validating
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: usernamecontrol,
                      obscureText: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'User Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid Username!,';
                        } else if (value.length < 6) {
                          return 'Enter more than five characters';
                        }
                        return null;
                      },
                    ),
                  ),
            
                  const SizedBox(height: 20.0),
            
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: passwordcontrol,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 8) {
                          return 'Password must contains atleast 8 characters';
                        } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contains atleast 1 upper case';
                        } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          return 'Password must contains atleast 1 special character';
                        } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Password must contains atleast 1 digits';
                        }
                        return null;
                      },
                      obscureText: isvisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Create Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isvisible = !isvisible;
                            });
                          },
                          icon: Icon(isvisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                    ),
                  ),
            
                  const SizedBox(height: 20.0),
            
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: const BoxDecoration(
                      //borderRadius: BorderRadius.zero,
                      color: Colors.brown,
                    ),
                    child: TextButton(
                      onPressed: () {
                        _submit();
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 22.0, color: Colors.black),
                      ),
                    ),
                  ),
                  logincheck
                      ? const Text(
                          'Username and Password is incorrect',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 15.0,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20.0),
            
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      const Text(
                        "If you don't have account.",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.red,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.zero,
                      color: Colors.brown,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MobileLogin()));
                      },
                      child: const Text(
                        'Login with Phone number',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
