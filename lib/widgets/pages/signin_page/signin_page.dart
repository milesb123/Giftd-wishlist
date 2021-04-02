import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_web/helper/helper.dart';
import 'package:responsive_web/widgets/navbar/dynamic_navbar.dart';
import 'package:responsive_web/widgets/pages/signin_page/signin_controller.dart';


class SigninPage extends StatefulWidget{
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
      DynamicAppBar().desktopNavBar(context),
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

class SigninContent extends StatefulWidget{

  SigninController controller = SigninController();

  SigninContentState createState() => SigninContentState();

}

class SigninContentState extends State<SigninContent>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){

    return widget.controller.loading ? _buildLoadingCircle() : _buildContent();
  }

  Widget _buildLoadingCircle(){
    return Align(alignment: Alignment.center,child: SpinKitDualRing(color: Colors.white,size: 30,lineWidth: 3));
  }

  Widget _buildContent(){
    return
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Sign In 🎁",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
        Form(
          key:_formKey,
          child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:40),
              Text("Email",style: TextStyle(fontSize: 16,color: Colors.white)),
              _buildEmail(),
              SizedBox(height:40),
              Text("Password",style: TextStyle(fontSize: 16,color: Colors.white)),
              _buildPassword(),
              SizedBox(height:20),
              Text(widget.controller.errorMessage,style: TextStyle(fontSize: 14,color: Colors.red)),
              SizedBox(height: 60),
              Center(
                child: 
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width:double.infinity),
                  child: OutlinedButton(
                    onPressed: (){
                      setState(() {
                        widget.controller.errorMessage = "";
                      });

                      if(!_formKey.currentState.validate()){
                        return;
                      }
                      _formKey.currentState.save();

                      setState(() {
                        widget.controller.loading = true;
                      });
                      widget.controller.signIn(widget.controller.email, widget.controller.password, setState, context, _formKey);
                    },
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
                    onPressed: (){
                      
                    },
                    child: 
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Text("Sign Up",style: TextStyle(fontSize:20))
                    ),
                    style: HelperStyles.defaultButtonStyle(true,Colors.white),
                  ),
                ),
              ),
              SizedBox(height:20),
              Center(child: TextButton(style:HelperStyles.defaultButtonStyle(false,Colors.white),onPressed: (){print("clicked");}, child: Text("Forgot Password? Reset it here",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,decoration: TextDecoration.underline))))
            ],
          )
        )
      ],
    );
  }

  Widget _buildEmail(){
    return TextFormField(
      style: TextStyle(color:Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
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
        return null;
      },
      onSaved: (String value){
        widget.controller.email = value;
      },
    );
  }

  Widget _buildPassword(){
    return TextFormField(
      style: TextStyle(color:Colors.white),
      keyboardType: TextInputType.visiblePassword,
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
          return 'Password is required';
        }
      },
      onSaved: (String value){
        widget.controller.password = value;
      },
      obscureText: true,
    );
  }

}