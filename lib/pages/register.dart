import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../main.dart';

final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _userNameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _rePasswordController = TextEditingController();

class RegisterName extends StatefulWidget {
  const RegisterName({super.key});

  @override
  State<RegisterName> createState() => _RegisterNameState();
}

class _RegisterNameState extends State<RegisterName> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                child: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios, color: Color(0xffACACAC),),
                  onTap: () {
                    Navigator.pop(context);
                    _nameController.clear();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                width: width * 0.4,
                child: Image.asset('assets/image/melodymoverbrandinglogo.png'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 210,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Let\'s get started!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Enter Your Name', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                hintText: 'First Last',
                                filled: true,
                                fillColor: Color(0xffF0F0F0)
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "* Required"),
                              PatternValidator(r'^[a-zA-Z\s]+$', errorText: 'Name must not have any special characters or \nnumbers')
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 50,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xff0496FF),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterEmail()));
                    }
                  },
                  child: const Text("Enter", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterEmail extends StatefulWidget {
  const RegisterEmail({super.key});

  @override
  State<RegisterEmail> createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                child: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios, color: Color(0xffACACAC)),
                  onTap: () {
                    Navigator.pop(context);
                    _emailController.clear();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                width: width * 0.4,
                child: Image.asset('assets/image/melodymoverbrandinglogo.png'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 195,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Let\'s get started!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Enter Your Email', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: const InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                hintText: 'Enter Email',
                                filled: true,
                                fillColor: Color(0xffF0F0F0)
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "* Required"),
                              EmailValidator(errorText: "Enter valid email id"),
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 50,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xff0496FF),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterUserName()));
                    }
                  },
                  child: const Text("Enter", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterUserName extends StatefulWidget {
  const RegisterUserName({super.key});

  @override
  State<RegisterUserName> createState() => _RegisterUserNameState();
}

class _RegisterUserNameState extends State<RegisterUserName> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                child: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios, color: Color(0xffACACAC),),
                  onTap: () {
                    Navigator.pop(context);
                    _userNameController.clear();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                width: width * 0.4,
                child: Image.asset('assets/image/melodymoverbrandinglogo.png'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 195,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Let\'s get started!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Enter a Username', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            controller: _userNameController,
                            decoration: const InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                hintText: 'Enter a Username',
                                filled: true,
                                fillColor: Color(0xffF0F0F0)
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "* Required"),
                              PatternValidator(r'^[a-zA-Z0-9]+$', errorText: 'Username must not have any special characters')
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 50,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xff0496FF),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPassword()));
                  },
                  child: const Text("Enter", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPassword extends StatefulWidget {
  const RegisterPassword({super.key});

  @override
  State<RegisterPassword> createState() => _RegisterPasswordState();
}

class _RegisterPasswordState extends State<RegisterPassword> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                child: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios, color: Color(0xffACACAC),),
                  onTap: () {
                    Navigator.pop(context);
                    _passwordController.clear();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                width: width * 0.4,
                child: Image.asset('assets/image/melodymoverbrandinglogo.png'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 245,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Let\'s get started!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Enter a Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                hintText: 'Enter a Password',
                                filled: true,
                                fillColor: Color(0xffF0F0F0)
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "* Required"),
                              MinLengthValidator(8, errorText: "Password should be at least 8 characters"),
                              PatternValidator(r'(?=.*?[#?!@$%^&*-])(?=.*?[0-9])', errorText: 'Password must include a special character(s), \nand a number(s)')
                            ]),
                          ),
                        ),
                        const SizedBox(
                          child: Text('Password must be at least 8 characters long, include a special character, and a number.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff868686)))
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 50,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xff0496FF),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterLast()));
                  },
                  child: const Text("Enter", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RegisterLast extends StatefulWidget {
  const RegisterLast({super.key});

  @override
  State<RegisterLast> createState() => _RegisterLastState();
}

class _RegisterLastState extends State<RegisterLast> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void signup() async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text)
          .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registered Successfully")),
      ).closed.whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterSuccess())))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                child: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios, color: Color(0xffACACAC),),
                  onTap: () {
                    Navigator.pop(context);
                    _rePasswordController.clear();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                width: width * 0.4,
                child: Image.asset('assets/image/melodymoverbrandinglogo.png'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 195,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Let\'s get started!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Re-enter a Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            obscureText: true,
                            controller: _rePasswordController,
                            decoration: const InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                hintText: 'Re-enter Password',
                                filled: true,
                                fillColor: Color(0xffF0F0F0)
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 50,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xff0496FF),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  onPressed: () {
                    try {
                      signup();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error caused during registration")));
                    }
                  },
                  child: const Text("Finish", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterSuccess extends StatefulWidget {
  const RegisterSuccess({super.key});

  @override
  State<RegisterSuccess> createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff0496FF),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                width: width * 0.4,
                child: Image.asset('assets/image/melodymoverbrandinglogowhite.png'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 135,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: const Text('You’re officially a Melody Mover!', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white))
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: const Text('We’re so excited to get moving with you!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white))
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 50,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyApp()));
                  },
                  child: const Text("Get Started", style: TextStyle(color: Color(0xff0496FF), fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}