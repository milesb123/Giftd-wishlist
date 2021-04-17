
import 'package:flutter/material.dart';
import 'package:responsive_web/helper/helper.dart';
import 'package:responsive_web/services/authentication_services.dart';
import 'package:responsive_web/services/service_manager.dart';
import 'package:responsive_web/widgets/navbar/dynamic_navbar.dart';

class PasswordResetController{

  var authService = locator<AuthenticationService>();

  String email = "";
  
  bool emailSent = false;
  String errorMessage = "";

  Future<void> resetPasswordForEmail(String email){
    return authService.resetPassword(email);
  }

}

class PasswordResetPage extends StatefulWidget{
  PasswordResetState createState() => PasswordResetState();
}

class PasswordResetState extends State<PasswordResetPage>{
  
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
              constraints: BoxConstraints.tightFor(width:600),
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
                            PasswordResetContent()
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
                    child: PasswordResetContent()
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

class PasswordResetContent extends StatefulWidget{
  
  PasswordResetController controller = PasswordResetController();

  PasswordResetContentState createState() => PasswordResetContentState();
}

class PasswordResetContentState extends State<PasswordResetContent>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return content();
  }
  
  Widget content(){
    if(!widget.controller.emailSent){
      return 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Password Reset",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          SizedBox(height:20),
          Text("Enter your email below and submit to be sent an email allowing you to change your password ",style: TextStyle(fontSize: 16,color: Colors.white)),
          SizedBox(height:40),
          Form(
            key:_formKey,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: TextStyle(color:Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color:Colors.grey),
                    border: UnderlineInputBorder(),
                    enabledBorder: 
                    const UnderlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  validator:(String value){
                    if(value.isEmpty){
                      return 'Email is required';
                    }
                    
                    widget.controller.email = value;

                    return null;
                  },
                  onSaved: (String value){
                    
                  },
                ),
                SizedBox(height:20),
                Text(widget.controller.errorMessage,style: TextStyle(fontSize: 14,color: Colors.red)),
                SizedBox(height:40),
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width:200),
                    child: OutlinedButton(
                      onPressed: (){
                        setState(() {
                          widget.controller.emailSent = false;
                          //Reset error messages to default values
                          widget.controller.errorMessage = "";
                        });

                        if(!_formKey.currentState.validate()){
                          return;
                        }

                        _formKey.currentState.save();
                      
                        widget.controller.resetPasswordForEmail(widget.controller.email)
                        .then((value){
                          print("success");
                          setState(() {
                            widget.controller.emailSent = true;
                          });
                        })
                        .catchError((e){
                          setState((){
                            widget.controller.emailSent = false;
                            switch(e.code){
                              case 'user-not-found':
                                widget.controller.errorMessage = "There is no account registered to this email";
                                break;
                              case 'invalid-email':
                                widget.controller.errorMessage = "This email is invalid";
                                break;
                              default:
                                widget.controller.errorMessage = "Something went wrong please try again";
                                break;
                            }
                          });
                        });

                      },
                      child: 
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Text("Submit",style: TextStyle(fontSize:18))
                      ),
                      style: HelperStyles.defaultButtonStyle(true,Colors.white,Colors.white,Colors.black),
                    ),
                  ),
              ],
            )
          ),
          SizedBox(height:100)
        ],
      );
    }
    else{
      return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Password Reset",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          SizedBox(height:20),
          Text("An email has been sent to your inbox, follow the instructions to reset your password",style: TextStyle(fontSize: 16,color: Colors.green)),
          SizedBox(height:100),
        ],
      );
    }
  }
}