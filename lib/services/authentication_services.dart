import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:responsive_web/models/profile.dart';

class AuthenticationService{
  FirebaseAuth auth = FirebaseAuth.instance;

  bool signedIn;
  
  AuthenticationService(){
    FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    listen();
  }

  void listen(){
    auth
    .authStateChanges()
    .listen((User user) {
      if (user == null) {
        //signedIn = false;
      }
      else {
       // signedIn = true;
      }
    });
  }

  bool userIsLocalUser(String uid){
    return userSignedIn() && uid != null && auth.currentUser.uid == uid;
  }

  bool userSignedIn(){
    return auth.currentUser != null;
  }

  Future<String> signIn(String email,String password, Function(String) displayMessage) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      
      if(userCredential.user.emailVerified){
        return userCredential.user.uid;
      }
      else{
        //TODO: Navigate to email verification page
        //displayMessage('Please verify your email to sign in');
        return userCredential.user.uid;
      }

    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        displayMessage('No user exists for this email');
      }
      else{
        displayMessage('The username or password is invalid');
      }
    }
    return null;
  }
}