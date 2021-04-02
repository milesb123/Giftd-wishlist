import 'package:flutter/widgets.dart';
import 'package:responsive_web/services/authentication_services.dart';
import 'package:responsive_web/services/profile_services.dart';
import 'package:responsive_web/services/service_manager.dart';

class SigninController{

  var profileService = locator<ProfileService>();
  var authService = locator<AuthenticationService>();

  String email;
  String password;

  String errorMessage = ""; //"This username or password is invalid";
  bool loading = false;

  SigninController(){
    print("Created");
  }
  
  void signIn(String email,String password,Function(void Function() f) setState,dynamic context,GlobalKey<FormState> formKey){
    
    authService.signIn(email,password,(String s){
      setState(() {
        errorMessage = s;
        loading = false;
      });
    })
    .then((uid){
      if(uid!=null){
        profileService.getProfileForUID(uid)
        .then((value){
          //Auth User exists
          if(value != null){
            //Profile exists for AuthID
            Navigator.pushNamed(context, '/${value.username}');
          }
          else{
            //No Profile for AuthID
            setState(() {
              loading = false;
            });
          }
        });
        
      }
      else{
        //No user
        setState(() {
            loading = false;
        });
      }
    });

  }

}