import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/cubit/login_cubit.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';
import 'package:my_bloc_app/shipment/screens/signUp_screen_widgets.dart';
import 'package:my_bloc_app/shipment/utilities/snack_bar.dart';

import '../signUp_screen_widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.login,
                size: 40,
                color: indicatorBlue,
              ),
            ),
            Text(
              'Welcome!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
            DetailsForm(
                controller: emailController,
                title: 'Email',
                icon: Icons.email_rounded),
            SizedBox(
              height: 10.h,
            ),
            DetailsForm(
                controller: passwordController,
                title: 'PassWord',
                icon: Icons.lock_rounded),
            SizedBox(
              height: 10.h,
            ),
            CustomButton(
                buttonName: 'Login',
                icon: Icons.login,
                function: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    MessageSnackBar().showMessage(
                      icon: Icons.error,
                      context: context,
                      message: 'Fields Can\'t Be Empty',
                      isError: true,
                    );

                    return;
                  }
                  showAlert(context: context);
                  final login = context.read<LoginCubit>();
                  final token = await login.loginUser(
                      email: emailController.text,
                      password: passwordController.text);

                  emailController.clear();
                  passwordController.clear();
                  if (login.state.error == '') {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'HomeScreen', (route) => false);
                  }
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HaveAccount(
                message: 'Don\'t have an account?',
                prompt: ' Create',
                function: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

showAlert({required BuildContext context}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            width: 400,
            child: BlocBuilder<LoginCubit, LoginCubitState>(
              builder: (context, state) {
                if (state.loginState == LoginStates.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.loginState == LoginStates.success) {
                  return const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 100,
                  );
                } else if (state.loginState == LoginStates.error) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0, left: 0),
                      child: Text(
                        state.error,
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
