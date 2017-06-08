import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;



  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null)
      user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
    }
    if (auth.currentUser == null) {  //new
      GoogleSignInAuthentication credentials =
      await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }

  }

  checkLogin() async{
    await  _ensureLoggedIn();
  }

  logout() async{
    await googleSignIn.signOut();
  }

  GoogleSignIn getUser(){
    return googleSignIn;
  }






