import 'package:flutter/material.dart';

class Wishlist{
  String listID;
  String ownerID;
  var items = <WishlistItem>[];
  var theme;

  Wishlist(String owner, List<WishlistItem> items,WishlistTheme theme)  {
    this.ownerID = owner;
    this.items = items;
    this.theme = theme;
  }
}

class WishlistItem{
  String message;
  List<Link> links;
  List<String> media;

  WishlistItem({String message,List<Link> links, List<String> media}){
    this.message = message;
    this.links = links;
    this.media = media;
  }
}

class Link{
  String tag;
  String url;
  Link({String tag, String url}){
    this.tag = tag;
    this.url = url;
  }
}

class WishlistTheme{
  String type;
  Color accentColor;
  Widget background;
  Widget navBackground;

  //default
  WishlistTheme(){
    type = "solid";
    accentColor = Colors.black;
    background = SizedBox.expand(child:Container(color:Colors.white));
  }

  //Solid Color init
  WishlistTheme solidInit(Color accentColor, Color backgroundColor){
    type = "solid";
    this.accentColor = accentColor;
    this.background = SizedBox.expand(child:Container(color:backgroundColor));
    return this;
  }

  //Linear Gradient init
  WishlistTheme linearGradientInit(Color accentColor, List<Color>gradientColors, Color navColor){
    type = "lGradient"; 
    this.accentColor = accentColor;
    this.background = 
    SizedBox.expand(
      child:
      Container(
        decoration: 
        BoxDecoration(
          gradient:
          LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,colors: gradientColors)
        ),
      )
    );
    this.navBackground = SizedBox.expand(child:Container(color:navColor));
    return this;
  }

  //External Image init
  WishlistTheme urlImageInit(Color accentColor, String imageURL, Color navColor){
    type = "urlImage";
    this.accentColor = accentColor;
    this.background = 
    SizedBox.expand(
      child: 
      Container(
        decoration: BoxDecoration(
          image:
          DecorationImage(
            image: NetworkImage(imageURL),
            fit:BoxFit.cover
          ),
        ),
      ),
    );

    this.navBackground = navColor == null ? this.background : SizedBox.expand(child:Container(color:navColor));
    return this;
  }
  
  Widget getNavbarBackground(){
    return navBackground == null ? background : navBackground;
  }
}