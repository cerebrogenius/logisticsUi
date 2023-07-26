import 'package:flutter/cupertino.dart';

class ScreenSize{

  static double getHeight({required BuildContext context, required double size}){
    double height = MediaQuery.of(context).size.height*size/592 ;
    // double modHeight = MediaQuery.of(context).size.height/height;
    return height;
  }
  static double getWidth({required BuildContext context, required double size}){
    double width = MediaQuery.of(context).size.width*size/360 ;
    // double modWidth = MediaQuery.of(context).size.width/width;
    return width;
  }
}