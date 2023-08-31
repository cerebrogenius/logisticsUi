import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_bloc_app/shipment/screens/account_screen/cubit/account_screen_cubit.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/cubit/login_cubit.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/login_screen.dart';
import 'package:my_bloc_app/shipment/utilities/widgets/widgets.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<LoginCubit>(context);
    return SafeArea(
      child: BlocListener<LoginCubit, LoginCubitState>(
        listener: (context, state) {
          if (state.isLoggedIn == false) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return const LoginPage();
            }), (route) => false);
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
                        state.user!.isActive == false
                            ? Expanded(
                                child: InkWell(
                                  onTap: () {
                                    final account =
                                        context.read<AccountScreenCubit>();
                                    account.checkStatus(
                                        accessToken: state.access);
                                    showAlert(context: context);
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: 5.w, left: 3.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 3,
                                        color: state.user!.isActive == false
                                            ? Colors.blue
                                            : Colors.green,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                    ),
                                    height: 40.h,
                                    child: const Center(
                                      child: Text(
                                        'Activate your account',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => user.logOut(user.state.access),
            child: const Icon(
              Icons.logout,
            ),
          ),
        ),
      ),
    );
  }
}

String formattedDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

showAlert({
  required BuildContext context,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            width: 400,
            child: BlocBuilder<AccountScreenCubit, AccountScreenState>(
              builder: (context, state) {
                if (state.accountstate == ConfirmState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.accountstate == ConfirmState.success) {
                  return const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 100,
                  );
                } else if (state.accountstate == ConfirmState.error) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0, left: 0),
                      child: Text(
                        state.response,
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      });
}
