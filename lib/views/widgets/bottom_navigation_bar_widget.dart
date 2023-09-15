import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/home_screen_viewmodel/home_screen_viewmodel.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<HomeScreenViewModel, int>(
        selector: (p0, p1) => p1.index,
        builder: (context, index, _) {
          return BottomNavigationBar(
            backgroundColor: whiteColor,
            currentIndex: index,
            onTap: (value) {
              context.read<HomeScreenViewModel>().changePage(value);
            },
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: const Color(0xFF648BF8),
            unselectedItemColor: const Color.fromARGB(255, 131, 129, 129),
            showUnselectedLabels: true,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  IconData(0xea39, fontFamily: 'MaterialIcons'),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  candlestickChartRounded,
                ),
                label: 'Trades Log',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.currency_rupee),
                label: 'Fund',
              ),
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.pieChart),
                label: 'Position Sizing',
              ),
            ],
          );
        });
  }
}