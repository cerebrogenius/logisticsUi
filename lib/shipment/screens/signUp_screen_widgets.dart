
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utilities/constants.dart';


class CustomButton extends StatelessWidget {
  bool isLoading;
  final Function() function;
  final String buttonName;  
  final IconData icon;
  CustomButton({
  Key? key, 
  this.isLoading =false,
  required this.buttonName, 
  required this.icon, 
  required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.h,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9.r)),
        color: indicatorBlue
      ),
      child: isLoading? const CircularProgressIndicator(): Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: function,
            child: Text(buttonName,
            style: const TextStyle(
              color: Colors.white,
            ),
            ),
          ),
          Icon(icon, color: Colors.white,)
        ],
      ),
    );
  }
}
class HaveAccount extends StatelessWidget {
  final Function() function;
  final String message;
  final String prompt;
  const HaveAccount({Key? key, 
  required this.message, 
  required this.prompt, 
  required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: message, 
                  style:const  TextStyle(
                    color: Colors.black
                  )),
                  TextSpan(text: prompt, style: const TextStyle(color: indicatorBlue))
              ]
             )),
    );
  }
}
