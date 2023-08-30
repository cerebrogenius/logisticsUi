import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_bloc_app/shipment/models/item_model.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

Widget appBarIcon(
    {required IconData iconName,
    required String side,
    required double padding,
    Color? backgroundColor,
    Color? iconColor,
    double? size}) {
  return Container(
    margin: EdgeInsets.only(
        top: 8.h,
        bottom: 20.h,
        left: side == 'left' ? padding : 0.0,
        right: side == 'right' ? padding : 0),
    width: size ?? 40.w,
    height: size ?? 40.w,
    decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue.withOpacity(0.1),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
        boxShadow: [
          iconName == Icons.search
              ? BoxShadow(
                  blurRadius: 5.h,
                  spreadRadius: 3.h,
                  offset: Offset(3.w, 3.w),
                  color: Colors.grey.withOpacity(0.8))
              : const BoxShadow(color: Colors.transparent)
        ]),
    child: Icon(
      iconName,
      color: iconColor ?? const Color(0xFF6799E3),
    ),
  );
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appBarIcon(iconName: Icons.menu, side: 'left', padding: 30.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            appBarIcon(
                iconName: Icons.notifications_sharp,
                side: 'right',
                padding: 13),
            appBarIcon(iconName: Icons.person, side: 'right', padding: 30.w)
          ],
        )
      ],
    );
  }
}

class TextTitleWidget extends StatelessWidget {
  final String text;
  const TextTitleWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
          color: Colors.black.withOpacity(1),
          wordSpacing: 4.0),
    );
  }
}

class SearchBox extends StatelessWidget {
  final String hintText;
  const SearchBox({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.only(left: 15.w),
            width: 250.w,
            height: 48.h,
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.r)),
            child: TextField(
              decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(0.7)),
                  border: InputBorder.none),
            )),
        SizedBox(
          width: 12.w,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: appBarIcon(
              iconName: Icons.search,
              side: 'right',
              padding: 10.w,
              backgroundColor: const Color(0XFF36CF57).withOpacity(0.8),
              size: 50,
              iconColor: Colors.white),
        ),
      ],
    );
  }
}

Widget myTextWidget(
    {required String text, double? opacity, Color? color, double? size}) {
  return Text(
    text,
    softWrap: true,
    overflow: TextOverflow.clip,
    style: TextStyle(
      fontSize: size ?? 25.sp,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.white.withOpacity(opacity ?? 1),
    ),
  );
}

Widget detailsWidget({required Items item, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.all(10.h),
    margin: EdgeInsets.symmetric(vertical: 10.h),
    height: 150.h,
    width: 450.w,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(15.r),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40.h,
              width: 40.h,
              decoration: BoxDecoration(
                color: item.status == 'In Transit'
                    ? iconColorOrange.withOpacity(0.2)
                    : iconColorGreen.withOpacity(0.2),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
              child: Icon(
                item.status == 'In Transit'
                    ? Icons.local_shipping
                    : Icons.maps_home_work,
                color: item.status == 'In Transit'
                    ? iconColorOrange
                    : iconColorGreen,
              ),
            ),
            SizedBox(width:10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myTextWidget(
                      text: item.name?.toUpperCase() ?? 'null',
                      color: Colors.black,
                      size: 18.sp),
                  myTextWidget(
                      text: item.note ?? 'null',
                      color: Colors.black.withOpacity(0.5),
                      size: 10.sp,
                      opacity: 0.1),
                ],
              ),
            ),
            appBarIcon(
                iconName: Icons.more_vert,
                side: 'left',
                padding: 5.w,
                size: 35.w)
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 45.h),
            trackingBar(item: item, context: context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getLocationAndStatus(
                    info: item.owner ?? 'null', header: 'Owner'),
                SizedBox(
                  height: 7.h,
                ),
                getLocationAndStatus(
                    info: item.location ?? 'null', header: 'To'),
              ],
            ),
            SizedBox(
              width: 25.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getLocationAndStatus(
                    info: item.status ?? 'null', header: 'Status'),
                SizedBox(
                  height: 7.h,
                ),
                getLocationAndStatus(
                    info: formattedDate(
                      item.date ?? DateTime.now(),
                    ),
                    header: 'Date'),
              ],
            )
          ],
        )
      ],
    ),
  );
}

String formattedDate(DateTime date) {
  return DateFormat.yMMMMd().format(date);
}

Widget trackingBar({required Items item, required BuildContext context}) {
  return Container(
    alignment: Alignment.centerLeft,
    width: 20.w,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Icon(
            Icons.circle,
            size: 9,
            color: item.status == 'In Transit' ? indicatorBlue : indicatorGreen,
          ),
        ),
        Container(
          color: item.status == 'In Transit' ? indicatorBlue : indicatorGreen,
          height: item.status == 'In Transit' ? 12.h : 10.h,
          width: 2.0,
        ),
        item.status == 'In Transit'
            ? const Icon(Icons.circle, size: 15, color: indicatorBlue)
            : Container(
                height: 16.w,
                width: 2.0,
                color: indicatorGreen,
              ),
        Container(
          color: item.status == 'In Transit' ? indicatorGrey : indicatorGreen,
          height: item.status == 'In Transit' ? 14.h : 11.h,
          width: 2.0,
        ),
        Icon(Icons.circle,
            size: item.status == 'In Transit' ? 9 : 15,
            color:
                item.status == 'In Transit' ? indicatorGrey : indicatorGreen),
      ],
    ),
  );
}

Widget titleAndSub(
    {required String title, required String subTitle, Color? color}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    myTextWidget(
        text: title,
        color: color ?? Colors.black.withOpacity(0.3),
        size: 12.sp),
    myTextWidget(text: subTitle, color: color ?? Colors.black, size: 12.sp)
  ]);
}

Widget getLocationAndStatus({required String info, required String header}) {
  return titleAndSub(title: header, subTitle: info);
}

Widget buildButtomNavigationBar() {
  return Container(
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 5, color: Colors.blue))),
    child: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.cube,
                size: 20,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.locationDot), label: ''),
        ]),
  );
}

class DetailsForm extends StatelessWidget {
  final Color? titleColor;
  final bool? isClickAble;
  final String? hintText;
  final String title;
  final IconData? icon;
  final TextEditingController? controller;
  const DetailsForm({
    Key? key,
    required this.title,
    this.titleColor,
    this.controller,
    this.isClickAble,
    this.icon,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16.sp,
                color: titleColor ?? Colors.black.withOpacity(0.4)),
          ),
          Row(
            children: [
              Container(
                height: 50.h,
                width: 300.w,
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.transparent),
                    color: Colors.transparent),
                child: TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                      enabled: isClickAble ?? true, hintText: hintText ?? ''),
                  controller: controller,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Icon(
                icon,
                color: Colors.black.withOpacity(0.4),
              )
            ],
          )
        ],
      ),
    );
  }
}
