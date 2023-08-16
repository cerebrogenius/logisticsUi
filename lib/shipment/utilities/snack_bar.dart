import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

class MessageSnackBar{
  showMessage({
    required BuildContext context,
    required String message,
    required bool isError,
    required IconData icon
    }){
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Container(
          color: Colors.white,
          height: 50,
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isError?Colors.redAccent:indicatorBlue, 
              ),
              ),
              SizedBox(width: 10.w,),
              Icon(icon,
              color: isError?Colors.red:Colors.green,
              )
            ],
          ),
        ))
      );
  }
}