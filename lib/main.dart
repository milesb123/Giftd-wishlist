import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_web/fluro_router.dart';
import 'package:responsive_web/services/service_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  RouteManager.setupRouter();
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
          return 
          MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: RouteManager.router.generator
          );
          //HomeView();//WishlistPage("29milesb");
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return SpinKitDualRing(color: Colors.black);
      },
    );
  }
}
