import 'package:flutter/material.dart';
import 'package:responsive_web/helper/helper.dart';
import 'package:responsive_web/widgets/navbar/dynamic_navbar.dart';

class SigninPage extends StatefulWidget{

  @override
  SigninPageState createState() => SigninPageState();

}

class SigninPageState extends State<SigninPage>{
  
  GlobalKey<ScaffoldState> mobileDrawerKey = GlobalKey();

  @override
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
          backgroundColor: Colors.black,
          body: desktopStructure()
        );
      }
      else{
        return
        Scaffold(
          key: mobileDrawerKey,
          backgroundColor: Colors.black,
          body: mobileStructure(),
          drawer:WishlistDynamicAppBar.mobileDrawerContent(),
          drawerScrimColor: Colors.black45.withOpacity(0)
        );
      }
    });
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
              constraints: BoxConstraints.tightFor(width:400),
              child:
              Stack(
                children:[
                  Container(
                    child: 
                    ListView(
                      children:[
                        Padding(
                            //Top padding navbar height
                            padding: EdgeInsets.fromLTRB(0, 130, 0, 0),
                            child:
                            SigninContent()
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
      DynamicAppBar().desktopNavBar(),
    ]);
  }

  Widget mobileStructure(){
    return
    Column(
      children: [
        DynamicAppBar().mobileNavBar(mobileDrawerKey),
        Container(height:1,color: Colors.white),
        Expanded(
          child: 
          Stack(
            children:[
              Container( 
                child:
                ListView(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: SigninContent()
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

}

class SigninContent extends StatelessWidget{

  String _username;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return
    Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Sign In to Giftd",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          Form(
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:40),
                _buildUsername(),
                SizedBox(height:40),
                _buildPassword(),
                SizedBox(height:80),
                Center(
                  child: 
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width:double.infinity),
                    child: OutlinedButton(
                      onPressed: ()=>{},
                      child: 
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Text("Sign In",style: TextStyle(fontSize:20))
                      ),
                      style: HelperStyles.defaultButtonStyle(true,Colors.white,Colors.white,Colors.black),
                    ),
                  ),
                ),
                SizedBox(height:20),
                Center(
                  child: 
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width:double.infinity),
                    child: OutlinedButton(
                      onPressed: ()=>{},
                      child: 
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Text("Sign Up",style: TextStyle(fontSize:20))
                      ),
                      style: HelperStyles.defaultButtonStyle(true,Colors.white),
                    ),
                  ),
                ),
              ],
            )
          )
        ],
      );
  }

    Widget _buildUsername(){
    return TextFormField(
      style: TextStyle(color:Colors.white),
      decoration: InputDecoration(
        hintText: 'Username',
        hintStyle: TextStyle(color:Colors.grey),
        border: UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: const BorderSide(color: Colors.white),
      ),
      ),
      validator:(String value){
        if(value.isEmpty){
          return 'Username is required';
        }
      },
      onSaved: (String value){
        _username = value;

      },
    );
  }

  Widget _buildPassword(){
    return TextFormField(
      style: TextStyle(color:Colors.white),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color:Colors.grey),
        border: UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: const BorderSide(color: Colors.white),
      ),
      ),
      validator:(String value){
        if(value.isEmpty){
          return 'Username is required';
        }
      },
      onSaved: (String value){
        _username = value;

      },
    );
  }

}