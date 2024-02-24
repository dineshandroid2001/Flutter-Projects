import 'package:flutter/material.dart';
import 'package:my_practice/SQflite/sqlite.dart';
import 'package:my_practice/home_page.dart';
import 'package:my_practice/jsonmodel/users.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final namecontrol = TextEditingController();
  final lastnamecontrol = TextEditingController();
  final username1control = TextEditingController();
  final password1control = TextEditingController();
  final repasswordcontrol = TextEditingController();
  bool isvisible = true;
  bool isvisibler = true;

  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  void checking() {
    final isValid = _formKey.currentState?.validate();
    if (isValid!) {
      final db = DatabaseHelper();
      db.signup(Users(username:username1control.text,password:password1control.text)).whenComplete((){
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.brown,
          centerTitle: true,
          title: const Text(
            'Start Chat',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 25.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('image/new.png',fit: BoxFit.cover,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: namecontrol,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'First name is required';
                        } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Invalid characters in names';
                        }
                        return null;
                      },
                      obscureText: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.face),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'First Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: lastnamecontrol,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Last name is required';
                        } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Invalid characters in names';
                        }
                        return null;
                      },
                      obscureText: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.face),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Last Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: username1control,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'User name is required';
                        } else if (value.length < 6) {
                          return 'Enter more than five characters';
                        }
                        return null;
                      },
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
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: password1control,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 7) {
                          return 'Password must contains atleast 7 characters';
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
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: repasswordcontrol,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Re-Enter the password';
                        } else if (repasswordcontrol.text !=
                            password1control.text) {
                          return "Password does't match";
                        }
                        return null;
                      },
                      obscureText: isvisibler,
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
                        hintText: 'Re-Enter password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isvisibler = !isvisibler;
                            });
                          },
                          icon: Icon(isvisibler
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
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
                      //Navigator.of(context).pop();
                      child: const Text(
                        'Save and Create Account',
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
      ),
    );
  }
}

/*  
  _formKey.currentState?.save();

*/
