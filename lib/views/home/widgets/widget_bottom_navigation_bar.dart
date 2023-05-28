import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/views/home/screen_home.dart';

const IconData candlestickChartRounded =
    IconData(0xf05c5, fontFamily: 'MaterialIcons');

class WidgetBottomNavigationBar extends StatelessWidget {
  const WidgetBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Obx(() {
      //homeScreenController.serchOpen(false);

      return BottomNavigationBar(
        backgroundColor: whiteColor,
        currentIndex: homeScreenController.tabIndex.value,
        onTap: (value) {
          homeScreenController.setIndex(value);
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
