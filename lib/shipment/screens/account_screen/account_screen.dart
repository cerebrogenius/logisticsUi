import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/cubit/login_cubit.dart';
import 'package:my_bloc_app/shipment/utilities/widgets/widgets.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<LoginCubit>(context);
    return SafeArea(
      child: BlocListener<LoginCubit, LoginCubitState>(
        listener: (context, state) {
          print('start1');
          if (state.isLoggedIn == false) {
            print('start2');
            Navigator.popAndPushNamed(context, 'LoginPage');
            print('start3');
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<LoginCubit, LoginCubitState>(
                  builder: (context, state) {
                    return Container(
                      alignment: Alignment.topLeft,
                      height: 130.h,
                      width: 500.w,
                      color: Colors.blue,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, top: 20.w),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30.r,
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: Text(
                                  user.state.user?.name ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              const Text(
                                'created at:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formattedDate(
                                  state.user?.created_at ?? DateTime.now(),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<LoginCubit, LoginCubitState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 4.h),
                          margin: EdgeInsets.only(
                            top: 3.h,
                            left: 3.w,
                          ),
                          height: 40.h,
                          width: 200.w,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          child: Center(
                            child: titleAndSub(
                                title: 'Email : ',
                                subTitle: state.user?.email ?? '',
                                color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          floatingActionButton: BlocBuilder<LoginCubit, LoginCubitState>(
            builder: (context, state) {
              return FloatingActionButton(
                onPressed: () async {
                  await context.read<LoginCubit>().logOut(state.access);
                },
                child: const Icon(
                  Icons.logout,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

String formattedDate(DateTime date) {
  return DateFormat.yMMMMd().format(date);
}
