import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_bloc_app/shipment/screens/welcome_page/bloc/welcome_page_bloc.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<WelcomePageBloc, WelcomePageState>(
          builder: (context, state) {
            return Stack(
              children: [
                PageView(
                  controller: controller,
                  onPageChanged: (page) {
                    BlocProvider.of<WelcomePageBloc>(context).add(
                      PageChangeEvent(page: page),
                    );
                  },
                  children: [
                    WelcomeWidget(
                      imagePath: 'image1new.svg',
                      message: 'Welcome To Our Logistics App',
                      buttonName: 'Next',
                      controller: controller,
                      index: 0,
                    ),
                    WelcomeWidget(
                      imagePath: 'newImage21.svg',
                      message: 'Easy Deliver Anywhere You Are',
                      buttonName: 'Next',
                      controller: controller,
                      index: 1,
                    ),
                    WelcomeWidget(
                      imagePath: 'image3new.svg',
                      message: 'Order At The Comfort Of Your Home',
                      buttonName: 'Get Started',
                      controller: controller,
                      index: 2,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WelcomeWidget extends StatelessWidget {
  final int index;
  final String imagePath;
  final String message;
  final String buttonName;
  final PageController controller;

  const WelcomeWidget({
    Key? key,
    required this.imagePath,
    required this.message,
    required this.buttonName,
    required this.controller,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 450.h,
          width: 300.h,
          child: SvgPicture.asset(
            fit: BoxFit.contain,
            height: 400.h,
            width: 300.w,
            'assets/svg/$imagePath',
          ),
        ),
        DotsIndicator(
          decorator: DotsDecorator(
            activeSize: Size.fromRadius(5.r),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          dotsCount: 3,
          position: index,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          onPressed: () {
            final bloc = BlocProvider.of<WelcomePageBloc>(context).state;
            if (bloc.page < 3) {
              controller.animateToPage(bloc.page++,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                'MainPage',
                (route) => false,
              );
            }
          },
          child: Text(
            buttonName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
