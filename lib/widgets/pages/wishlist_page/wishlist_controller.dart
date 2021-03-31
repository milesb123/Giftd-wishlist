import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_web/models/profile.dart';
import 'package:responsive_web/models/wishlist.dart';

class WishlistPageContoller{
  
  //Cached Wishlist
  Wishlist wishlist;

  //Cached Profile
  Profile currentProfile;

  CollectionReference profiles = FirebaseFirestore.instance.collection('Profiles');
  CollectionReference public_lists = FirebaseFirestore.instance.collection('Public_Lists');


  GlobalKey<ScaffoldState> mobileDrawerKey = GlobalKey();
  Widget content = SpinKitDualRing(color: Colors.white,size: 30,lineWidth: 3);

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