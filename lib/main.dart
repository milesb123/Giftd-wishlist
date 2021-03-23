import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_web/pages/wishlist_main.dart';

final defaultTextStyle = TextStyle(
        color:Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: "assets/fonts/helvetica_nimbus",
        fontSize: 16
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text("Something Went Wrong"));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return WishlistPage("29milesb");
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return SpinKitDualRing(color: Colors.black);
      },
    );
  }
}
