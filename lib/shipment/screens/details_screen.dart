import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_bloc_app/shipment/utilities/widgets/widgets.dart';

import '../models/item_model.dart';

class DetailsScreen extends StatelessWidget {
  final Items item;
  const DetailsScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              titleAndSub(title: 'Name:', subTitle: item.owner ?? ''),
              SizedBox(
                height: 10.h,
              ),
              titleAndSub(title: 'Email:', subTitle: item.email ?? ''),
              SizedBox(
                height: 10.h,
              ),
              titleAndSub(
                  title: 'Phone Number:', subTitle: item.phoneNumber ?? ''),
              SizedBox(
                height: 10.h,
              ),
              titleAndSub(title: 'Location:', subTitle: item.location ?? ''),
              SizedBox(
                height: 10.h,
              ),
              titleAndSub(
                title: 'Time:',
                subTitle: formattedDate(
                  item.date ?? DateTime.now(),
                ),
              ),
               SizedBox(
                height: 10.h,
              ),
              titleAndSub(title: 'Note:', subTitle: item.note??''),
               SizedBox(
                height: 10.h,
              ),
              titleAndSub(title: 'Status:', subTitle: item.status??'')
            ],
          ),
        ),
      ),
    );
  }
}
