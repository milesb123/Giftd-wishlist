import 'dart:collection';
import 'dart:js';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_web/helper/helper.dart';
import 'package:responsive_web/models/profile.dart';
import 'package:responsive_web/models/wishlist.dart';
import 'package:responsive_web/services/authentication_services.dart';
import 'package:responsive_web/services/profile_services.dart';
import 'package:responsive_web/services/service_manager.dart';
import 'package:responsive_web/widgets/navbar/dynamic_navbar.dart';
import 'package:responsive_web/widgets/pages/wishlist_page/wishlist_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class WishlistPage extends StatefulWidget { 

  WishlistPageContoller controller;// = WishlistPageContoller("bad_gy4");

  WishlistPage(String username){
    this.controller = WishlistPageContoller(username);
  }

  static WishlistPage content(String username){
    return WishlistPage(username);
  }

  @override
  WishlistPageState createState() => WishlistPageState();
}

class WishlistPageState extends State<WishlistPage> {
  
  var defaultTheme = new WishlistTheme().solidInit(Colors.white, Colors.black);

  Widget build(BuildContext context) {
    return getScaffold(context);
  }

  Widget getScaffold(BuildContext context){
    
    //Get profile and wishlist

    //On Successful load
    return
    LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth > 700){
        return
        Scaffold(
          backgroundColor: Color.fromRGBO(240, 240, 240, 1),
          body: desktopStructure(context)
        );
      }
      else{
        return
        Scaffold(
          key: widget.controller.mobileDrawerKey,
          backgroundColor: Colors.white,
          body: mobileStructure(),
          drawer:WishlistDynamicAppBar.mobileDrawerContent(),
          drawerScrimColor: Colors.black45.withOpacity(0)
        );
      }
    });
  }

  Widget failureView(){
    return Center(child: Text("Could not load this wishlist 💔",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: defaultTheme.accentColor)));
  }

  Widget desktopStructure(BuildContext context){
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
              constraints: BoxConstraints.tightFor(width:700),
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
                            child: widget.controller.content,
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
      WishlistDynamicAppBar(getTheme()).desktopNavBar(context),
    ]);
  }

  Widget mobileStructure(){
    return
    Column(
      children: [
        WishlistDynamicAppBar(getTheme()).mobileNavBar(widget.controller),
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
                    child: widget.controller.content,
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
    return widget.controller.wishlist == null ? defaultTheme : widget.controller.wishlist.theme;
  }

}

//Wishlist Content is NOT responsible for background
class WishlistContent extends StatelessWidget{

  final Profile profile;
  final Wishlist wishlist;

  var authService = locator<AuthenticationService>();
  var profileService = locator<ProfileService>();

  WishlistContent(this.profile,this.wishlist);

  Widget build(BuildContext context) {

    List<Widget> wishlistHeaderComponents = [];

    wishlistHeaderComponents.add(Text("Wishlist: ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:wishlist.theme.accentColor)));
    
    
    if(authService.userIsLocalUser(profile.authID)){
      wishlistHeaderComponents.add(Icon(Icons.add,color: wishlist.theme.accentColor,size: 30));
    }

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
              child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: wishlistHeaderComponents
              ),
            ),
            SizedBox(height:25),
            itemList(),
            SizedBox(height:60),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: 
              actionPromptBox(context),
            ),
            SizedBox(height:100),
          ],
        )
      )
    );
  }

  Widget actionPromptBox(BuildContext context){
    if(authService.userSignedIn()){
      if(authService.userIsLocalUser(profile.authID)){
        return
        Column(
          children:[
            Text("Shoes in exactly my size? No way!",textAlign: TextAlign.center,style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:wishlist.theme.accentColor)),
            SizedBox(height:20),
            OutlinedButton(
              onPressed: ()=>{},
              child: 
              Padding(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Share",style: TextStyle(fontSize:14)),
                    SizedBox(width:5),
                    Icon(Icons.share),
                  ],
                )
              ),
              style: HelperStyles.defaultButtonStyle(true,wishlist.theme.accentColor),
            ),
            SizedBox(height:20),
            Text("Start recieving gifts by sharing with your friends and followers",textAlign: TextAlign.center,style:TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color:wishlist.theme.accentColor)),
          ]
        );
      }
      else{
        return
        Column(
          children:[
            Text("Inspired? Edit your own wishlist!",textAlign: TextAlign.center,style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:wishlist.theme.accentColor)),
            SizedBox(height:20),
            OutlinedButton(
              onPressed: ()=>{},
              child: 
              Padding(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                child:
                OutlinedButton(
                  onPressed: (){
                    profileService.getProfileForUID(authService.auth.currentUser.uid)
                    .then((value){
                      if(value != null){
                        Navigator.pushReplacementNamed(context, '/${value.username}');
                      }
                    });
                  },
                  child: 
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: 
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person),
                        SizedBox(width:5),
                        Text("Profile",style: TextStyle(fontSize:14)),
                      ],
                    )
                  ),
                  style: HelperStyles.defaultButtonStyle(true,Colors.white),
                )
              ),
              style: HelperStyles.defaultButtonStyle(true,wishlist.theme.accentColor),
            ),
            SizedBox(height:20)
          ]
        );
      }
    }
    else{
      return
      Column(
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
      );
    }

  }

  Widget itemList(){
    List<Widget> children = [];

    for(int i = 0; i<wishlist.items.length; i++){
      children.add(listItemView(wishlist.items[i],i));
      children.add(SizedBox(height:20));
    }

    return Column(mainAxisAlignment: MainAxisAlignment.start,children: children);
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

    if(authService.userIsLocalUser(profile.authID)){
      children.addAll([
          SizedBox(height:20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.delete,size:20,color: wishlist.theme.accentColor),
                Icon(Icons.edit,size:20,color: wishlist.theme.accentColor)
              ]
              ),
          )
        ]
      );
    }

    children.addAll([
      SizedBox(height:20),
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
    
    List<Widget> buttonList = [];

    buttonList.add(
      OutlinedButton(
        onPressed: () => {Clipboard.setData(new ClipboardData(text: "https://giftd-wishlist.vercel.app/#/"+profile.username))},
        child: 
        Padding(
          padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: 
          Row(
            children: [
              Text("Copy Link",style: TextStyle(fontSize:14)),
              SizedBox(width:5),
              Icon(Icons.link,size: 14,),
            ],
          )
        ),
        style: HelperStyles.defaultButtonStyle(true,wishlist.theme.accentColor),
      ),
    );

    if(authService.userIsLocalUser(profile.authID)){
      buttonList.addAll(
        [
        SizedBox(width:20),
        OutlinedButton(
          onPressed: () => {},
          child: 
          Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: 
            Row(
              children: [
                Text("Edit Profile",style: TextStyle(fontSize:14)),
                SizedBox(width:5),
                Icon(Icons.edit,size: 14,),
              ],
            )
          ),
          style: HelperStyles.defaultButtonStyle(true,wishlist.theme.accentColor),
        )
        ]
      );
    }

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
          SizedBox(height:18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttonList
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