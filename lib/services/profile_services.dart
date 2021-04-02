import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_web/models/profile.dart';

class ProfileService{

  CollectionReference profiles = FirebaseFirestore.instance.collection('Profiles');


  Future<Profile> getProfileForUsername(String username,Function(dynamic) error) {
    // Call the user's CollectionReference to add a new user
    return profiles
      .where('username',isEqualTo: username)
      .limit(1)
      .get()
      .then((snapshot){
        if(snapshot.docs[0] != null){
          QueryDocumentSnapshot doc = snapshot.docs[0];
          //Create profile from data
          String userID = doc.id;
          String authID = doc.data()['auth_id'];
          String imageURL = doc.data()['imageURL'];
          String nickname = doc.data()['nickname'];
          String bio = doc.data()['bio'];

          if(userID == null || authID == null){
            //Return error if fields missing
            error("Missing Required Fields");
            return null;
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
            
            //getWishlistForOwnerID(doc.id,update);
            return profile;
          }
        }
        else{
          error("Profile Fetch Error");
          return null;
        }
      })
      .catchError((error) {
        error(error);
        return null;
      });
  }

  Future<Profile> getProfileForUID(String uid) {
      // Call the user's CollectionReference to add a new user
      return profiles
          .where('auth_id',isEqualTo: uid)
          .limit(1)
          .get()
          .then((snapshot){
            if(snapshot.docs[0] != null){
              QueryDocumentSnapshot doc = snapshot.docs[0];
              //Create profile from data
              String userID = doc.id;
              String imageURL = doc.data()['imageURL'];
              String nickname = doc.data()['nickname'];
              String username = doc.data()['username'];
              String bio = doc.data()['bio'];

              if(userID == null || username == null){
                //Return error if fields missing
                return null;
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
              return null;
            }
          })
          .catchError((error) {
            return null;
          });
  }  

}