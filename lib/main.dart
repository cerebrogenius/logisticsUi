import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/cubit/login_cubit.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/login_screen.dart';
import 'package:my_bloc_app/shipment/screens/main_page.dart';
import 'package:my_bloc_app/shipment/screens/signup_screen/cubit/signIn_cubit.dart';
import 'package:my_bloc_app/shipment/screens/signup_screen/sign_in.dart';
import 'package:my_bloc_app/shipment/screens/welcome_page/bloc/welcome_page_bloc.dart';
import 'package:my_bloc_app/shipment/screens/welcome_page/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => WelcomePageBloc(),
      child: ScreenUtilInit(
        designSize: const Size(360, 592),
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SignInCubit(),
              ),
              BlocProvider(create: ((context) => LoginCubit()))],
            child: MaterialApp(
              routes: {
                'ShipmentMain': (context) => const ShipmentMain(),
                'MainPage': (context) => SignUpPage(),
                'LoginPage': (context) => const LoginPage()
              },
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: WelcomePage(),
            ),
          );
        },
      ),
    );
  }
}
