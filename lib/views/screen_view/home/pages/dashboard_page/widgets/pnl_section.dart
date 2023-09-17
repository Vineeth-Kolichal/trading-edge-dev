import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/utils/functions/function_short_amount.dart';
import 'package:trading_edge/view_model/dashboard_page_viewmodel/dashboard_page_viewmodel.dart';

class PnLDetailsSection extends StatelessWidget {
  const PnLDetailsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DashboardPageViewModel>().calculateCurrentBalance();
    });
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: 100,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 80,
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AutoSizeText(
                      'Current Balance',
                      maxLines: 1,
                    ),
                    sizedBoxTen,
                    Selector<DashboardPageViewModel, double>(
                        selector: (p0, p1) => p1.currentBalance,
                        builder: (context, value, child) {
                        

                          return Tooltip(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            waitDuration: const Duration(milliseconds: 100),
                            showDuration: const Duration(milliseconds: 5000),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.4),
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
                            message: "₹ $value",
                            child: AutoSizeText(
                              '₹$value',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w700),
                              maxLines: 1,
                            ),
                          );
                        }),
                  ],
                ),
              ),
              const VerticalDivider(
                width: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 100,
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Selector<DashboardPageViewModel, int>(
                        selector: (p0, p1) => p1.selctedIndex,
                        builder: (context, selctedIndex, _) {
                          return AutoSizeText(
                              maxLines: 1, pnlTitle[selctedIndex]);
                        }),
                    sizedBoxTen,
                    Selector<DashboardPageViewModel, double>(
                        selector: (p0, p1) => p1.pnl,
                        builder: (context, pnl, child) {
                          return Tooltip(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            waitDuration: const Duration(milliseconds: 100),
                            showDuration: const Duration(milliseconds: 5000),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.4),
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
                            message: "$pnl",
                            child: (pnl >= 0)
                                ? AutoSizeText(
                                    maxLines: 1,
                                    '+${shortenNumber(pnl)}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: greenTextColor),
                                  )
                                : AutoSizeText(
                                    maxLines: 1,
                                    '-${shortenNumber(pnl)}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: redTextColor),
                                  ),
                          );
                        }),
                    Selector<DashboardPageViewModel, double>(
                        selector: (p0, p1) => p1.percentage,
                        builder: (context, percentage, _) {
                          return Text(
                            "${percentage.toStringAsFixed(2)}%",
                            style: TextStyle(
                                color: (percentage < 0.0
                                    ? redTextColor
                                    : greenTextColor)),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
