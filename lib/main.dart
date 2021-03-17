import 'package:flutter/material.dart';
import 'wishlist_app/wishlist_main.dart';

final defaultTextStyle = TextStyle(
        color:Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: "assets/fonts/helvetica_nimbus",
        fontSize: 16
);

void main() {
  runApp(MockContainer());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: 
        Stack(
            children:
            [
              getContainer(),
              ResponsiveNavbar()
            ]
          )
        )
    );
  }
  
  Widget getContainer(){
    return
    LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth > 800){
        return ResponsiveContainer(width:constraints.maxWidth);
      }
      else{
        return MobileContainer(width:constraints.maxWidth);
      }
    });
  }
}

class MobileContainer extends StatelessWidget{

  MobileContainer({this.width});

  double width;
  Color listColor;

  Widget build(BuildContext context){
    return
    Container(
      child:
      Center(child:
      ListView(
        children:[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child:
              WishlistView(width: width,horizontalPadding: 20)
          )
        ]
        )
      )
    );
  }
}

class ResponsiveContainer extends StatelessWidget{
  ResponsiveContainer({this.width});

  double width;

  Widget build(BuildContext context) {
    return
    Container(
      //background
      color: Color.fromRGBO(1, 1, 1, 0.05),
      child:
      Center(child:
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width:800),
          child:
          Container(
            color:Colors.white,
            child: 
            ListView(
              children:[
              Padding(
                  //Top padding navbar height
                  padding: EdgeInsets.fromLTRB(0, 130, 0, 0),
                  child: WishlistView(width: width,horizontalPadding: 30)
                  
              )
            ])
          )
        )
      )  
    );
  }
}

class WishlistView extends StatelessWidget{

  WishlistView({this.width,this.horizontalPadding});

  double width;
  double horizontalPadding;
  double headlineMultiplier = 1.2;
  double subheadlineMultiplier = 0.75;

  Widget build(BuildContext context) {
    return
    Column(
      children: [
        Center(child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              Container(
                width: imageHeight(),
                height: imageHeight(),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                  DecorationImage(
                    image: NetworkImage('https://i.pinimg.com/originals/27/43/fb/2743fb8265a1bae2cf33fd153ccb213d.jpg'),
                    fit:BoxFit.cover
                  ),
                ),
              ),
              SizedBox(height:isMobile() ? 15 : 20)
              ,
              Text("Miles Morales",style:TextStyle(fontWeight: FontWeight.bold,fontSize: textSize()*headlineMultiplier)),
              SizedBox(height: isMobile() ? 5 : 10),
              Text("If you want to nice me you can 😁",style:TextStyle(fontWeight: FontWeight.w400,fontSize: textSize())),
              SizedBox(height:isMobile() ? 15 : 20),
              OutlinedButton(
                onPressed: ()=>{},
                child: 
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Text("Copy Link 🌍",style: TextStyle(fontSize:textSize()*subheadlineMultiplier))
                ),
                style: defaultButtonStyle(true,Colors.black),
              )
            ]
          )
        ),
        SizedBox(height: isMobile() ? 15 : 30),
        Align(alignment: Alignment.centerLeft,child:Padding(padding:EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 0) ,child:Text("Wishlist: ",style:TextStyle(fontWeight: FontWeight.bold,fontSize: textSize()*headlineMultiplier)))),
        SizedBox(height: isMobile() ? 15 : 30),
        //List Item
        Align(
          alignment: Alignment.centerLeft,
          child:
          Padding(
            padding:EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 0),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("1. You + a North Face jacket would make my whole year 💕",style:TextStyle(fontWeight: FontWeight.w400,fontSize: textSize())),
              ]
            )
          ),
        ),
        SizedBox(height: isMobile() ? 10 : 15),
        Container(
          height:textSize()+5,
          alignment: Alignment.topLeft,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 0),
            children: [
              Text("📎"),
              SizedBox(width:5),
              TextButton(
                child: 
                Text("Le jacket",style:TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.w400,fontSize: textSize())),
                onPressed: ()=>{},
                style: defaultButtonStyle(false,Colors.blue),
              ),
              SizedBox(width:5),
            ]
          ),
        ),
        SizedBox(height: isMobile() ? 15 : 25),
        Container(
          height:itemImageHeight(),
          alignment: Alignment.centerLeft,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 0),
            children: [
              Container(
                width:itemImageWidth(),
                height: itemImageHeight(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image:
                  DecorationImage(
                    image:NetworkImage('https://image-cdn.hypb.st/https%3A%2F%2Fhypebeast.com%2Fimage%2F2020%2F10%2Fsupreme-the-north-face-fall-2020-collection-info-06.jpg?q=75&w=800&cbr=1&fit=max'),
                    fit:BoxFit.cover
                  ),
                ),
              )
            ]
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, isMobile() ? 30 : 40, horizontalPadding, 0),
          child: Container(height:1,color: Colors.black.withOpacity(0.5)),
        ),
        SizedBox(height:100)
      ]
    );
  }

  bool isMobile(){
    return width<=400;
  }
  
  double itemImageHeight(){
    return imageHeight()*0.8;
  }

  double itemImageWidth(){
    return imageWidth()*0.8;
  }

  double imageHeight(){
    return imageWidth()*0.7;
  }

  double imageWidth(){
    if(width > 800){
      return 340;
    }
    else if(width > 400){
      return 250;
    }
    else{
      return 210;
    }
  }

  double textSize(){
    if(width > 800){
      return 18;
    }
    else if(width > 400){
      return 16;
    }
    else{
      return 12;
    }
  }

  double genericSpacing(){
    return 20;
  }

}

class ResponsiveNavbar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
    LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth > 800){
        return 
        ConstrainedBox(constraints: BoxConstraints.tightFor(height:90),child:DesktopNavbar());
      }
      else{
        return MobileNavbar();
      }
    });
  }
}

class DesktopNavbar extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return
    DefaultTextStyle(
      style: defaultTextStyle, 
      child: 
      Container(
        decoration: new BoxDecoration(
          color: Colors.black,
          boxShadow: [BoxShadow(blurRadius: 12,color:Color.fromRGBO(1, 1, 1, 1))]
        ),
        child:
        Padding(
          padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
          child:
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(height:50),
                child:
                TextButton(
                  style: defaultButtonStyle(false),
                  child: Image.asset("assets/images/logo_capsule.png"),
                  onPressed: ()=>{}
                )
              ),
              Row(
                children: [
                  TextButton(onPressed: ()=>{}, child: Text("My Wishlist"),style: defaultButtonStyle(false)),
                  SizedBox(width:40),
                  OutlinedButton(
                    onPressed: ()=>{},
                    child: 
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Text("Log Out")
                    ),
                    style: defaultButtonStyle(true),
                  )
                ],
              )
            ]
          )
        )
      )
    );
  }
}

class MobileNavbar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
    ConstrainedBox(
      constraints: BoxConstraints.tightFor(height:61),
      child:
      Container(
          width: double.infinity,
          color:Colors.white,
          /*
          decoration: new BoxDecoration(
            color: Colors.black,
            boxShadow: [BoxShadow(blurRadius: 6,color:Color.fromRGBO(1, 1, 1, 1))]
          ),
          */
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child:
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20,15),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("🎁",style:TextStyle(fontSize: 25)),
                      TextButton(
                        style: defaultButtonStyle(false),
                        child: Image.asset("assets/images/logo_capsule.png",height:25),
                        onPressed: ()=>{}
                      )
                    ],
                  ),
                )
              ),
              Container(height:1,color: Colors.black)
            ],
          )
      )
    );
  }
}

ButtonStyle defaultButtonStyle([bool outlined,Color color]){
    color ??=Colors.white;
    if(outlined){
      return
      ButtonStyle(
        textStyle:
          MaterialStateProperty.resolveWith<TextStyle>((states) => 
            TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontFamily: "assets/fonts/helvetica_nimbus",
              fontSize: 16
            )
          ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          Color _textColor;

          if (states.contains(MaterialState.disabled)) {
            _textColor = Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            _textColor = color.withOpacity(0.5);
          } else {
            _textColor = color;
          }
          return _textColor;
        }),
        side: MaterialStateProperty.resolveWith((states) {
          Color _borderColor;

          if (states.contains(MaterialState.disabled)) {
            _borderColor = Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            _borderColor = color.withOpacity(0.5);
          } else {
            _borderColor = color;
          }
          return BorderSide(color: _borderColor, width: 1);
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(40));
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          return Colors.transparent;
        }),
      );
    }
    else{
      return
      ButtonStyle(
        animationDuration: Duration(milliseconds: 150),
        textStyle:
          MaterialStateProperty.resolveWith<TextStyle>((states) => 
            TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontFamily: "assets/fonts/helvetica_nimbus",
              fontSize: 16
            )
          ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          Color _textColor;

          if (states.contains(MaterialState.disabled)) {
            _textColor = Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            _textColor = color.withOpacity(0.5);
          } else {
            _textColor = color;
          }
          return _textColor;
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(40));
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          return Colors.transparent;
        }),
      );
    }
  }