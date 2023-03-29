import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/screens/home/pages/page_dashboard.dart';
import 'package:my_tradebook/screens/home/pages/page_fund.dart';
import 'package:my_tradebook/screens/home/pages/page_trades_log.dart';
import 'package:my_tradebook/widgets/widget_drawer.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int _selectedTabIndex = 0;

  final List _pages = const [
    PageDashboard(),
    PageTradesLog(),
    PageFund(),
  ];

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const Drawer(
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
          onPressed: () {
            if (_selectedTabIndex == 1) {
              showTradeLogInputBottomSheet();
            } else {
              showFundInputBottomSheet();
            }
          },
          child: const Icon(Icons.add),
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
              icon: FaIcon(FontAwesomeIcons.chartLine),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.moneyBillTrendUp),
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

  void showTradeLogInputBottomSheet() {
    showModalBottomSheet<void>(
      //useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      elevation: 4,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Trade',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                const Divider(),
                // DatePickerDialog(
                //     initialDate: DateTime.now(),
                //     firstDate: DateTime(2022),
                //     lastDate: DateTime(2024)),
                // textFormFieldWIdget(),
              ],
            ),
          ),
        );
      },
    );
  }

  void showFundInputBottomSheet() {
    showModalBottomSheet<void>(
      //useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      elevation: 4,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Fund',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                const Divider(),
                // DatePickerDialog(
                //     initialDate: DateTime.now(),
                //     firstDate: DateTime(2022),
                //     lastDate: DateTime(2024)),
                // textFormFieldWIdget(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget textFormFieldWIdget() {
    return SizedBox(
      width: 100,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextFormField(
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }
}
