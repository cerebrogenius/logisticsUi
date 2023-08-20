import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_app/shipment/screens/account_screen/account_screen.dart';
import 'package:my_bloc_app/shipment/screens/home_screen/cubit/home_screen_cubit.dart';
import 'package:my_bloc_app/shipment/screens/login_screen/cubit/login_cubit.dart';
import 'package:my_bloc_app/shipment/screens/main_page.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState()  {
    final login = context.read<LoginCubit>();
    login.getUserDetails(login.state.access);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: PageView(
            onPageChanged: (value) {
              context.read<HomeScreenCubit>().pageChange(index: value);
            },
            controller: pageController,
            children: const [
              ShipmentMain(),
              AccountScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<HomeScreenCubit, HomeScreenCubitState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.index,
              selectedItemColor: indicatorBlue,
              onTap: (value) {
                final homeCubit = context.read<HomeScreenCubit>();
                homeCubit.pageChange(index: value);
                pageController.jumpToPage(value);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
              ],
            );
          },
        ),
      ),
    );
  }
}
