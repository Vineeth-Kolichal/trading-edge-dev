import 'package:flutter/material.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_appbar.dart';

class PageAboutTradeBokk extends StatelessWidget {
  const PageAboutTradeBokk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 247),
      appBar: const WidgetAppbar(title: 'About Tradebook'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              const Text(
                  '\t\t\tTradebook is a very useful app for traders that helps them to know about their cash flow in the stock market. The user can view and analyze their trades and determine whether they are currently in a loss or profit.'),
              const Divider(),
              const Text(
                'FAQ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              sizedBoxTen,
              const Text(
                "1. How 'My TradeBook' help to traders?",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              sizedBoxTen,
              const Text(
                  '\t\t\t Tradebook helps users understand their cash flow in the stock market, and users can write comments about the trades they have taken.'),
              sizedBoxTen,
              const Text(
                "2. Will user get report as pdf from this app?",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              sizedBoxTen,
              const Text(
                  '\t\t\t Currently, this feature is not available, but you will receive an update soon with this feature. Then, you will be able to download the report as a PDF.'),
              sizedBoxTen,
              const Text(
                "3. What is position sizing?",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              sizedBoxTen,
              const Text(
                  '\t\t\t In stock market trading, a "position" refers to the ownership status of a security (such as a stock, option, or future) in a traders portfolio. A trader can take a long or short position in a security, depending on their market outlook and trading strategy. Position sizing means setting a predefined target and stop-loss based on the profit that one expects from one trade and dividing the total trading capital according to the risk and reward that one expects to get from one trade.'),
              sizedBoxTen,
              const Text(
                "4. How position sizing help to users?",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              sizedBoxTen,
              const Text(
                  '\t\t\t Position sizing helps users stay profitable even if they have multiple losing trades.'),
            ],
          ),
        ),
      ),
    );
  }
}
