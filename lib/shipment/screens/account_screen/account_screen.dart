import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Profile Details',
                  style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.normal,
                      color: indicatorBlue),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                   var user =
                        HttpRequest().getUserDetails();
                    print(user.toString());
                  },
                  child: Text('click'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
