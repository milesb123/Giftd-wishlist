
import 'package:flutter/material.dart';
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
                          color: Colors.white.withOpacity(1),
                          width: 1.0,
                        ),
                        right: BorderSide(
                          color: Colors.white.withOpacity(1),
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
          DynamicAppBar().desktopNavBar(context),
          SizedBox(height:1,width:double.infinity,child: Container(color:Colors.white.withOpacity(1)))
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
          Text("Edit Your Profile",style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
          SizedBox(height:20),
          Text("Edit the fields below to edit your profile",style: TextStyle(fontSize: 16,color: Colors.white)),
          SizedBox(height:100),
        ],
      );
  }
}