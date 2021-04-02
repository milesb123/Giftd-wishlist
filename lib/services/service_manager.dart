
import 'package:get_it/get_it.dart';
import 'package:responsive_web/services/authentication_services.dart';
import 'package:responsive_web/services/profile_services.dart';
import 'package:responsive_web/services/wishlist_services.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerSingleton(AuthenticationService());
  locator.registerSingleton(ProfileService());
  locator.registerSingleton(WishlistService());
}