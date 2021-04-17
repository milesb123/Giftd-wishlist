import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_web/helper/helper.dart';
import 'package:responsive_web/widgets/navbar/dynamic_navbar.dart';
import 'package:responsive_web/widgets/pages/signup_page/signup_controller.dart';

class SignupPage extends StatefulWidget{
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage>{
  
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
          key: mobileDrawerKey,
          backgroundColor: Colors.black,
          body: desktopStructure(),
          drawer:WishlistDynamicAppBar.mobileDrawerContent(context),
          drawerScrimColor: Colors.black45.withOpacity(0)
        );
      }
      else{
        return
        Scaffold(
          key: mobileDrawerKey,
          backgroundColor: Colors.black,
          body: mobileStructure(),
          drawer:WishlistDynamicAppBar.mobileDrawerContent(context),
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
                            SignupContent()
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
      DynamicAppBar().desktopNavBar(context,mobileDrawerKey),
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
                    child: SignupContent()
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

class SignupContent extends StatefulWidget{
  
  SignupController controller = SignupController();

  SignupContentState createState() => SignupContentState();
}

class SignupContentState extends State<SignupContent>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  
  @override
  Widget build(BuildContext context) {
    return content(context);
  }

  Widget content(BuildContext context) {
    return
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Sign Up 🎁",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
        _buildLoginForm(context)
      ]
    );

  }

  Widget loadingIndicator(){
    if(widget.controller.loading){
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 200),
        child: SpinKitDualRing(color: Colors.white,size: 20,lineWidth: 3),
      );
    }
    else{
      return SizedBox(height:200);
    }
  }

  Widget _buildLoginForm(BuildContext context){
    _formKey.currentState?.validate();
    return
    Form(
          key:_formKey,
          child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:40),
              Text("Username",style: TextStyle(fontSize: 16,color: Colors.white)),
              _buildUsername(),
              SizedBox(height:40),
              Text("Nickname",style: TextStyle(fontSize: 16,color: Colors.white)),
              _buildNickname(),
              SizedBox(height:40),
              Text("Email",style: TextStyle(fontSize: 16,color: Colors.white)),
              _buildEmail(),
              SizedBox(height:40),
              Text("Password",style: TextStyle(fontSize: 16,color: Colors.white)),
              _buildPassword(),
              SizedBox(height:20),
              Text(widget.controller.errorMessage,style: TextStyle(fontSize: 14,color: Colors.red)),
              SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Colors.black,
                    fillColor:  MaterialStateProperty.resolveWith<Color>((states) {              
                      return Colors.white;
                    }),
                    value: widget.controller.termsAgreed, 
                    onChanged: (value){
                      setState(() {
                        widget.controller.termsAgreed = !widget.controller.termsAgreed;
                      });
                    },
                  ),
                  SizedBox(width:10),
                  Text("I agree to all the terms and conditions",style: TextStyle(fontSize: 14,color: Colors.white)),
                ],
              ),
              SizedBox(height:20),
              Center(
                child: 
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width:double.infinity),
                  child: OutlinedButton(
                    onPressed: (){
                      widget.controller.errorMessage = "";

                      if(!_formKey.currentState.validate()){
                        return;
                      }
                      
                      if(!widget.controller.termsAgreed){
                        setState(() {
                          widget.controller.errorMessage = "You must accept the terms and conditions";
                        });
                        return;
                      }

                      _formKey.currentState.save();

                      setState(() {
                        print("Loading Start");
                        widget.controller.loading = true;

                        //Reset error messages to default values
                        widget.controller.asyncEmailError = "";
                        widget.controller.usernameTaken = false;
                        widget.controller.isInavlidAsyncPass = false;
                      });
                      
                      widget.controller.signUp(widget.controller.email,widget.controller.nickname,widget.controller.username,widget.controller.password)
                      .then((value){
                          setState(() {
                            switch(value){
                              case 'success':
                                widget.controller.profileService.getProfileForUID(widget.controller.authService.auth.currentUser.uid)
                                .then((value){
                                  //Auth User exists
                                  if(value != null){
                                    //Profile exists for AuthID
                                    print(value.username);
                                    Navigator.pushReplacementNamed(context, '/${value.username}');
                                  }
                                });
                                break;
                              case 'username-taken':
                                widget.controller.usernameTaken = true;
                                break;
                              case 'invalid-email':
                                widget.controller.asyncEmailError = "This email is invalid";
                                break;
                              case 'email-already-in-use':
                                widget.controller.asyncEmailError = "This email is already registered to an account";
                                break;
                              case 'weak-password':
                                widget.controller.isInavlidAsyncPass = true;
                                break;
                              case 'auth-unsuccessful':
                                widget.controller.errorMessage = "Something went wrong, please try again";
                                break;
                              case 'profile-creation-error':
                                //widget.controller.errorMessage = "Something went wrong, please sign in";
                                //Navigate to signin -> to prompt the user to sign in which will fix the issue
                                Navigator.pushReplacementNamed(context, '/signin');
                                break;
                              case 'wishlist-creation-error':
                                //widget.controller.errorMessage = "Something went wrong, please sign in";
                                //Navigate to signin -> to prompt the user to sign in which will fix the issue
                                Navigator.pushReplacementNamed(context, '/signin');
                                break;
                              default:
                                widget.controller.errorMessage = "Something went wrong, please try again";
                                break;
                            }

                            widget.controller.loading = false;
                            print("Loading End");
                          });
                      });

                    },
                    child: 
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Text("Sign Up",style: TextStyle(fontSize:20))
                    ),
                    style: HelperStyles.defaultButtonStyle(true,Colors.white,Colors.white,Colors.black),
                  ),
                ),
              ),
              SizedBox(height:20),
              Center(child: 
                TextButton(
                  style:HelperStyles.defaultButtonStyle(false,Colors.white),onPressed: (){Navigator.pushReplacementNamed(context, '/signin');}, 
                  child: Text("Already have an account? Sign in here",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,decoration: TextDecoration.underline))
                )
              ),
              SizedBox(height:20),
              loadingIndicator()
            ],
          )
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
        
        if (widget.controller.usernameTaken) {
          // disable message until after next async call
          widget.controller.usernameTaken = false;
          return 'This username is taken';
        }

        return null;
      },
      onSaved: (String value){
        widget.controller.username = value;
      },
    );
  }

  Widget _buildNickname(){
    return TextFormField(
      style: TextStyle(color:Colors.white),
      decoration: InputDecoration(
        hintText: 'Nickname',
        hintStyle: TextStyle(color:Colors.grey),
        border: UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: const BorderSide(color: Colors.white),
      ),
      ),
      validator:(String value){
        if(value.isEmpty){
          return 'Nickname is required';
        }

        return null;
      },
      onSaved: (String value){
        widget.controller.nickname = value;
      },
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
          return 'Email is required';
        }

        if (widget.controller.asyncEmailError.isNotEmpty) {
          // disable message until after next async call
          String error = widget.controller.asyncEmailError;
          widget.controller.asyncEmailError = "";
          return error;
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

        if (widget.controller.isInavlidAsyncPass) {
          // disable message until after next async call
          widget.controller.isInavlidAsyncPass = false;
          return 'Password is too weak';
        }

        return null;
      },
      onSaved: (String value){
        widget.controller.password = value;
      },
      obscureText: true,
    );
  }
  
}