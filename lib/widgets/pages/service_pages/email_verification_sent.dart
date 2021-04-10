
import 'package:flutter/material.dart';
import 'package:responsive_web/helper/helper.dart';
import 'package:responsive_web/services/authentication_services.dart';
import 'package:responsive_web/services/profile_services.dart';
import 'package:responsive_web/services/service_manager.dart';
import 'package:responsive_web/widgets/navbar/dynamic_navbar.dart';

class EmailVerificationPage extends StatelessWidget{
  
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
          body: desktopStructure(context)
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

  Widget desktopStructure(BuildContext context){
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
                            EmailVerificationContent()
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
                    child: EmailVerificationContent()
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

class EmailVerificationContent extends StatefulWidget{

  EmailVerificationContentState createState() => EmailVerificationContentState();

}

class EmailVerificationContentState extends State<EmailVerificationContent>{

  final profileService = locator<ProfileService>();
  final authService = locator<AuthenticationService>();

  bool emailSent = false;

  @override
  Widget build(BuildContext context) {
    return content(context);
  }
  
  Widget content(BuildContext context){
    
    if(!authService.userSignedIn()){
      return Text("This email is already verified 🥳",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold));
    }
    else if(authService.userSignedIn() && authService.auth.currentUser.emailVerified){
      return 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This email is already verified",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          SizedBox(height:20),
          TextButton(
            style:HelperStyles.defaultButtonStyle(false,Colors.white),onPressed: (){ 
              profileService.getProfileForUID(authService.auth.currentUser.uid)
              .then((value){
                if(value != null){
                  Navigator.pushReplacementNamed(context, '/${value.username}');
                }
              });
            }, 
            child: Text("Return to profile",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,decoration: TextDecoration.underline))
          ),
          SizedBox(height:100),
        ],
      );
    }
    else if(emailSent){
      return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email Sent! 🥳",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          SizedBox(height:20),
          Text("An email has been sent to your inbox, follow the instructions to verify your email.",style: TextStyle(fontSize: 16,color: Colors.white)),
          SizedBox(height:100),
        ],
      );
    }
    else{
      return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("One more step! 🥳",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          SizedBox(height:20),
          Text("An email has been sent to your inbox, follow the instructions to verify your email.",style: TextStyle(fontSize: 16,color: Colors.white)),
          SizedBox(height:20),
          TextButton(
            style:HelperStyles.defaultButtonStyle(false,Colors.white),onPressed: (){
              authService.auth.currentUser.sendEmailVerification()
              .then((value){
                setState(() {
                  emailSent = true;
                });
              });
            }, 
            child: Text("Can't find the email? Click here to resend it",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,decoration: TextDecoration.underline))
          ),
          SizedBox(height:100),
        ],
      );
    }
  }
}