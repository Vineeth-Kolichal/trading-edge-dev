import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/utils/constants/colors.dart';
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
                  Iconsax.status_up,
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.chart_1,
                ),
                label: 'Trades Log',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.dollar_square),
                label: 'Fund',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.graph),
                label: 'Position Sizing',
              ),
            ],
          );
        });
  }
}
