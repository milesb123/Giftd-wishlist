import 'dart:collection';
import 'dart:js';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  String username;
  WishlistPageContoller controller;
  Widget content;

  WishlistPage(String username){
    this.controller = WishlistPageContoller(username);
    this.username = username;
  }

  static WishlistPage createPage(String username){
    return WishlistPage(username);
  }

  @override
  WishlistPageState createState() => WishlistPageState();
}

class WishlistPageState extends State<WishlistPage> {
  
  Widget build(BuildContext context) {
    //return getScaffold(context);
    return
    FutureBuilder(
      future: widget.controller.getSetProfile(widget.username),
      builder: (context,proSnap){
        if(proSnap.connectionState == ConnectionState.done){
          widget.controller.profile = proSnap.data;
          if(proSnap.data == null){
            widget.content = Center(child: Text("Could not load this wishlist 💔",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: WishlistTheme.defaultTheme.accentColor)));
            return getScaffold(context, null);
          }
          else{
            return
            FutureBuilder(
              future: widget.controller.getSetWishlist(proSnap.data),
              builder: (context,wishSnap){
                if(wishSnap.connectionState == ConnectionState.done){
                  if(wishSnap.data != null){
                    widget.controller.wishlist = wishSnap.data;
                    return 
                    StreamBuilder(
                      stream:widget.controller.authService.authStream,
                      initialData: null,
                      builder: (context,snapshot){
                        //Ensures that the view is reloaded on change of auth state
                        print("success");
                        print(widget.controller.wishlist == null);
                        widget.content = WishlistContent(widget.controller.profile,widget.controller.wishlist, widget.controller.authService.userIsLocalUser(widget.controller.profile.authID));
                        return getScaffold(context, widget.controller.wishlist);//WishlistContent(currentProfile,wishlist, authService.userIsLocalUser(currentProfile.authID));
                      }
                    );
                  }
                  else{
                    widget.content = Center(child: Text("Could not load this wishlist 💔",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: WishlistTheme.defaultTheme.accentColor)));
                    return getScaffold(context, null);
                  }
                }
                else{
                  widget.content = SpinKitDualRing(color: Colors.white,size: 30,lineWidth: 3);
                  return getScaffold(context, null);
                }
              }
            );
          }
        }
        else{
          widget.content = SpinKitDualRing(color: Colors.white,size: 30,lineWidth: 3);
          return getScaffold(context, null);
        }
      },
    );
  }

  Widget getScaffold(BuildContext context,Wishlist wishlist){
    print("load");
    return
    LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth > 700){
        return
        Scaffold(
          key: widget.controller.mobileDrawerKey,
          backgroundColor: Color.fromRGBO(240, 240, 240, 1),
          body: desktopStructure(context,wishlist),
          drawer:WishlistDynamicAppBar.mobileDrawerContent(),
          drawerScrimColor: Colors.black45.withOpacity(0)
        );
      }
      else{
        return
        Scaffold(
          key: widget.controller.mobileDrawerKey,
          backgroundColor: Colors.white,
          body: mobileStructure(wishlist),
          drawer:WishlistDynamicAppBar.mobileDrawerContent(),
          drawerScrimColor: Colors.black45.withOpacity(0)
        );
      }
    });
  }

  Widget desktopStructure(BuildContext context,Wishlist wishlist){
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
                  getTheme(wishlist).background,
                  Container(
                    child: 
                    ListView(
                      children:[
                        Padding(
                            //Top padding navbar height
                            padding: EdgeInsets.fromLTRB(0, 130, 0, 0),
                            child: widget.content,
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
      WishlistDynamicAppBar(getTheme(wishlist)).desktopNavBar(context,widget.controller),
    ]);
  }

  Widget mobileStructure(Wishlist wishlist){
    return
    Column(
      children: [
        WishlistDynamicAppBar(getTheme(wishlist)).mobileNavBar(widget.controller),
        Container(height:1,color: getTheme(wishlist).accentColor),
        Expanded(
          child: 
          Stack(
            children:[
              getTheme(wishlist).background,
              Container( 
                child:
                ListView(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: widget.content,
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

  WishlistTheme getTheme(Wishlist wishlist){
    print(wishlist == null);
    return wishlist == null ? WishlistTheme.defaultTheme : wishlist.theme;
  }

}

class WishlistContent extends StatefulWidget{

  final Profile profile;
  final Wishlist wishlist;
  final bool isLocalUser;

  bool emailSent = false;

  var authService = locator<AuthenticationService>();
  var profileService = locator<ProfileService>();

  WishlistContent(this.profile,this.wishlist,this.isLocalUser);
  
  WishlistContentState createState() => WishlistContentState();
}

//Wishlist Content is NOT responsible for background
class WishlistContentState extends State<WishlistContent>{

  Widget build(BuildContext context) {

    if(!widget.authService.userIsLocalUser(widget.profile.authID)){ 
      return content(context);
    }
    else{
      //Is Local User's Page
      if(widget.authService.auth.currentUser.emailVerified){
        //Is Verified
        return content(context);
      }
      else{
        return verifyEmailView(context);
      }
    }
  }

   Widget verifyEmailView(BuildContext context){
    Widget subtext;

    if(!widget.emailSent){
      subtext = 
      TextButton(
        style:HelperStyles.defaultButtonStyle(false,Colors.white),onPressed: (){
          widget.authService.auth.currentUser.sendEmailVerification()
          .then((value){
            setState(() {
              widget.emailSent = true;
            });
          });
        }, 
        child: Text("Can't find the email? Click here to resend it",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,decoration: TextDecoration.underline))
      );
    }
    else{
      subtext = Text("Email Sent!",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,decoration: TextDecoration.underline));
    }

    return
    SizedBox(
      width:double.infinity,
      child:
      Container(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Please check your inbox and verify your email 💕",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: WishlistTheme.defaultTheme.accentColor)),
            SizedBox(height:20),
            subtext
          ],
        )
      )
    );
  }

  Widget content(BuildContext context){
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
            wishlistTitleRow(),
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

  Widget wishlistTitleRow(){
    List<Widget> wishlistHeaderComponents = [];

    wishlistHeaderComponents.add(Text("Wishlist: ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:widget.wishlist.theme.accentColor)));
    
    
    if(widget.isLocalUser){
      wishlistHeaderComponents.add(Icon(Icons.add,color: widget.wishlist.theme.accentColor,size: 30));
    }

    return
    Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: 
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: wishlistHeaderComponents
      ),
    );

  }

  Widget actionPromptBox(BuildContext context){
    if(widget.authService.userSignedIn()){
      if(widget.isLocalUser){
        return
        Column(
          children:[
            Text("Start Recieving Gifts!",textAlign: TextAlign.center,style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:widget.wishlist.theme.accentColor)),
            SizedBox(height:20),
            SizedBox(
              width: 150,
              child: OutlinedButton(
                onPressed: () => {Clipboard.setData(new ClipboardData(text: "https://giftd-wishlist.vercel.app/#/"+widget.profile.username))},
                child: 
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Copy Link",style: TextStyle(fontSize:14)),
                      SizedBox(width:5),
                      Icon(Icons.link,size: 14,),
                    ],
                  )
                ),
                style: HelperStyles.defaultButtonStyle(true,widget.wishlist.theme.accentColor),
              ),
            ),
            SizedBox(height:20),
            Text("Share you wishlist with your friends and followers",textAlign: TextAlign.center,style:TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color:widget.wishlist.theme.accentColor)),
          ]
        );
      }
      else{
        return
        Column(
          children:[
            Text("Inspired? Edit your own wishlist!",textAlign: TextAlign.center,style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:widget.wishlist.theme.accentColor)),
            SizedBox(height:20),
            OutlinedButton(
              onPressed: (){
                widget.profileService.getProfileForUID(widget.authService.auth.currentUser.uid)
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
          Text("Inspired? Make your own wishlist!",textAlign: TextAlign.center,style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:widget.wishlist.theme.accentColor)),
          SizedBox(height:20),
          OutlinedButton(
            onPressed: ()=>{},
            child: 
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Text("Sign Up 🎁",style: TextStyle(fontSize:14))
            ),
            style: HelperStyles.defaultButtonStyle(true,widget.wishlist.theme.accentColor),
          ),
          SizedBox(height:20),
          Text("You can sign up with Twitter, Instagram and more",textAlign: TextAlign.center,style:TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color:widget.wishlist.theme.accentColor)),
        ]
      );
    }

  }

  Widget itemList(){
    List<Widget> children = [];

    for(int i = 0; i<widget.wishlist.items.length; i++){
      children.add(listItemView(widget.wishlist.items[i],i));
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
            Text("${(index+1).toString()}. ${item.message}",style:TextStyle(fontSize: 18,color: widget.wishlist.theme.accentColor))
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
                    style: HelperStyles.defaultButtonStyle(false,widget.wishlist.theme.accentColor),
                  ),
                );
              }
            ),
          ),
        )
      ]);
    }

    if(widget.isLocalUser){
      children.addAll([
          SizedBox(height:20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.delete,size:20,color: widget.wishlist.theme.accentColor),
                Icon(Icons.edit,size:20,color: widget.wishlist.theme.accentColor)
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
        child: Container(height:1, color:widget.wishlist.theme.accentColor.withOpacity(0.25), width:double.infinity),
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
        onPressed: () => {Clipboard.setData(new ClipboardData(text: "https://giftd-wishlist.vercel.app/#/"+widget.profile.username))},
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
        style: HelperStyles.defaultButtonStyle(true,widget.wishlist.theme.accentColor),
      ),
    );

    if(widget.isLocalUser){
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
          style: HelperStyles.defaultButtonStyle(true,widget.wishlist.theme.accentColor),
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
                image: NetworkImage(widget.profile.imageURL),
                fit:BoxFit.cover
              ),
            ), 
          ),
          SizedBox(height:10),
          Text(widget.profile.nickname,textAlign: TextAlign.center,style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:widget.wishlist.theme.accentColor)),
          SizedBox(height:5),
          Text(widget.profile.bio,textAlign: TextAlign.center,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color:widget.wishlist.theme.accentColor)),
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