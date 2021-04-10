import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_web/models/profile.dart';

class ProfileService{

  CollectionReference profiles = FirebaseFirestore.instance.collection('Profiles');


  Future<Profile> getProfileForUsername(String username) {
    // Call the user's CollectionReference to add a new user
    return profiles
      .where('username',isEqualTo: username)
      .limit(1)
      .get()
      .then((snapshot){
        if(snapshot.docs.length > 0 && snapshot.docs[0] != null){
          QueryDocumentSnapshot doc = snapshot.docs[0];
          //Create profile from data
          String userID = doc.id;
          String authID = doc.data()['auth_id'];
          String imageURL = doc.data()['imageURL'];
          String nickname = doc.data()['nickname'];
          String bio = doc.data()['bio'];

          if(userID == null || authID == null){
            //Return error if fields missing
            throw('missing-required-fields');
          }
          else{
            //Build Profile
            var profile = new Profile(
              authID,
              userID,
              imageURL == null ? "http://assets.stickpng.com/images/585e4bf3cb11b227491c339a.png" : imageURL.toString(),
              nickname == null ? username : nickname.toString(),
              username,
              bio == null ? "" : bio.toString()
            );
            
            return profile;
          }
        }
        else{
          //No Profile for this username
          return null;
        }
      })
      .catchError((error) {
        throw(error);
      });
  }

  Future<Profile> getProfileForUID(String uid) {
      // Call the user's CollectionReference to add a new user
    return profiles
      .where('auth_id',isEqualTo: uid)
      .limit(1)
      .get()
      .then((snapshot){
        if(snapshot.docs.length > 0 && snapshot.docs[0] != null){
          QueryDocumentSnapshot doc = snapshot.docs[0];
          //Create profile from data
          String userID = doc.id;
          String imageURL = doc.data()['imageURL'];
          String nickname = doc.data()['nickname'];
          String username = doc.data()['username'];
          String bio = doc.data()['bio'];

          if(userID == null || username == null){
            //Return error if fields missing
            throw('missing-required-fields');
          }
          else{
            //Build Profile
            var profile = new Profile(
              uid,
              userID,
              imageURL == null ? "http://assets.stickpng.com/images/585e4bf3cb11b227491c339a.png" : imageURL.toString(),
              nickname == null ? username : nickname.toString(),
              username,
              bio == null ? "" : bio.toString()
            );
            return profile;
          }
        }
        else{
          //No Profile for this id
          return null;
        }
      })
      .catchError((error) {
        throw(error.code);
      });
  } 

  Future<String> createNewProfile(String uid,String username,String nickname) async {
    //Mandatory Fields: auth_id, username, email
    var profile = profiles.doc();
    try{
      await profile
      .set({
        'auth_id':uid,
        'username':username,
        'nickname':nickname,
      });
      return profile.id;
    }
    catch(e){
      return null;
    }
  }

}