import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:melody_mover/pages/forgotpassword.dart';
import 'package:melody_mover/pages/mainpage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void logIn() async {
    if (_formkey.currentState!.validate()) {
      await _auth
        .signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text)
          .whenComplete(() =>  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage())));
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
                height: 299,
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
                          child: const Text('Log In', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
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
                              hintText: 'Email',
                              filled: true,
                              fillColor: Color(0xffF0F0F0)
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "* Required"),
                              EmailValidator(errorText: "Enter valid email id"),
                            ]),
                          ),
                        ),
                        TextFormField(
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
                            hintText: 'Password',
                            filled: true,
                            fillColor: Color(0xffF0F0F0)
                          ),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required")
                          ]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(color: Colors.grey, fontSize: 15, decoration: TextDecoration.underline),
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
                      logIn();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged In Successfully")));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error caused during login")));
                    }
                  },
                  child: const Text("Log In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
