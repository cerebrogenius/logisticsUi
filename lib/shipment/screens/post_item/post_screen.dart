import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/cubit/login_cubit.dart';
import 'package:my_bloc_app/shipment/screens/post_item/cubit/post_item_cubit.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';
import 'package:my_bloc_app/shipment/utilities/snack_bar.dart';
import 'package:my_bloc_app/shipment/utilities/widgets/widgets.dart';

import '../../models/item_model.dart';

class PostItemScreen extends StatelessWidget {
  const PostItemScreen({Key? key}) : super(key: key);
  static TextEditingController nameController =
      TextEditingController(text: 'system');
  static TextEditingController ownerController =
      TextEditingController(text: 'Shola');
  static TextEditingController emailController =
      TextEditingController(text: 'shola@gmail.com');
  static TextEditingController phoneController =
      TextEditingController(text: '08050664367');
  static TextEditingController noteController =
      TextEditingController(text: 'order created');


  @override
  Widget build(BuildContext context) {
    final post = BlocProvider.of<PostItemCubit>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              'Add Item',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DetailsForm(
            title: 'Product Name',
            controller: nameController,
            titleColor: Colors.blue,
          ),
          SizedBox(
            height: 10.h,
          ),
          DetailsForm(
            title: 'Owner Name',
            controller: ownerController,
            titleColor: Colors.blue,
          ),
          SizedBox(
            height: 10.h,
          ),
          DetailsForm(
            title: 'Email',
            controller: emailController,
            titleColor: Colors.blue,
          ),
          SizedBox(
            height: 10.h,
          ),
          DetailsForm(
            title: 'Phone Number',
            controller: phoneController,
            titleColor: Colors.blue,
          ),
          SizedBox(
            height: 10.h,
          ),
          DetailsForm(
            title: 'Note',
            controller: noteController,
            titleColor: Colors.blue,
          ),
          SizedBox(
            height: 10.h,
          ),
          Stack(
            children: [
              BlocBuilder<PostItemCubit, PostItemCubitState>(
                builder: (context, state) {
                  return DetailsForm(
                    title: 'Location',
                    hintText: state.postLocation,
                    titleColor: Colors.blue,
                    isClickAble: false,
                  );
                },
              ),
              Positioned(
                right: 32.w,
                bottom: 0.h,
                child: const DropDownLocation(),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Stack(
            children: [
              BlocBuilder<PostItemCubit, PostItemCubitState>(
                builder: (context, state) {
                  return DetailsForm(
                    title: 'Date',
                    hintText: formattedDate(
                      state.date ?? DateTime.now(),
                    ),
                    titleColor: Colors.blue,
                    isClickAble: false,
                  );
                },
              ),
              Positioned(
                right: 32.w,
                bottom: 0.h,
                child: IconButton(
                  onPressed: () async {
                    context.read<PostItemCubit>().updateDate(
                          newDate: await _showDate(context),
                        );
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Stack(
            children: [
              const DetailsForm(
                title: 'Status',
                titleColor: Colors.blue,
                isClickAble: false,
              ),
              Positioned(
                right: 32.w,
                bottom: 0.h,
                child: const DropDownStatus(),
              )
            ],
          ),
          TextButton(
            onPressed: () async {
              final detail = context.read<PostItemCubit>().state;
              final access = context.read<LoginCubit>().state;
              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  noteController.text.isEmpty ||
                  phoneController.text.isEmpty ||
                  ownerController.text.isEmpty ||
                  detail.date.toString().isEmpty) {
                MessageSnackBar().showMessage(
                    context: context,
                    message: 'Fields can\'t be empty,',
                    isError: true,
                    icon: Icons.error_outline);
                return;
              }

              final Items item = Items(
                name: nameController.text,
                note: noteController.text,
                phoneNumber: phoneController.text,
                date: detail.date ?? DateTime.now(),
                location: detail.postLocation,
                owner: ownerController.text,
                status: detail.currentStatus!,
                email: emailController.text,
              );
              post.postItem(item: item, accesstoken: access.access);

              nameController.clear();
              noteController.clear();
              phoneController.clear();
              ownerController.clear();
              emailController.clear();

              await showPostDialog(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

showPostDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext cotext) {
      return BlocBuilder<PostItemCubit, PostItemCubitState>(
        builder: (context, state) {
          if (state.postStatus == ItemStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.postStatus == ItemStatus.success) {
            return const AlertDialog(
              content: Text('Posted Successfully'),
            );
          } else if (state.postStatus == ItemStatus.error) {
            return const Text('error posting item');
          }
          return const SizedBox.shrink();
        },
      );
    },
  );
}

class DropDownStatus extends StatelessWidget {
  const DropDownStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostItemCubit, PostItemCubitState>(
      builder: (context, state) {
        return DropdownButton<String>(
          elevation: 10,
          value: state.currentStatus,
          onChanged: (value) {
            context.read<PostItemCubit>().changeStatus(currentStatus: value);
          },
          items: statusList.map(
            (
              String e,
            ) {
              return DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.blue),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}

Future<DateTime?> _showDate(BuildContext context) {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(3000),
  );
}

String formattedDate(DateTime date) {
  return DateFormat.yMMMMd().format(date);
}

class DropDownLocation extends StatelessWidget {
  const DropDownLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostItemCubit, PostItemCubitState>(
      builder: (context, state) {
        return DropdownButton<String>(
          elevation: 10,
          value: state.postLocation,
          onChanged: (value) {
            context.read<PostItemCubit>().updateLocation(location: value);
          },
          items: locationslist.map(
            (String e) {
              return DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.blue),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
