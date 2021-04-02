import 'dart:js';

import 'package:flutter/material.dart';
import 'package:responsive_web/helper/helper.dart';
import 'package:responsive_web/models/wishlist.dart';
import 'package:responsive_web/services/authentication_services.dart';
import 'package:responsive_web/services/profile_services.dart';
import 'package:responsive_web/services/service_manager.dart';
import 'package:responsive_web/widgets/pages/wishlist_page/wishlist_controller.dart';

class DynamicAppBar{
  var authService = locator<AuthenticationService>();

  static Widget mobileDrawerContent(){
    return
    Container(
      width:200,
      child: 
      Drawer(
        elevation: 2,
        child: 
        SizedBox.expand(child:Container(
          color:Colors.white,
          child:
          Align(
            alignment:Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:20),
                  Text("Sign In",style: TextStyle(fontSize:16,decoration: TextDecoration.underline)),
                  SizedBox(height:10),
                  Text("Sign Up 🎁",style: TextStyle(fontSize:16,decoration: TextDecoration.underline))
                ]
              )
            ),
          )
        ))
      ),
    );
  }

  Widget mobileNavBar(GlobalKey<ScaffoldState> mobileDrawerKey){
    return
    Container(
      color: Colors.black,
      width:double.infinity,
      height:60,
      child:
      Stack(
        children:[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                  TextButton(
                    child: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30.0,
                    semanticLabel: 'Menu',
                    ),
                    onPressed: ()=>{mobileDrawerKey.currentState.openDrawer()}
                  )
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                  Image.asset("assets/images/logo_capsule.png",height:30)
                )
              ]
            ),
          )
        ]
      )
    );
  }

  Widget desktopNavBar(BuildContext context){
    return
    Container(
      //height:80,
      width:double.infinity,
      decoration: 
      BoxDecoration(
        color: Colors.black,
      ),
      child:
      Padding(
        padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap:(){
                print("Tapped");
              },
              child:
              Image.asset("assets/images/logo_capsule.png",height:50)
            ),
            NavbarComponents().desktopNavButtonRow(authService.userSignedIn(),context)
          ]
        ),
      ),
    );
  }
}

class WishlistDynamicAppBar{

  var authService = locator<AuthenticationService>();

  WishlistTheme theme;

  WishlistDynamicAppBar(WishlistTheme theme){
    this.theme = theme;
  }

  static Widget mobileDrawerContent(){
    return
    Container(
      width:200,
      child: 
      Drawer(
        elevation: 2,
        child: 
        SizedBox.expand(child:Container(
          color:Colors.white,
          child:
          Align(
            alignment:Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:20),
                  Text("Sign In",style: TextStyle(fontSize:16,decoration: TextDecoration.underline)),
                  SizedBox(height:10),
                  Text("Sign Up 🎁",style: TextStyle(fontSize:16,decoration: TextDecoration.underline))
                ]
              )
            ),
          )
        ))
      ),
    );
  }

  Widget mobileNavBar(WishlistPageContoller controller){
    return
    Container(
      width:double.infinity,
      height:60,
      child:
      Stack(
        children:[
          theme.getNavbarBackground(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                  TextButton(
                    child: Icon(
                    Icons.menu,
                    color: theme.accentColor,
                    size: 30.0,
                    semanticLabel: 'Menu',
                    ),
                    onPressed: ()=>{controller.mobileDrawerKey.currentState.openDrawer()}
                  )
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                  Image.asset("assets/images/logo_capsule.png",height:30)
                )
              ]
            ),
          )
        ]
      )
    );
  }

  Widget desktopNavBar(BuildContext context){
    return
    Container(
      //height:80,
      width:double.infinity,
      decoration: 
      BoxDecoration(
        color: Colors.black,
        boxShadow: [BoxShadow(blurRadius: 12,color:Color.fromRGBO(75, 75, 75, 0.75))]
      ),
      child:
      Padding(
        padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap:(){
                print("Tapped");
              },
              child:
              Image.asset("assets/images/logo_capsule.png",height:50)
            ),
            NavbarComponents().desktopNavButtonRow(authService.userSignedIn(),context)
          ]
        ),
      ),
    );
  }
}

class NavbarComponents{

  var profileService = locator<ProfileService>();

  Widget desktopNavButtonRow(bool signedIn,BuildContext context){
    if(signedIn){
      return
      Row(
        children:[
          OutlinedButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/bad_gy4l');
            },
            child: 
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width:5),
                  Text("Profile",style: TextStyle(fontSize:14)),
                ],
              )
            ),
            style: HelperStyles.defaultButtonStyle(true,Colors.white),
          ),
        ]
      );
    }
    else{
      return
      Row(
        children:[
          OutlinedButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/signin');
            },
            child: 
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Text("Sign In",style: TextStyle(fontSize:14))
            ),
            style: HelperStyles.defaultButtonStyle(true,Colors.white),
          ),
          SizedBox(width:20)
          ,
          OutlinedButton(
            onPressed: ()=>{},
            child: 
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Text("Sign Up",style: TextStyle(fontSize:14))
            ),
            style: HelperStyles.defaultButtonStyle(true,Colors.white),
          )
        ]
      );
    }
  }

}