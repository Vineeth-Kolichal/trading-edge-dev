import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_tradebook/screens/home/pages/page_dashboard.dart';
import 'package:my_tradebook/widgets/widget_drawer.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class ScreenHome extends StatefulWidget {
  ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int _selectedTabIndex = 0;

  List _pages = [
    PageDashboard(),
    Text("Order"),
    Text("Notfication"),
  ];

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
      print("index..." + index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: WidgetDrawer(),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/my_trade_book.png',
          scale: 3,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              FontAwesomeIcons.user,
            ),
            onPressed: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
                //close drawer, if drawer is open
              } else {
                scaffoldKey.currentState!.openDrawer();
                //open drawer, if drawer is closed
              }
            },
          );
        }),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: Visibility(
        visible: (_selectedTabIndex != 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
      body: _pages[_selectedTabIndex],
    );
  }

  Widget get bottomNavigationBar {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: _changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey[500],
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chartLine),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.moneyBillTrendUp),
              label: 'Trades Log',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_rupee),
              label: 'Fund',
            ),
          ],
        ),
      ),
    );
  }
}
