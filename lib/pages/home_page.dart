import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(body: 
        Container(
          color:Colors.black,
          child: 
          SizedBox.expand(
            child: Center(child: Image.asset("assets/images/logo_capsule.png",height:90))
          )
        )
    );
  }

}