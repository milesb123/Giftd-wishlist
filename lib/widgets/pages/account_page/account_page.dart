
import 'package:flutter/material.dart';
import 'package:responsive_web/helper/helper.dart';
import 'package:responsive_web/widgets/navbar/dynamic_navbar.dart';

class AccountPage extends StatelessWidget{
  
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
      if(constraints.maxWidth > 800){
        return
        Scaffold(
          key: mobileDrawerKey,
          backgroundColor: Colors.black,
          body: desktopStructure(context),
          drawer:WishlistDynamicAppBar.mobileDrawerContent(),
          drawerScrimColor: Colors.black45.withOpacity(0)
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
              constraints: BoxConstraints.tightFor(width:800),
              child:
              Stack(
                children:[
                  Container(
                    decoration: 
                    BoxDecoration(
                      border: 
                      Border(
                        left: BorderSide(
                          color: Colors.white.withOpacity(0),
                          width: 1.0,
                        ),
                        right: BorderSide(
                          color: Colors.white.withOpacity(0),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: 
                    ListView(
                      children:[
                        Padding(
                            //Top padding navbar height
                            padding: EdgeInsets.fromLTRB(30, 130, 30, 0),
                            child:
                            AccountContent()
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
      Column(
        children: [
          DynamicAppBar().desktopNavBar(context,mobileDrawerKey),
          SizedBox(height:1,width:double.infinity,child: Container(color:Colors.white.withOpacity(0)))
        ],
      ),
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
                    child: AccountContent()
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

class AccountContent extends StatefulWidget{

  AccountContentState createState() => AccountContentState();

}

class AccountContentState extends State<AccountContent>{

  @override
  Widget build(BuildContext context) {
    return content(context);
  }
  
  Widget content(BuildContext context){
    return 
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profile Information",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          SizedBox(height:30),
          UsernameField(),
          SizedBox(height:30),
          NicknameField(),
          SizedBox(height:30),
          BioField(),
          SizedBox(height:30),
          Text("Sensitive Information",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          SizedBox(height:20),
          Text("Email",style: TextStyle(fontSize: 16,color: Colors.white)),
          SizedBox(height:10),
          Text("milesbroomfield@yahoo.com",style: TextStyle(fontSize: 16,color: Colors.grey)),
          SizedBox(height:20),
          TextButton(
            style:HelperStyles.defaultButtonStyle(false,Colors.white),onPressed: (){ 
            }, 
            child: Text("Update Email",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,decoration: TextDecoration.underline))
          ),
          SizedBox(height:20),
          TextButton(
            style:HelperStyles.defaultButtonStyle(false,Colors.white),onPressed: (){ 
            }, 
            child: Text("Update Password",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,decoration: TextDecoration.underline))
          ),
          SizedBox(height:20),
          TextButton(
            style:HelperStyles.defaultButtonStyle(false,Colors.white),onPressed: (){ 
            }, 
            child: Text("Forgot Password",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,decoration: TextDecoration.underline))
          ),
          SizedBox(height:100),
        ],
      );
  }
}

class UsernameField extends StatefulWidget{

  TextEditingController textController = TextEditingController(text: "old name");
  String a = "a";

  UsernameFieldState createState() => UsernameFieldState();

}

class UsernameFieldState extends State<UsernameField>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return
    Form(
      key:_formKey,
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text("Username",style: TextStyle(fontSize: 16,color: Colors.white)),
        TextFormField(
          controller: widget.textController,
          style: TextStyle(color:Colors.white),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Username',
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
              return 'Username is required';
            }
                      
            ////Some profile value that may change or remain unchanged
            widget.a = "new name";

            //Update field in database, on success update local profile object

            return null;
          },
          onFieldSubmitted: (String value){
            _formKey.currentState.validate();

            

            _formKey.currentState.save();
          },
          onSaved: (String value){

            setState(() {
              widget.textController.value = 
              TextEditingValue(
                text: widget.a,
                selection: TextSelection.fromPosition(
                  TextPosition(offset: widget.a.length),
                ),
              );
            });
          },
        )
      ])
    );

  }

}

class NicknameField extends StatefulWidget{

  NicknameFieldState createState() => NicknameFieldState();

}

class NicknameFieldState extends State<NicknameField>{

  @override
  Widget build(BuildContext context) {
    return
    Form(
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text("Nickname",style: TextStyle(fontSize: 16,color: Colors.white)),
        TextFormField(
          initialValue: "Miles Morales",
          style: TextStyle(color:Colors.white),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Nickname',
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
              return 'Nickname is required';
            }
            
            //widget.controller.email = value;

            return null;
          },
          onSaved: (String value){
            
          },
        )
      ])
    );

  }

}

class BioField extends StatefulWidget{

 BioFieldState createState() => BioFieldState();

}

class BioFieldState extends State<BioField>{

  @override
  Widget build(BuildContext context) {
    return
    Form(
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text("Bio",style: TextStyle(fontSize: 16,color: Colors.white)),
        TextFormField(
          initialValue: "You can nice me if you want 😁",
          style: TextStyle(color:Colors.white),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Add a bio to your profile',
            hintStyle: TextStyle(color:Colors.grey),
            border: UnderlineInputBorder(),
            enabledBorder: 
            const UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
          validator:(String value){
            
            //widget.controller.email = value;

            return null;
          },
          onSaved: (String value){
            
          },
        )
      ])
    );

  }

}