import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart' as widgetPackage;
import 'package:responsive_web/pages/home_view.dart';
import 'package:responsive_web/pages/wishlist_main.dart';

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
        return HomeView();
      }
      else{
        return WishlistPage(username);
      }

    });
  
  static void setupRouter() {
    router.define("/", handler: _homeHandler,transitionType: TransitionType.none);
    router.define("/:username", handler: _homeHandler,transitionType: TransitionType.none);
  }
}