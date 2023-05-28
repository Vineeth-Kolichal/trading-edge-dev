import 'package:auto_size_text/auto_size_text.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/services/firebase/dashbord_calculations/total_pnl_section.dart';
import 'package:my_tradebook/views/login/screen_login.dart';

class CurrentBalance extends StatelessWidget {
  const CurrentBalance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //  mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AutoSizeText(
          'Current Balance',
          maxLines: 1,
        ),
        sizedBoxTen,
        FutureBuilder(
            future: getCurrentBalance(),
            builder: (BuildContext context,
                AsyncSnapshot<double>
                    currentBalancesnapshot) {
              if (currentBalancesnapshot.data == null) {
                return const SizedBox(
                  width: 100,
                  height: 20,
                  child: FadeShimmer(
                    millisecondsDelay: 10,
                    height: 20,
                    width: 150,
                    radius: 4,
                    highlightColor: Color(0xffF9F9FB),
                    baseColor: Color(0xffE6E8EB),
                  ),
                );
              }
              double currentBalance =
                  currentBalancesnapshot.data!;

              return Tooltip(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                waitDuration:
                    const Duration(milliseconds: 100),
                showDuration:
                    const Duration(milliseconds: 5000),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 0.4),
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      whiteColor,
                      Color.fromARGB(255, 238, 238, 247),
                    ],
                  ),
                ),
                message: "₹ $currentBalance",
                child: AutoSizeText(
                  '₹$currentBalance',
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                  maxLines: 1,
                ),
              );
            }),
      ],
    );
  }
}
