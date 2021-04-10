import 'package:responsive_web/services/authentication_services.dart';
import 'package:responsive_web/services/profile_services.dart';
import 'package:responsive_web/services/service_manager.dart';
import 'package:responsive_web/services/wishlist_services.dart';

class SignupController{

  var profileService = locator<ProfileService>();
  var wishlistService = locator<WishlistService>();
  var authService = locator<AuthenticationService>();

  String email = "";
  String nickname = "";
  String username = "";
  String password = "";
  bool termsAgreed = false;

  String errorMessage = "";

  String asyncEmailError = "";
  bool isInavlidAsyncPass = false;
  bool usernameTaken = false;

  bool loading = false;

  //Returns a string detailing the status of the signup
  Future<String> signUp(String email, String nickname, String username,String password){

    return profileService.getProfileForUsername(username)
    .then((value) async {
      if(value != null){
        return 'username-taken';
      }
      else{
        return await authService.signUp(email, password)
        .then((credential) async {
          try {
            //Create Profile
            String profileID = await profileService.createNewProfile(credential.user.uid, username, nickname);
            List<Map> items = [];
                    
            try{
              //Create Wishlist
              await wishlistService.createNewWishlist(profileID, items, {});
              return "success";
            }
            catch(e){
              //Couldn't create wishlist
              return 'wishlist-creation-error';
            }

          }
          catch (e) {
            //Couldn't create profile
            return 'profile-creation-error';
          }
        })
        .catchError((e){
          switch(e.code){
            case 'invalid-email':
              return 'invalid-email';
            case 'email-already-in-use':
              return 'email-already-in-use';
            case 'operation-not-allowed':
              return 'operation-not-allowed';
            case 'weak-password':
              return 'weak-password';
            default:
              return 'auth-unsuccessful';
          }
        });
      }
    })
    .catchError((e){
      return e.toString();
    });
  }

}