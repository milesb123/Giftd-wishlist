import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_web/models/wishlist.dart';

class WishlistService{

  CollectionReference profiles = FirebaseFirestore.instance.collection('Profiles');
  CollectionReference public_lists = FirebaseFirestore.instance.collection('Public_Lists');

  Future<String> createNewWishlist(String ownerID ,List<Map> items, Map theme) async {
    //Mandatory Fields: items, ownerID, theme
    try {
      var wishlist = public_lists.doc();

      await wishlist.set({
        'items':items,
        'ownerID':ownerID,
        'theme':theme
      });
      
      return wishlist.id;
    }
    catch (e) {
      return null;
    }
  }

  Future<Wishlist> getWishlistForOwnerID(String userID,Function(dynamic) error) {
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
              print(theme.background);

              if(ownerID == null){
                error("Required fields missing");
              }

              //Publish Wishlist
              var wishlist = new Wishlist(doc.id,ownerID.toString(),items,theme == null ? WishlistTheme().solidInit(Colors.white, Colors.pink) : theme);
              return wishlist;
            }
            else{
              error("Items field missing");
              return null;
            }
          }
          else{
            error("List Fetch Error");
            return null;
          }
        })
        .catchError((error){
          error(error);
          return null;
        });
  }

  WishlistTheme buildTheme(Map rawTheme){
    String type = rawTheme['type'];
    
    if(type == null){
      return null;
    }

    switch(type){
      case "solid":{
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
        print("Image detected");
        Map rawAccent = rawTheme['accentColor'];
        String url = rawTheme['url'];

        Color accent = parseColor(rawAccent);

        if(rawAccent == null || url == null || accent == null){
          print("nulled");
          return null;
        }
        
        //Value for color will be null if a navColor is not present
        Color navColor = parseColor(rawTheme['navColor']);

        print(url);

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