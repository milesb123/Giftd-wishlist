import 'package:flutter/material.dart';

class HelperStyles{
  static ButtonStyle defaultButtonStyle([bool outlined,Color color,Color fill,Color textColor]){
    color ??=Colors.white;
    fill ??=Colors.transparent;
    textColor ??= color;
    if(outlined){
      return
      ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return fill;
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          Color _textColor = textColor;

          if (states.contains(MaterialState.disabled)) {
            _textColor = Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            _textColor = _textColor.withOpacity(0.5);
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
          Color _overlayColor;

          if (states.contains(MaterialState.disabled)) {
            _overlayColor = Colors.transparent;
          } else if (states.contains(MaterialState.pressed)) {
            _overlayColor = color.withOpacity(0.05);
          } else {
            _overlayColor = Colors.transparent;
          }
          return Colors.transparent;
        }),
      );
    }
    else{
      return
      ButtonStyle(
        animationDuration: Duration(milliseconds: 100),
        textStyle:
          MaterialStateProperty.resolveWith<TextStyle>((states) => 
            TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontFamily: "assets/fonts/helvetica_nimbus",
            )
          ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          Color _textColor;

          if (states.contains(MaterialState.disabled)) {
            _textColor = Colors.grey;
          } else if (states.contains(MaterialState.pressed)) {
            _textColor = color.withOpacity(0.1);
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
}
