import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_app/shipment/screens/auth/cubit/auth_state_cubit.dart';
import 'package:my_bloc_app/shipment/screens/home_screen/home_screen.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/login_screen.dart';
import 'package:my_bloc_app/shipment/screens/welcome_page/welcome_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthStateCubit, AuthStatus>(builder: ((context, state) {
      switch (state) {
        case AuthStatus.authenticated:
          return const HomeScreen();
        case AuthStatus.unauthenticated:
          return WelcomePage();
        default:
          return const LoginPage();
      }
    }));
  }
}
