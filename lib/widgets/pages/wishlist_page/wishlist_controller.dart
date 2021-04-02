import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_web/models/profile.dart';
import 'package:responsive_web/models/wishlist.dart';
import 'package:responsive_web/services/profile_services.dart';
import 'package:responsive_web/services/service_manager.dart';
import 'package:responsive_web/services/wishlist_services.dart';
import 'package:responsive_web/widgets/pages/wishlist_page/wishlist_main.dart';


class WishlistPageContoller{
  
  //Cached Wishlist
  Wishlist wishlist;

  //Cached Profile
  Profile currentProfile;

  var defaultTheme = new WishlistTheme().solidInit(Colors.white, Colors.black);
  
  var profileService = locator<ProfileService>();
  var wishlistService = locator<WishlistService>();

  GlobalKey<ScaffoldState> mobileDrawerKey = GlobalKey();
  Widget content;// = SpinKitDualRing(color: Colors.white,size: 30,lineWidth: 3);

  WishlistPageContoller(String username){
    print("configuring");
    content = FutureBuilder(
      future: getSetProfile(username),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(currentProfile == null){
            return Center(child: Text("Could not load this wishlist 💔",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: defaultTheme.accentColor)));
          }
          else{
            return
            FutureBuilder(
              future: getSetWishlist(currentProfile),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  if(wishlist != null){
                    return WishlistContent(currentProfile,wishlist);
                  }
                  else{
                    return Center(child: Text("Could not load this wishlist 💔",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: defaultTheme.accentColor)));
                  }
                }
                else{
                  return SpinKitDualRing(color: Colors.white,size: 30,lineWidth: 3);
                }
              }
            );
          }
        }
        else{
          return SpinKitDualRing(color: Colors.white,size: 30,lineWidth: 3);
        }
      },
    );
  }

  Future<void> getSetProfile(String username){
    return profileService.getProfileForUsername(username,null)
    .then((profile){
      currentProfile = profile;
      return profile;
    });
  }

  Future<void> getSetWishlist(Profile tempProfile){
    return wishlistService.getWishlistForOwnerID(tempProfile.userID,null)
      .then((list){
        wishlist = list;
        return list;
      });
  }

}