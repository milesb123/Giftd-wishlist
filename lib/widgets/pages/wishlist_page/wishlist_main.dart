import 'dart:collection';
import 'dart:js';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_web/models/profile.dart';
import 'package:responsive_web/helper/helper.dart';
import 'package:responsive_web/models/wishlist.dart';
import 'package:responsive_web/widgets/navbar/dynamic_navbar.dart';
import 'package:responsive_web/widgets/pages/wishlist_page/wishlist_controller.dart';
import 'package:url_launcher/url_launcher.dart';

//USE CASE
// Wishlist and User objects will be flowed from the top down, by reference

//TODO:
// - Routing

//BUGS:
// - text must find new line

class WishlistPage extends StatefulWidget {

  final String name;

  WishlistPage([this.name]);

  @override
  WishlistPageState createState() => WishlistPageState(name);
}

class WishlistPageState extends State<WishlistPage> {
  
  var controller = new WishlistPageContoller();
  var defaultTheme = new WishlistTheme().solidInit(Colors.white, Colors.black);

  WishlistPageState(String name){
    configureController(name);
  }

  Widget build(BuildContext context) {
    return getScaffold(context);
  }

  Widget getScaffold(BuildContext context){
    
    //Get profile and wishlist

    //On Successful load
    return
    LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth > 600){
        return
        Scaffold(
          backgroundColor: Color.fromRGBO(30, 30, 30, 1),
          body: desktopStructure()
        );
      }
      else{
        return
        Scaffold(
          key: controller.mobileDrawerKey,
          backgroundColor: Colors.white,
          body: mobileStructure(),
          drawer:WishlistDynamicAppBar.mobileDrawerContent(),
          drawerScrimColor: Colors.black45.withOpacity(0)
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
      WishlistDynamicAppBar(getTheme()).desktopNavBar(),
    ]);
  }

  Widget mobileStructure(){
    return
    Column(
      children: [
        WishlistDynamicAppBar(getTheme()).mobileNavBar(controller),
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
              child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Wishlist: ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:wishlist.theme.accentColor)),
                  Icon(Icons.add,color: wishlist.theme.accentColor,size: 30)
                ],
              ),
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
            children: [
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
              ),
            ],
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