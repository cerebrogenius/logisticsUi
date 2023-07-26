import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_bloc_app/shipment/constants.dart';
import 'package:my_bloc_app/shipment/utilities/screen_size.dart';
import '../data/product_data.dart';
import '../widgets.dart';

class ShipmentMain extends StatelessWidget {
  const ShipmentMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        children: [
         SafeArea(
          child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                 Padding(
                   padding: EdgeInsets.symmetric(vertical: 12.h),
                   child:const MyAppBar(),
                 ),
                       Padding(
                      padding: EdgeInsets.only(left: 30.w,bottom: 5.h),
                      child: const TextTitleWidget(text: 'Track Your Shipment',),
                    ),
               const Padding(
                  padding:  EdgeInsets.only(left: 30.0),
                  child: SearchBox(hintText: 'Track Number',),
                ),
                SizedBox(height: 12.h,),
                Flexible(child: bodyContainer()),
                ],
              )
          ),
        ),
        ],
      ),

      bottomNavigationBar: buildButtomNavigationBar()
    );
  }

  Container bodyContainer() {
    return Container(
      alignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                  left: 30.w,
                  right: 10.w
                ),
                
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.r)
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.only(left:15.w, top: 10.w,right: 15.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top:20.h, bottom: 10.h),
                            child: myTextWidget(text: 'Delivering',size: 20.sp),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top:20.h, bottom: 10.h),
                            child: myTextWidget(text: 'Received',opacity: 0.7,size: 20.sp),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top:20.h, bottom: 10.h),
                            child: myTextWidget(text: 'All',opacity: 0.7,size: 20.sp),
                          ),
                        ],
                      ),
                    ordersList()
                    ],
                  ),
                ),
              );
  }

  ListView ordersList() {
    return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: productList.length,
                    itemBuilder: ((context, index) {
                      return detailsWidget(product: productList[index],
                      context: context
                      );
                    }),
                   );
  }
}



