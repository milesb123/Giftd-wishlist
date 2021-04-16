import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart' as widgetPackage;
import 'package:responsive_web/widgets/pages/account_page/account_page.dart';
import 'package:responsive_web/widgets/pages/home_page.dart';
import 'package:responsive_web/widgets/pages/service_pages/email_verification_sent.dart';
import 'package:responsive_web/widgets/pages/service_pages/password_reset_page.dart';
import 'package:responsive_web/widgets/pages/signin_page/signin_page.dart';
import 'package:responsive_web/widgets/pages/signup_page/signup_page.dart';
import 'package:responsive_web/widgets/pages/wishlist_page/wishlist_controller.dart';
import 'package:responsive_web/widgets/pages/wishlist_page/wishlist_main.dart';


class RouteManager{
  static FluroRouter router = FluroRouter();

  static Handler _homeHandler = 
  Handler(handlerFunc: (widgetPackage.BuildContext context, Map<String, dynamic> params,){
      String username;

      if(params.containsKey('username')){
        //REFACTOR: to safely check for username param
        username = params['username'][0];
      }

      if(username == null){
        return HomePage();
      }
      else{
        return WishlistPage.createPage(username);
      }
  });

  static Handler _signinHandler = Handler(handlerFunc: (widgetPackage.BuildContext context, Map<String, dynamic> params,){
     return SigninPage();
  });

  static Handler _signupHandler = Handler(handlerFunc: (widgetPackage.BuildContext context, Map<String, dynamic> params,){
     return SignupPage();
  });

  static Handler _passwordResetHandler = Handler(handlerFunc: (widgetPackage.BuildContext context, Map<String, dynamic> params,){
     return PasswordResetPage();
  });

  static Handler _emailVerificationHandler = Handler(handlerFunc: (widgetPackage.BuildContext context, Map<String, dynamic> params,){
     return EmailVerificationPage();
  });

  static Handler _accountHandler = Handler(handlerFunc: (widgetPackage.BuildContext context, Map<String, dynamic> params,){
     return AccountPage();
  });
  
  static void setupRouter() {
    router.define("/", handler: _homeHandler,transitionType: TransitionType.none);
    router.define("/signin", handler: _signinHandler,transitionType: TransitionType.none);
    router.define("/signup", handler: _signupHandler,transitionType: TransitionType.none);
    router.define("/password_reset", handler: _passwordResetHandler,transitionType: TransitionType.none);
    router.define("/email_verification", handler: _emailVerificationHandler,transitionType: TransitionType.none);
    router.define("/account", handler: _accountHandler,transitionType: TransitionType.none);
    router.define("/:username", handler: _homeHandler,transitionType: TransitionType.none);
  }
}

