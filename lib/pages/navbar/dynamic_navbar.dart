
import 'package:flutter/material.dart';
import 'package:responsive_web/Models/wishlist.dart';
import 'package:responsive_web/pages/wishlist_page/wishlist_controller.dart';

class DynamicAppBar{

  WishlistTheme theme;

  DynamicAppBar(WishlistTheme theme){
    this.theme = theme;
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

  Widget desktopNavBar(){
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
            Image.asset("assets/images/logo_capsule.png",height:50),
            Text("")
          ]
        ),
      ),
    );
  }
}