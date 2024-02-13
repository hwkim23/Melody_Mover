import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../main.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void resetPassword() async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .sendPasswordResetEmail(email: _emailController.text)
          .whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AfterSendLink())));
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
                            child: const Text('Forgot Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: const Text('Enter the email associated with your account.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
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
                    try {
                      resetPassword();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error caused during sending the link")));
                    }
                  },
                  child: const Text("Send Reset Link", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AfterSendLink extends StatefulWidget {
  const AfterSendLink({super.key});

  @override
  State<AfterSendLink> createState() => _AfterSendLinkState();
}

class _AfterSendLinkState extends State<AfterSendLink> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Stack(
          children: [
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
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: const Text('Reset Link Sent!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: const Text('Check your email for instructions to reset your password. It should arrive soon.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
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
                      backgroundColor: const Color(0xff0496FF),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyApp()));
                  },
                  child: const Text("Back to Login", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

