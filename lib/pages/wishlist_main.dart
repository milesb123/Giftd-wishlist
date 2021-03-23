import 'dart:collection';
import 'dart:js';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_web/Models/profile.dart';
import 'package:responsive_web/Models/wishlist.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//USE CASE
// Wishlist and User objects will be flowed from the top down, by reference

//TODO:
// - Break up structure a lil bit
// - Routing
// - Test view with varying inputs and sizing


//BUGS:
// - text must find new line

class WishlistViewContoller{
  
  /*
  Wishlist wishlist = 
  new Wishlist(
      "owner",
      [
        new WishlistItem(message: "You + a north face jacket would make my whole year💕", links:[Link(tag: "Asos",url:"https://www.asos.com/"),Link(tag:"Depop",url:"https://www.depop.com/")], media: ["https://images.stockx.com/images/Supreme-The-North-Face-Expedition-Jacket-Black.jpg?fit=fill&bg=FFFFFF&w=700&h=500&auto=format,compress&q=90&dpr=2&trim=color&updated_at=1606320522","https://i.gifer.com/WiZX.gif"]),
        new WishlistItem(message:"Rims for my car",links:[],media: []),
        new WishlistItem(message:"A car?",links:[],media: []),
      ],
      WishlistTheme().solidInit(Colors.white, Colors.black),//.urlImageInit(Colors.black, "https://cdn.shopify.com/s/files/1/2656/8500/products/diamond-glitter-blue-sky-wallpaper-902004_1024x.jpg?v=1554116152",
    );
  

  Profile currentProfile = new Profile("","https://i.pinimg.com/originals/ca/61/ba/ca61ba3b09fa484064e221f05d918a39.jpg","Miles Morales","29milesb","If you want to nice me, you can 😁");
  */

  
  //Cached Wishlist
  Wishlist wishlist;

  //Cached Profile
  Profile currentProfile;

  CollectionReference profiles = FirebaseFirestore.instance.collection('Profiles');
  CollectionReference public_lists = FirebaseFirestore.instance.collection('Public_Lists');


  GlobalKey<ScaffoldState> mobileDrawerKey = GlobalKey();
  Widget content = SpinKitDualRing(color: Colors.white);

  Future<void> getProfile(String username,Function(dynamic) update) {
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
              String imageURL = doc.data()['imageURL'];
              String nickname = doc.data()['nickname'];
              String username = doc.data()['username'];
              String bio = doc.data()['bio'];

              if(userID == null || username == null){
                //Return error if fields missing
                update("Missing Required Fields");
                return;
              }
              else{
                //Build Profile
                currentProfile = new Profile(
                  userID,
                  imageURL == null ? "http://assets.stickpng.com/images/585e4bf3cb11b227491c339a.png" : imageURL.toString(),
                  nickname == null ? username : nickname.toString(),
                  username,
                  bio == null ? "" : bio.toString()
                );
                getList(doc.id,update);
              }
            }
            else{
              update("Profile Fetch Error");
            }
          })
          .catchError((error) {
            update(error);
          });
  }

  Future<void> getList(String userID,Function(dynamic) update) {
      // Call the user's CollectionReference to add a new user
      return public_lists
          .where('ownerID',isEqualTo: userID)
          .limit(1)
          .get()
          .then((snapshot){
            if(snapshot.docs[0] != null){
              QueryDocumentSnapshot doc = snapshot.docs[0];
              //Build wishlist
              
              String ownerID = doc.data()['ownerID'];
              var items = <WishlistItem>[];
              List rawItems = doc.data()['items'];
              
              //Prepare Items
              if(rawItems != null){
                
                for(int i=0; i<rawItems.length; i++){
                  Map item = rawItems[i];
                  
                  //Prepare Message
                  String message = item['message'];
                  
                  //Prepare Links
                  List<Link> links = [];
                  List rawLinks = item['links'];

                  if(rawLinks != null){
                    for(int j=0; j<rawLinks.length;j++){
                      Map link = rawLinks[j];
                      String tag = link['tag'];
                      String url = link['url'];
                      
                      if(url != null){
                        links.add(Link(tag: tag == null ? url : tag,url:url));
                      }
                    }
                  }
                  
                  //Prepare Media
                  List<String> media = [];
                  List rawMedia = item['media'];
                  
                  if(rawMedia != null){
                    for(int j=0; j<rawMedia.length; j++){
                      String contentLink = rawMedia[j];
                      if(contentLink != null){
                        media.add(contentLink);
                      }
                    }
                  }
                  
                  if(!(message == null && links == null && media == null)){
                    //Valid Item
                    items.add(new WishlistItem(message: message,links:links,media:media));
                  }

                }

                //Prepare Theme
                WishlistTheme theme = buildTheme(doc.data()['theme']);

                if(items.isEmpty){
                  print(items);
                  update("Empty List");
                }

                if(ownerID == null){
                  update("Required fields missing");
                }

                //Publish Wishlist
                wishlist = new Wishlist(ownerID.toString(),items,theme == null ? WishlistTheme().solidInit(Colors.white, Colors.pink) : theme);

                update(null);
              }
              else{
                update("Items field missing");
              }
            }
            else{
              update("List Fetch Error");
            }
          })
          .catchError((error){
            update(error);
          });
  }

  WishlistTheme buildTheme(Map rawTheme){
    String type = rawTheme['type'];
    
    if(type == null){
      return null;
    }

    switch(type){
      case "solid":{
        print("Solid detected");
        Map rawAccent = rawTheme['accentColor'];
        Map rawColor = rawTheme['backgroundColor'];

        Color accent = parseColor(rawAccent);
        Color background = parseColor(rawColor);
        
        if(rawAccent == null || rawColor == null || accent == null || background == null){
          return null;
        }

        return WishlistTheme().solidInit(accent, background);
      }
      break;

      case "lGradient":{
        Map rawAccent = rawTheme['accentColor'];
        List rawColors = rawTheme['backgroundColors'];

        Color accent = parseColor(rawAccent);

        if(rawAccent == null || rawColors == null || accent == null){
          return null;
        }

        
        List<Color> backgroundColors = [];

        //Build Colors
        for(int i = 0; i<rawColors.length; i++){
          Map rawColor = rawColors[i];
          Color color = parseColor(rawColor);
          if(color != null){
            backgroundColors.add(color);
          }
        }
        
        if(backgroundColors.isEmpty){
          return null;
        }

        //Value for color will be null if a navColor is not present
        Color navColor = parseColor(rawTheme['navColor']);

        return WishlistTheme().linearGradientInit(accent, backgroundColors, navColor);
      }
      break;

      case "urlImage":{
        Map rawAccent = rawTheme['accentColor'];
        String url = rawTheme['url'];

        Color accent = parseColor(rawAccent);

        if(rawAccent == null || url == null || accent == null){
          return null;
        }
        
        //Value for color will be null if a navColor is not present
        Color navColor = parseColor(rawTheme['navColor']);

        //Build Theme
        return WishlistTheme().urlImageInit(accent, url, navColor);
      }
      break;

      default:{return null;}
      break;
    }

  }

  Color parseColor(Map data){
    if(data == null){
      return null;
    }

    int red = data['r'];
    int green = data['g'];
    int blue = data['b'];

    if(red == null || green == null || blue == null){
      return null;
    }

    return Color.fromRGBO(red, green, blue, 1);
  }

}

class WishlistPage extends StatefulWidget {

  final String name;

  WishlistPage([this.name]);

  @override
  WishlistPageState createState() => WishlistPageState(name);
}

class WishlistPageState extends State<WishlistPage> {
  
  var controller = new WishlistViewContoller();
  var defaultTheme = new WishlistTheme().solidInit(Colors.white, Colors.black);

  WishlistPageState(String name){
    configureController(name);
  }

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
    
    //Get profile and wishlist

    //On Successful load
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

  void configureController(String name){
    if(controller.currentProfile == null){
      controller.getProfile(name,(error){
        if(error == null){
          //Successful
          //configureControllerWishlist(controller.currentProfile);
          print("Succeeded");
          controller.content = WishlistContent(controller.currentProfile,controller.wishlist);
          setState(() {});
        }
        else{
          //Unsuccessful: No Profile
          print(error);
          controller.content = failureView();
          setState(() {});
        }
      });
      //Load Profile
    }
    else{
      //Get Profile
      //configureControllerWishlist(controller.currentProfile);
      controller.content = WishlistContent(controller.currentProfile,controller.wishlist);
    }
    //On success -> set controller profile and wishlist ,set content widget, update view
    //On failure -> set content widget, update view

    //NOTE: Load list will run one run once unless the page is refreshed and controller is reset
  }

  void configureControllerWishlist(Profile currentProfile){
    //Profile exists
    if(controller.wishlist == null){
      //Load wishlist
      if(true){
        //Successful
      }
      else{
        //Unsuccessful: No Wishlist
        controller.content = failureView();
      }
    }
    else{
      //Get cached wishlist
      controller.content = WishlistContent(controller.currentProfile,controller.wishlist);
    }
  }

  Widget failureView(){
    return Center(child: Text("Could not load this wishlist 💔",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: defaultTheme.accentColor)));
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
                  getTheme().background,
                  Container(
                    child: 
                    ListView(
                      children:[
                        Padding(
                            //Top padding navbar height
                            padding: EdgeInsets.fromLTRB(0, 130, 0, 0),
                            child: controller.content,
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
      DynamicAppBar(getTheme()).desktopNavBar(),
    ]);
  }

  Widget mobileStructure(){
    return
    Column(
      children: [
        DynamicAppBar(getTheme()).mobileNavBar(controller),
        Container(height:1,color: getTheme().accentColor),
        Expanded(
          child: 
          Stack(
            children:[
              getTheme().background,
              Container( 
                child:
                ListView(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: controller.content,
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

  WishlistTheme getTheme(){
    return controller.wishlist == null ? defaultTheme : controller.wishlist.theme;
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
            SizedBox(height:20),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Align(alignment: Alignment.centerLeft,child:Text("Wishlist: ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:wishlist.theme.accentColor))),
            ),
            SizedBox(height:25),
            itemList(),
            SizedBox(height:60),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children:[
                  Text("Inspired? Make your own wishlist!",textAlign: TextAlign.center,style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:wishlist.theme.accentColor)),
                  SizedBox(height:20),
                  OutlinedButton(
                    onPressed: ()=>{},
                    child: 
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Text("Sign Up 🎁",style: TextStyle(fontSize:14))
                    ),
                    style: HelperStyles.defaultButtonStyle(true,wishlist.theme.accentColor),
                  ),
                  SizedBox(height:20),
                  Text("You can sign up with Twitter, Instagram and more",textAlign: TextAlign.center,style:TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color:wishlist.theme.accentColor)),
                ]
              ),
            ),
            SizedBox(height:100),
          ],
        )
      )
    );
  }

  Widget itemList(){
    List<Widget> children = [];

    for(int i = 0; i<wishlist.items.length; i++){
      children.add(listItemView(wishlist.items[i],i));
      children.add(SizedBox(height:20));
    }

    return Column(children: children);
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
        SizedBox(height:10)
    ]);

    if(item.media.isNotEmpty){
      children.addAll([
        SizedBox(height: 5),
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
        SizedBox(height:10),
      ]);
    }

    if(item.links.isNotEmpty){
      children.addAll([
        Align(
          alignment: Alignment.topLeft,
          child:
          Container(
            height:40,
            alignment: Alignment.topLeft,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              itemCount: item.links.length,
              itemBuilder:(context,link) {
                return
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: TextButton(
                    child: 
                    Text(item.links[link].tag,style:TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.normal,fontSize: 18)),
                    onPressed: ()=>{
                      openURL(item.links[link].url)
                    },
                    style: HelperStyles.defaultButtonStyle(false,wishlist.theme.accentColor),
                  ),
                );
              }
            ),
          ),
        )
      ]);
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
          Text(profile.nickname,textAlign: TextAlign.center,style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:wishlist.theme.accentColor)),
          SizedBox(height:5),
          Text(profile.bio,textAlign: TextAlign.center,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color:wishlist.theme.accentColor)),
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

  void openURL(String url)async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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