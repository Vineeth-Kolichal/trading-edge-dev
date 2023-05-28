import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/views/intro/pages/page_one.dart';
import 'package:my_tradebook/views/intro/pages/page_two.dart';
import 'package:my_tradebook/views/login/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class ScreenIntro extends StatelessWidget {
  ScreenIntro({super.key});

  final _pageController = PageController(initialPage: 0);
  int pageNumer = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: _onPageChanged,
            controller: _pageController,
            children: const [PageOne(), PageTwo()],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: (pageNumer == 0) ? true : false,
                      child: SizedBox(
                        child: TextButton(
                          onPressed: () {
                            Get.offAll(const ScreenLogin());
                          },
                          child: const Text(
                            'Skip >>',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    (pageNumer == 0)
                        ? SizedBox(
                            height: 50,
                            width: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40))),
                                onPressed: () {
                                  _pageController.nextPage(
                                      duration:
                                          const Duration(microseconds: 300),
                                      curve: Curves.ease);
                                },
                                child: const Center(
                                    child: Icon(Icons.arrow_forward_ios))),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () async {
                              final SharedPreferences login =
                                  await SharedPreferences.getInstance();
                              await login.setBool('not_a_first_user', true);
                              Get.offAll(const ScreenLogin(),
                                  transition: Transition.leftToRight);
                            },
                            child: const Text('Get started'),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 52),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                  effect:
                      const SlideEffect(radius: 20, dotWidth: 8, dotHeight: 8),
                  controller: _pageController,
                  count: 2),
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int page) {
    pageNumer = page;
  }
}
