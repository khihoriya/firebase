import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class facebook extends StatefulWidget {
  const facebook({Key? key}) : super(key: key);

  @override
  State<facebook> createState() => _facebookState();
}

class _facebookState extends State<facebook> {

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Center(
          child: ElevatedButton(onPressed: () {

            signInWithFacebook();


          }, child: Text("Facebook")),
        )
      ]),
    );
  }
}
