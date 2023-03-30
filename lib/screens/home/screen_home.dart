import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/pages/page_add_trade_logs.dart';
import 'package:my_tradebook/screens/home/pages/page_dashboard.dart';
import 'package:my_tradebook/screens/home/pages/page_fund.dart';
import 'package:my_tradebook/screens/home/pages/page_trades_log.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_drawer.dart';
import 'package:toggle_switch/toggle_switch.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final _formKey = GlobalKey<FormState>();
  static const IconData _candlestick_chart_rounded =
      IconData(0xf05c5, fontFamily: 'MaterialIcons');

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

  DateTime? _selectedDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 247),
      key: scaffoldKey,
      drawer: const Drawer(
        child: WidgetDrawer(),
      ),
      appBar: AppBar(
        elevation: 0,
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
        backgroundColor: whiteColor,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: Visibility(
        visible: (_selectedTabIndex != 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            if (_selectedTabIndex == 1) {
              Get.to(PageAddTradeLog(),
                  transition: Transition.zoom,
                  duration: Duration(milliseconds: 350));
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
    return BottomNavigationBar(
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
          icon: Icon(
            IconData(0xea39, fontFamily: 'MaterialIcons'),
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _candlestick_chart_rounded,
          ),
          label: 'Trades Log',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.currency_rupee),
          label: 'Fund',
        ),
      ],
    );
    // return BottomNavyBar(
    //   selectedIndex: _selectedTabIndex,
    //   onItemSelected: _changeIndex,
    //   // backgroundColor: Colors.grey,
    //   // type: BottomNavigationBarType.fixed,
    //   // selectedFontSize: 12,
    //   // unselectedFontSize: 12,
    //   // selectedItemColor: Colors.deepPurple,
    //   // unselectedItemColor: Colors.grey[500],
    //   // showUnselectedLabels: true,
    //   items: <BottomNavyBarItem>[
    //     BottomNavyBarItem(
    //         icon: Icon(IconData(0xea39, fontFamily: 'MaterialIcons')),
    //         title: Text('Dashboard'),
    //         activeColor: Colors.deepPurple),
    //     BottomNavyBarItem(
    //       icon: Icon(_candlestick_chart_rounded),
    //       title: Text('Trades Log'),
    //     ),
    //     BottomNavyBarItem(
    //       icon: Icon(Icons.currency_rupee),
    //       title: Text('Fund'),
    //     ),
    //   ],
    // );
  }

  void showFundInputBottomSheet() {
    showModalBottomSheet<void>(
      //useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      elevation: 1,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                final formatter =
                                    DateFormat.yMMMEd().format(picked);
                                setState(() {
                                  _selectedDate = picked;
                                  print(formatter);
                                  dateController.text = formatter;
                                });
                              }
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Fill details';
                                  }
                                  return null;
                                },
                                cursorColor: whiteColor,
                                enabled: false,
                                controller: dateController,
                                decoration: InputDecoration(
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    labelText: 'Date',
                                    hintText: 'Select Date',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    suffixIcon: Icon(
                                      Icons.calendar_month_outlined,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                          ),
                          sizedBoxTen,
                          Row(
                            children: [
                              ToggleSwitch(
                                minHeight: 43,
                                borderWidth: 0.75,
                                borderColor: [Colors.grey],
                                minWidth: 90,
                                cornerRadius: 10.0,
                                activeBgColors: [
                                  [Colors.green],
                                  [Colors.red]
                                ],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.white,
                                inactiveFgColor: Colors.black,
                                initialLabelIndex: 0,
                                totalSwitches: 2,
                                labels: ['Deposit', 'Withdraw'],
                                radiusStyle: true,
                                onToggle: (index) {
                                  print('switched to: $index');
                                },
                              ),
                            ],
                          ),
                          sizedBoxTen,
                          inputTextFormField(
                              isEnabled: true,
                              controller: amountController,
                              label: 'Amount'),
                          sizedBoxTen,
                        ],
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          dateController.clear();
                          amountController.clear();
                          Get.back();
                        }
                      },
                      child: Text('Add'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget inputTextFormField(
      {required bool isEnabled,
      String? label,
      String? sufixItem,
      required TextEditingController controller,
      TextInputType? type,
      String? hint}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Fill details';
          }
          return null;
        },
        keyboardType: type,
        enabled: isEnabled,
        controller: controller,
        decoration: InputDecoration(
            hintText: hint,
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey)),
            labelText: label,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            suffixText: sufixItem,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
