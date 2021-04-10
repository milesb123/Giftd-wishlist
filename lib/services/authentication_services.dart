import 'package:firebase_auth/firebase_auth.dart';

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

      return 
      auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      )
      .then((value) async {
        await value.user.sendEmailVerification();
        return value;
      })
      .catchError((e){
        throw(e);
      });
  }

  Future<UserCredential> signIn(String email,String password) async {
      //Handle Email Verifications

      return auth.signInWithEmailAndPassword(
        email: email,
        password: password
      )
      .then((value) async {
        if(value.user.emailVerified){
          return value;
        }
        else{
          await value.user.sendEmailVerification();
          return value;
        }
      })
      .catchError((e){
        throw(e);
      });
  }

  Future<void> resetPassword(String email){
    return auth.sendPasswordResetEmail(email: email);
  }

}

