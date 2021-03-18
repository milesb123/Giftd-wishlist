import 'dart:js';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//USE CASE
// Wishlist and User objects will be flowed from the top down, by reference
class Profile{
  String userID;
  String imageURL;
  String nickname;
  String username;
  String bio;

  Profile(this.userID,this.imageURL,this.nickname,this.username,this.bio);
}

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
  List<Map> links;
  List<String> media;

  WishlistItem(String message,List<Map> links, List<String> media){
    this.message = message;
    this.links = links;
    this.media = media;
  }
}

class WishlistTheme{
  Color accentColor;
  Widget background;
  Widget navBackground;

  //default
  WishlistTheme(){
    accentColor = Colors.black;
    background = SizedBox.expand(child:Container(color:Colors.white));
  }

  //Solid Color init
  WishlistTheme solidInit(Color accentColor, Color backgroundColor){
    this.accentColor = accentColor;
    this.background = SizedBox.expand(child:Container(color:backgroundColor));
    return this;
  }

  //Linear Gradient init
  WishlistTheme linearGradientInit(Color accentColor, List<Color>gradientColors, Color navColor){
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

class WishlistViewContoller{
  GlobalKey<ScaffoldState> mobileDrawerKey = GlobalKey();
}

class MockContainer extends StatelessWidget {
  
  final Wishlist wishlist = 
  new Wishlist(
    "owner",
    [new WishlistItem("You + a north face jacket would make my whole year💕", [], ["https://images.stockx.com/images/Supreme-The-North-Face-Expedition-Jacket-Black.jpg?fit=fill&bg=FFFFFF&w=700&h=500&auto=format,compress&q=90&dpr=2&trim=color&updated_at=1606320522","https://i.gifer.com/WiZX.gif"]),],
    WishlistTheme().solidInit(Colors.white, Colors.black),//.urlImageInit(Colors.black, "https://cdn.shopify.com/s/files/1/2656/8500/products/diamond-glitter-blue-sky-wallpaper-902004_1024x.jpg?v=1554116152",
    );
  
  final Profile currentProfile = new Profile("","https://i.pinimg.com/originals/ca/61/ba/ca61ba3b09fa484064e221f05d918a39.jpg","Miles Morales","29milesb","If you want to nice me, you can 😁");
  final controller = new WishlistViewContoller();

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: getScaffold(context)
    );
  }

  Widget getScaffold(BuildContext context){
    return
    LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth > 600){
        return
        Scaffold(
          backgroundColor: Colors.white,
          body: desktopStructure()
        );
      }
      else{
        return
        Scaffold(
          key: controller.mobileDrawerKey,
          backgroundColor: Colors.white,
          body: mobileStructure(),
          drawer:
          Container(
            width:200,
            child: 
            Drawer(
              elevation: 5,
              child: SizedBox.expand(child:Container(color:Colors.white))
            ),
          ),
          drawerScrimColor: Colors.black45.withOpacity(0.1)
        );
      }
    });
  }

  Widget desktopStructure(){
    return
    Stack(
      children: [
      SizedBox.expand(
        child: 
        Container(
          //background
          color: Color.fromRGBO(1, 1, 1, 0.05),
          child:
          Center(child:
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width:600),
              child:
              Stack(
                children:[
                  wishlist.theme.background,
                  Container(
                    child: 
                    ListView(
                      children:[
                        Padding(
                            //Top padding navbar height
                            padding: EdgeInsets.fromLTRB(0, 130, 0, 0),
                            child: WishlistContent(currentProfile,wishlist),
                        ),
                      ]
                    )
                  )
                ]
              )
            )
          )
        )
      ),
      DynamicAppBar(wishlist.theme).desktopNavBar(),
    ]);
  }

  Widget mobileStructure(){
    return
    Column(
      children: [
        DynamicAppBar(wishlist.theme).mobileNavBar(controller),
        Container(height:1,color: wishlist.theme.accentColor),
        Expanded(
          child: 
          Stack(
            children:[
              wishlist.theme.background,
              Container( 
                child:
                ListView(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: WishlistContent(currentProfile,wishlist),
                  )
                  ]
                ),
              )
            ]
          )
        )
      ]
    );
  }

}

//Wishlist Content is NOT responsible for background
class WishlistContent extends StatelessWidget{

  final Profile profile;
  final Wishlist wishlist;

  WishlistContent(this.profile,this.wishlist);

  Widget build(BuildContext context) {
    return
    SizedBox(
      width:double.infinity,
      child:
      Container(
        child:
        Column(
          children: [
            listHeader(),
            SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Align(alignment: Alignment.centerLeft,child:Text("Wishlist: ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),
            ),
            SizedBox(height:20),
            listItemView(wishlist.items[0],0),
            SizedBox(height:15),
          ],
        )
      )
    );
  }

  Widget listItemView(WishlistItem item, int index){
    
    List<Widget> children = [];

    children.addAll([
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child:
            Text("${(index+1).toString()}. ${item.message}",style:TextStyle(fontSize: 18,color: wishlist.theme.accentColor))
          ),
        ),
        SizedBox(height:15)
    ]);

    if(item.media.isNotEmpty){
      children.addAll([
        Container(
          height:160,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            itemCount: item.media.length,
            itemBuilder:(context,media){
              return
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Container(
                  width:240,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image:
                    DecorationImage(
                      image:NetworkImage(item.media[media]),
                      fit:BoxFit.cover
                    ),
                  ),
                ),
              );
            }
          ),
        ),
        SizedBox(height:15),
      ]);
    }

    if(item.links.isNotEmpty){

    }

    children.addAll([
      SizedBox(height:10),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Container(height:1, color:wishlist.theme.accentColor.withOpacity(0.25), width:double.infinity),
      )
    ]);

    return
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:  children
    );
  }

  Widget listHeader(){
    return
    Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image:
              DecorationImage(
                image: NetworkImage(profile.imageURL),
                fit:BoxFit.cover
              ),
            ), 
          ),
          SizedBox(height:10),
          Text(profile.nickname,style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:wishlist.theme.accentColor)),
          SizedBox(height:5),
          Text(profile.bio,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color:wishlist.theme.accentColor)),
          SizedBox(height:16),
          OutlinedButton(
            onPressed: ()=>{},
            child: 
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Text("Copy Link 🌍",style: TextStyle(fontSize:14))
            ),
            style: HelperStyles.defaultButtonStyle(true,wishlist.theme.accentColor),
          )
        ]
      ),
    );
  }
}

class HelperStyles{
  static ButtonStyle defaultButtonStyle([bool outlined,Color color]){
    color ??=Colors.white;
    if(outlined){
      return
      ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          Color _textColor;

          if (states.contains(MaterialState.disabled)) {
            _textColor = Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            _textColor = color.withOpacity(0.5);
          } else {
            _textColor = color;
          }
          return _textColor;
        }),
        side: MaterialStateProperty.resolveWith((states) {
          Color _borderColor;

          if (states.contains(MaterialState.disabled)) {
            _borderColor = Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            _borderColor = color.withOpacity(0.5);
          } else {
            _borderColor = color;
          }
          return BorderSide(color: _borderColor, width: 1);
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(40));
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          Color _overlayColor;

          if (states.contains(MaterialState.disabled)) {
            _overlayColor = Colors.transparent;
          } else if (states.contains(MaterialState.pressed)) {
            _overlayColor = color.withOpacity(0.05);
          } else {
            _overlayColor = Colors.transparent;
          }
          return Colors.transparent;
        }),
      );
    }
    else{
      return
      ButtonStyle(
        animationDuration: Duration(milliseconds: 100),
        textStyle:
          MaterialStateProperty.resolveWith<TextStyle>((states) => 
            TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontFamily: "assets/fonts/helvetica_nimbus",
            )
          ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          Color _textColor;

          if (states.contains(MaterialState.disabled)) {
            _textColor = Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            _textColor = color.withOpacity(0.1);
          } else {
            _textColor = color;
          }
          return _textColor;
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(40));
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          return Colors.transparent;
        }),
      );
    }
  }
}

class DynamicAppBar{

  WishlistTheme theme;

  DynamicAppBar(WishlistTheme theme){
    this.theme = theme;
  }

  Widget mobileNavBar(WishlistViewContoller controller){
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