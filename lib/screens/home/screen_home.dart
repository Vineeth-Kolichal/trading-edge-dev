import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/database/local_databse/db_functions/position_db_fuctions.dart';
import 'package:my_tradebook/database/local_databse/db_functions/sizing_fuction.dart';
import 'package:my_tradebook/database/local_databse/models/positions/position_model.dart';
import 'package:my_tradebook/database/local_databse/models/sizing/sizing_model.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/pages/page_add_trade_logs.dart';
import 'package:my_tradebook/screens/home/pages/page_dashboard.dart';
import 'package:my_tradebook/screens/home/pages/page_fund.dart';
import 'package:my_tradebook/screens/home/pages/page_position_sizing.dart';
import 'package:my_tradebook/screens/home/pages/page_trades_log.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_drawer.dart';
import 'package:my_tradebook/widgets/widget_loading_alert.dart';
import 'package:my_tradebook/widgets/widget_text_form_field.dart';
import 'package:toggle_switch/toggle_switch.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

enum ClearPopupItem { clear }

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final SwitchController controller = Get.put(SwitchController());
  final _formKey = GlobalKey<FormState>();
  static const IconData _candlestick_chart_rounded =
      IconData(0xf05c5, fontFamily: 'MaterialIcons');

  int _selectedTabIndex = 0;

  final List _pages = [
    PageDashboard(),
    PageTradesLog(),
    PageFund(),
    PagePositionSizing()
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
      //backgroundColor: customPrimaryColor[50],
      backgroundColor: const Color.fromARGB(255, 238, 238, 247),
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
              } else {
                scaffoldKey.currentState!.openDrawer();
              }
            },
          );
        }),
        backgroundColor: whiteColor,
        actions: (_selectedTabIndex == 3)
            ? [
                PopupMenuButton<ClearPopupItem>(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.1),
                      borderRadius: BorderRadius.circular(15)),
                  splashRadius: 20,
                  onSelected: (ClearPopupItem item) async {
                    openDialog(context);
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<ClearPopupItem>>[
                    const PopupMenuItem<ClearPopupItem>(
                      value: ClearPopupItem.clear,
                      child: Text(
                        'Clear All',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ]
            : null,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: Visibility(
        visible: (_selectedTabIndex != 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () async {
            if (_selectedTabIndex == 1) {
              Get.to(const PageAddTradeLog(),
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 350));
            } else if (_selectedTabIndex == 2) {
              showFundInputBottomSheet();
            } else {
              SizingModel sm = await returnCurrentUsersSizingData();
              if (sm.targetAmount == 0.0 &&
                  sm.targetPercentage == 0.0 &&
                  sm.stoplossPercentage == 0.0) {
                sizingSettingAlert('required sizing parameters');
              } else if (sm.stoplossPercentage == 0.0) {
                sizingSettingAlert('SL percentage');
              } else if (sm.targetAmount == 0.0) {
                sizingSettingAlert('Target amount');
              } else if (sm.targetPercentage == 0.0) {
                sizingSettingAlert('Target percentage');
              } else {
                // ignore: use_build_context_synchronously
                addStock(context);
              }
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: _pages[_selectedTabIndex],
    );
  }

//Sizing section values updation dialoge

  void sizingSettingAlert(String title) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        title: const Text('Warning!'),
        content: Text('Please add $title before adding new data '),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
            child: const Text("close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

//Position Sizing List Clear function

  void openDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        title: const Text('Confirm Clear'),
        content: const Text('Are you sure want to clear'),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              await clearPosition();
              // ignore: use_build_context_synchronously
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WidgetLoadingAlert(
                    duration: 2000,
                  );
                },
              );
              Get.back();
            },
          ),
        ],
      ),
    );
  }

//Add stock dialoge fuction, this function is called from floating action button

  void addStock(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController stockNameController = TextEditingController();

    TextEditingController entryPriceController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        content: SizedBox(
          height: 160,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widgetInputTextFormField(
                    label: 'Stock Name',
                    isEnabled: true,
                    controller: stockNameController,
                    width: MediaQuery.of(context).size.width * 0.91),
                sizedBoxTen,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widgetInputTextFormField(
                      label: 'Entry Price',
                      isEnabled: true,
                      controller: entryPriceController,
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          const Text(
                            'Buy',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                          Obx(
                            () => Switch(
                              activeColor: Colors.red,
                              inactiveTrackColor:
                                  const Color.fromARGB(255, 119, 206, 122),
                              inactiveThumbColor: Colors.green,
                              value: controller.switchValue.value,
                              onChanged: (value) =>
                                  controller.toggleSwitch(value),
                            ),
                          ),
                          const Text(
                            'Sell',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              TradeType type;
              if (controller.isEnabled) {
                type = TradeType.sell;
              } else {
                type = TradeType.buy;
              }
              if (formKey.currentState!.validate()) {
                PositionModel position = PositionModel(
                  currentUserId: returnCurrentUserId(),
                  stockName: stockNameController.text.toUpperCase().trim(),
                  entryPrice: double.parse(entryPriceController.text),
                  type: type,
                );
                await addPosition(position);
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }

//Bottom navigation Bar

  Widget get bottomNavigationBar {
    return BottomNavigationBar(
      backgroundColor: whiteColor,
      currentIndex: _selectedTabIndex,
      onTap: _changeIndex,
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
            _candlestick_chart_rounded,
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
  }

//Fund Add bottom sheet, this fuction is called from floating action buttom

  void showFundInputBottomSheet() {
    showModalBottomSheet<void>(
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
                                        borderSide: const BorderSide(
                                            color: Colors.grey)),
                                    labelText: 'Date',
                                    hintText: 'Select Date',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    suffixIcon: const Icon(
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
                                borderColor: const [Colors.grey],
                                minWidth: 90,
                                cornerRadius: 10.0,
                                activeBgColors: const [
                                  [Colors.green],
                                  [Colors.red]
                                ],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.white,
                                inactiveFgColor: Colors.black,
                                initialLabelIndex: 0,
                                totalSwitches: 2,
                                labels: const ['Deposit', 'Withdraw'],
                                radiusStyle: true,
                                onToggle: (index) {
                                  // print('switched to: $index');
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
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('Add'),
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

//common text field widget for add trade and add fund screen

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
                borderSide: const BorderSide(color: Colors.grey)),
            labelText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            suffixText: sufixItem,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}

//Getx state management used to manage the switch in the position sizing add postion dialoge
class SwitchController extends GetxController {
  RxBool switchValue = false.obs;
  void toggleSwitch(bool value) {
    switchValue.value = value;
  }

  bool get isEnabled => switchValue.value;
}
