import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:responsive_web/models/profile.dart';
import 'package:responsive_web/services/authentication_services.dart';
import 'package:responsive_web/services/profile_services.dart';
import 'package:responsive_web/services/service_manager.dart';

class SigninController{

  var profileService = locator<ProfileService>();
  var authService = locator<AuthenticationService>();

  String email;
  String password;

  String errorMessage = ""; 
  bool loading = false;

  Future<Profile> signIn(String email,String password){
    return authService.signIn(email,password)
    .then((credential) async {
      if(credential!=null){
        return await profileService.getProfileForUID(credential.user.uid)
        .then((value) async {
          //Auth User exists
          if(value != null){
            //Profile exists for AuthID
            return value;
          }
          else{
            //No Profile for AuthID
            throw('profile-fetch-error');
          }
        })
        .catchError((e){
          throw(e);
        });
      }
      else{
        //User credential null
        throw('null-credential');
      }
    })
    .catchError((e){
      throw(e.code);
    });
  }
}
  
//   void signIn(String email,String password,Function(void Function() f) setState,dynamic context){
    
//     authService.signIn(email,password,(String s){
//       setState(() {
//         errorMessage = s;
//         loading = false;
//       });
//     })
//     .then((uid){
//       if(uid!=null){
//         profileService.getProfileForUID(uid)
//         .then((value){
//           //Auth User exists
//           if(value != null){
//             //Profile exists for AuthID
//             Navigator.pushNamed(context, '/${value.username}');
//           }
//           else{
//             //No Profile for AuthID
//             setState(() {
//               loading = false;
//             });
//           }
//         });
        
//       }
//       else{
//         //No user
//         setState(() {
//             loading = false;
//         });
//       }
//     });

//   }

// }