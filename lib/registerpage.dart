import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'homepage.dart';

class register1 extends StatefulWidget {
  const register1({Key? key}) : super(key: key);

  @override
  State<register1> createState() => _register1State();
}

class _register1State extends State<register1> {
  String img = "";
  final ImagePicker picker = ImagePicker();
  bool image = false;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phno = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController number = TextEditingController();
  TextEditingController otp = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  String vrficid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8ebed),
      body: SingleChildScrollView(
        //we are adding this so that we can scroll when KeyBoard PopsUp.
        child: Container(
          height: MediaQuery.of(context).size.height,
          // If you get any blur that is outoff the screen then try to decrease or increase this negative value.This is mainly bcz it adjusts as per the phone size.
          alignment: Alignment.topCenter,
          child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    child: Column(
                      children: [
                        Stack(
                          //I added stack so that i can position it anywhere i want with the coordinates like left ,right,bottom.
                          children: <Widget>[
                            Positioned(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/talking.png",
                                ),
                              ),
                            ),
                          ],
                        ),

                        //The Username,Email,Password Input fields.
                        SizedBox(height: 20),
                        SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffe1e2e3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ]),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    final XFile? image =
                                                        await picker.pickImage(
                                                            source: ImageSource
                                                                .gallery);
                                                    setState(() {
                                                      img = image!.path;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Gallery")),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    final XFile? photo =
                                                        await picker.pickImage(
                                                            source: ImageSource
                                                                .camera);
                                                    setState(() {
                                                      img = photo!.path;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("camera")),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                        child: CircleAvatar(
                                            maxRadius: 60,
                                            backgroundImage:
                                                FileImage(File(img)))),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        final storageRef =
                                            FirebaseStorage.instance.ref();

                                        String imagename =
                                            "ImageImage${Random().nextInt(1000)}.jpg";
                                        final spaceRef = storageRef
                                            .child("KRIns/$imagename");
                                        await spaceRef.putFile(File(img));
                                        spaceRef
                                            .getDownloadURL()
                                            .then((value) async {
                                          print("====${value}");
                                          DatabaseReference ref =
                                              FirebaseDatabase.instance
                                                  .ref("realtimekrince")
                                                  .push();

                                          String id = "${ref.key}";

                                          await ref.set({
                                            "id": id,
                                            "image": img,
                                            "fname": firstname.text,
                                            "lname": lastname.text,
                                            "password": password.text
                                          }).then((value) {
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return homepage();
                                              },
                                            ));
                                          });
                                        });
                                      },
                                      child: Text("Add Image To Firebase")),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff5f8fd),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: TextFormField(
                                      controller: firstname,
                                      decoration: InputDecoration(
                                          hintText: "First name",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff5f8fd),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: TextFormField(
                                      controller: lastname,
                                      decoration: InputDecoration(
                                          hintText: "Last name",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff5f8fd),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: TextFormField(
                                      controller: password,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      try {
                                        final credential = await FirebaseAuth
                                            .instance
                                            .createUserWithEmailAndPassword(
                                          email: firstname.text,
                                          password: lastname.text,
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'weak-password') {
                                          print(
                                              'The password provided is too weak.');
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          print(
                                              'The account already exists for that email.');
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 50),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.orange[900]),
                                      child: Center(
                                        child: Text(
                                          "Sign up",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(height: 30),
                  // //Raised Buttons of sigup will appear.
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     InkWell(
                  //       onTap: () async {
                  //         try {
                  //           final credential = await FirebaseAuth.instance
                  //               .createUserWithEmailAndPassword(
                  //             email: firstname.text,
                  //             password: lastname.text,
                  //           );
                  //         } on FirebaseAuthException catch (e) {
                  //           if (e.code == 'weak-password') {
                  //             print('The password provided is too weak.');
                  //           } else if (e.code == 'email-already-in-use') {
                  //             print(
                  //                 'The account already exists for that email.');
                  //           }
                  //         } catch (e) {
                  //           print(e);
                  //         }
                  //       },
                  //       child: Container(
                  //         height: 50,
                  //         margin: EdgeInsets.symmetric(horizontal: 50),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(50),
                  //             color: Colors.orange[900]),
                  //         child: Center(
                  //           child: Text(
                  //             "Sign up",
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: 5),
                  //     InkWell(
                  //       //We can use the GestureDetector as well.
                  //       onTap: () {},
                  //       child: Container(
                  //           padding: EdgeInsets.symmetric(
                  //               horizontal: 10, vertical: 5),
                  //           decoration: BoxDecoration(
                  //               color: Color(0xfff5f8fd),
                  //               borderRadius:
                  //               BorderRadius.all(Radius.circular(20)),
                  //               boxShadow: [
                  //                 //For creating like a card.
                  //                 BoxShadow(
                  //                     color: Colors.black12,
                  //                     offset: Offset(0.0, 18.0),
                  //                     blurRadius: 15.0),
                  //                 BoxShadow(
                  //                     color: Colors.black12,
                  //                     offset: Offset(0.0, -04.0),
                  //                     blurRadius: 10.0),
                  //               ]),
                  //           child: Row(
                  //             children: [
                  //               Text(
                  //                 "Sign Up With",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     color: Colors.deepPurpleAccent,
                  //                     fontWeight: FontWeight.w700),
                  //               ),
                  //               Image.asset("assets/images/google.png",
                  //                 height: 40,
                  //               )
                  //             ],
                  //           )),
                  //     )
                  //   ],
                  // ),
                  // SizedBox(height: 25),
                  // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //   Text("Already have an account?"),
                  //   SizedBox(width: 10),
                  //   InkWell(
                  //     onTap: () {},
                  //     child: Container(
                  //       child: Text("Sign In",
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.w900,
                  //               color: Colors.deepPurpleAccent,
                  //               fontSize: 18)),
                  //     ),
                  //   )
                  // ]),
                  //
                  // TextField(
                  //   controller: number,
                  // ),
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       await FirebaseAuth.instance.verifyPhoneNumber(
                  //         phoneNumber: '${number.text}',
                  //         verificationCompleted:
                  //             (PhoneAuthCredential credential) {},
                  //         verificationFailed: (FirebaseAuthException e) {},
                  //         codeSent: (String verificationId, int? resendToken) {
                  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //               content: Text("Code Send to this number")));
                  //
                  //           setState(() {
                  //             vrficid = verificationId;
                  //           });
                  //         },
                  //         codeAutoRetrievalTimeout: (String verificationId) {},
                  //       );
                  //     },
                  //     child: Text("Send Phone Number")),
                  // TextField(
                  //   controller: otp,
                  // ),
                  //
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       String smsCode = '${otp.text}';
                  //
                  //       // Create a PhoneAuthCredential with the code
                  //       PhoneAuthCredential credential =
                  //       PhoneAuthProvider.credential(
                  //           verificationId: vrficid, smsCode: smsCode);
                  //
                  //       // Sign the user in (or link) with the credential
                  //       await auth
                  //           .signInWithCredential(credential)
                  //           .then((value) {
                  //         print("====${value}");
                  //       });
                  //     },
                  //     child: Text("otp submit")),
                ],
              )),
        ),
      ),
    );
  }
}
