import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_bloc_app/shipment/models/item_model.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';
import 'package:my_bloc_app/shipment/screens/post_item/cubit/post_item_cubit.dart';
import 'package:my_bloc_app/shipment/screens/welcome_page/main_page/cubit/main_page_cubit.dart';
import '../../../utilities/widgets/widgets.dart';
import '../../login_screen/cubit/login_cubit.dart';

class ShipmentMain extends StatefulWidget {
  const ShipmentMain({Key? key}) : super(key: key);

  @override
  State<ShipmentMain> createState() => _ShipmentMainState();
}

class _ShipmentMainState extends State<ShipmentMain> {
  @override
  void initState() {
    final login = context.read<LoginCubit>();
    login.getUserDetails(login.state.access);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12.h,
                ),
                child: const MyAppBar(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 30.w,
                  bottom: 5.h,
                ),
                child: InkWell(
                  onTap: () {
                    final access = context.read<LoginCubit>().state.access;
                    // context.read<PostItemCubit>().getItems(accessToken: access);
                  },
                  child: const TextTitleWidget(
                    text: 'Track Your Shipment',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 30.0,
                ),
                child: SearchBox(
                  hintText: 'Track Number',
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Flexible(
                child: bodyContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container bodyContainer() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
        left: 30.w,
        right: 10.w,
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            35.r,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 15.w,
          top: 10.w,
          right: 15.w,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                    bottom: 10.h,
                  ),
                  child: myTextWidget(
                    text: 'Delivering',
                    size: 20.sp,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                    bottom: 10.h,
                  ),
                  child: myTextWidget(
                    text: 'Received',
                    opacity: 0.7,
                    size: 20.sp,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                    bottom: 10.h,
                  ),
                  child: myTextWidget(
                    text: 'All',
                    opacity: 0.7,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
            ordersList(),
          ],
        ),
      ),
    );
  }

  ordersList() {
    return StreamBuilder<List<Items>>(
        stream: HttpRequest().getItemStream(
          accessToken: context.read<LoginCubit>().state.access,
        ),
        builder: (BuildContext context, items) {
          if (items.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.blue,
              height: 50.h,
              width: 50.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (items.connectionState == ConnectionState.done) {
            if (items.hasError) {
              return Container(
                width: 450.w,
                height: 150.h,
                color: Colors.white,
                child: Center(
                  child: Text(
                    items.error.toString(),
                  ),
                ),
              );
            } else if (items.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: items.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: (() =>
                          showOptions(context, items.data![index])),
                      child: detailsWidget(
                          item: items.data![index], context: context),
                    );
                  });
            }
          }
          return Container(
            width: 450.w,
            height: 150.h,
            color: Colors.white,
            child: const Text(
              'You Have No Posts Yet',
              style: TextStyle(color: Colors.black),
            ),
          );
        });
  }
}

showOptions(
  BuildContext context,
  Items item,
) {
  return showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<PostItemCubit, PostItemCubitState>(
          builder: (context, state) {
            return AlertDialog(
              actions: [
                InkWell(
                  onTap: () {
                    HttpRequest().deleteItem(
                        item.id ?? '', context.read<LoginCubit>().state.access);

                    Navigator.pop(context);
                  },
                  child: const Text('delete'),
                )
              ],
            );
          },
        );
      });
}
