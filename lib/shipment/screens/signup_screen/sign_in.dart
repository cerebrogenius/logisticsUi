import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_bloc_app/shipment/screens/signup_screen/cubit/signIn_cubit.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';
import 'package:my_bloc_app/shipment/screens/signUp_screen_widgets.dart';
import 'package:my_bloc_app/shipment/utilities/snack_bar.dart';

import '../../utilities/widgets/widgets.dart';
import '../signUp_screen_widgets.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle,
                  size: 40,
                  color: indicatorBlue,
                ),
              ),
              Text(
                'Create Account!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(
                height: 35.h,
              ),
              DetailsForm(
                controller: nameController,
                title: 'Name',
                icon: Icons.person,
              ),
              SizedBox(
                height: 10.h,
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
                buttonName: 'Create',
                icon: Icons.arrow_right_alt,
                function: () async {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    MessageSnackBar().showMessage(
                      icon: Icons.error,
                      context: context,
                      message: 'Fields Can\'t Be Empty',
                      isError: true,
                    );

                    return;
                  }

                  showAlert(context);

                  context.read<SignInCubit>().createUser(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                  nameController.clear();
                  emailController.clear();
                  passwordController.clear();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: HaveAccount(
                  message: 'Already Have An Account?',
                  prompt: ' Login',
                  function: () async {
                    Navigator.of(context).pushNamed('LoginPage');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlert(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SizedBox(
          height: 100.h,
          width: 400.w,
          child: BlocBuilder<SignInCubit, SignInStates>(
            builder: (context, state) {
              if (state.signInState == SignInState.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.signInState == SignInState.success) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 60,
                    ),
                    Center(
                      child: Text(
                        state.error,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                );
              } else if (state.signInState == SignInState.error) {
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
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      );
    },
  );
}
