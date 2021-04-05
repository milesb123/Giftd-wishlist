import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';


class AuthenticationService{
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User> authStream = FirebaseAuth.instance.authStateChanges();
  
  AuthenticationService(){
    FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  bool userIsLocalUser(String uid){
    return userSignedIn() && uid != null && auth.currentUser.uid == uid;
  }

  bool userSignedIn(){
    return auth.currentUser != null;
  }

  void signOut(){
    auth.signOut();
  }

  Future<UserCredential> signUp(String email, String password) async {
      return auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
  }

  Future<String> signIn(String email,String password, Function(String) displayMessage) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      
      if(userCredential.user.emailVerified){
        //Persist user credential uid        
        return userCredential.user.uid;
      }
      else{
        //TODO: Navigate to email verification page
        //displayMessage('Please verify your email to sign in');
        return userCredential.user.uid;
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        displayMessage('No user exists for this email');
      }
      else{
        displayMessage('The username or password is invalid');
      }
    }
    return null;
  }
}