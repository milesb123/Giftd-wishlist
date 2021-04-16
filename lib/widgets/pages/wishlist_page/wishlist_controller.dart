import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_web/models/profile.dart';
import 'package:responsive_web/models/wishlist.dart';
import 'package:responsive_web/services/authentication_services.dart';
import 'package:responsive_web/services/profile_services.dart';
import 'package:responsive_web/services/service_manager.dart';
import 'package:responsive_web/services/wishlist_services.dart';
import 'package:responsive_web/widgets/pages/wishlist_page/wishlist_main.dart';


class WishlistPageContoller{
  
  //Cached Wishlist
  Wishlist wishlist;
  //Cached Profile
  Profile profile;

  var authService = locator<AuthenticationService>();
  var profileService = locator<ProfileService>();
  var wishlistService = locator<WishlistService>();

  GlobalKey<ScaffoldState> mobileDrawerKey = GlobalKey();

  WishlistPageContoller(String username){

    //content = Text("");
      
    //   FutureBuilder(
    //   future: getSetProfile(username),
    //   builder: (context,snapshot){
    //     if(snapshot.connectionState == ConnectionState.done){
    //       if(currentProfile == null){
    //         return Center(child: Text("Could not load this wishlist 💔",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: defaultTheme.accentColor)));
    //       }
    //       else{
    //         return
    //         FutureBuilder(
    //           future: getSetWishlist(currentProfile),
    //           builder: (context,snapshot){
    //             if(snapshot.connectionState == ConnectionState.done){
    //               if(wishlist != null){
    //                 print("loaded");
    //                 return 
    //                 StreamBuilder(
    //                   stream:authService.authStream,
    //                   initialData: null,
    //                   builder: (context,snapshot){
    //                     //Ensures that the view is reloaded on change of auth state
    //                     return WishlistContent(currentProfile,wishlist, authService.userIsLocalUser(currentProfile.authID));
    //                   }
    //                 );
    //               }
    //               else{
    //                 return Center(child: Text("Could not load this wishlist 💔",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: defaultTheme.accentColor)));
    //               }
    //             }
    //             else{
    //               return SpinKitDualRing(color: Colors.white,size: 30,lineWidth: 3);
    //             }
    //           }
    //         );
    //       }
    //     }
    //     else{
    //       return SpinKitDualRing(color: Colors.white,size: 30,lineWidth: 3);
    //     }
    //   },
    // );
  }

  Future<Profile> getSetProfile(String username){
    return profileService.getProfileForUsername(username);
  }

  Future<Wishlist> getSetWishlist(Profile profile){
    return wishlistService.getWishlistForOwnerID(profile.userID,null);
  }

}