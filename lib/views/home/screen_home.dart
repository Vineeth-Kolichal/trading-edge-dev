import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/models/sizing_model/sizing_model.dart';
import 'package:my_tradebook/services/position_sizing_services/position_services.dart';
import 'package:my_tradebook/services/position_sizing_services/sizing_services.dart';
import 'package:my_tradebook/controllers/class_switch_controller.dart';
import 'package:my_tradebook/views/home/widgets/position_sizing_clear_alert.dart';
import 'package:my_tradebook/views/home/widgets/sizing_set_alert.dart';
import 'package:my_tradebook/views/trade_log_add_update_form/page_add_update_trade_logs.dart';
import 'package:my_tradebook/views/dashboard/screen_dashboard.dart';
import 'package:my_tradebook/views/fund/page_fund.dart';
import 'package:my_tradebook/views/position_sizing/page_position_sizing.dart';
import 'package:my_tradebook/views/trade_logs/page_trades_log.dart';
import 'package:my_tradebook/views/home/widgets/widget_bottom_navigation_bar.dart';
import 'package:my_tradebook/views/drawer/drawer.dart';
import 'widgets/add_or_withdraw_fund_bottom_sheet.dart';
import 'widgets/position_sizing_add_stock_alert.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

enum ClearPopupItem { clear }

HomeScreenController homeScreenController = Get.put(HomeScreenController());

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  final SwitchController controller = Get.put(SwitchController());

  final List _pages = [
    const PageDashboard(),
    PageTradesLog(),
    PageFund(),
    const PagePositionSizing()
  ];

  //bool _search = false;
  @override
  Widget build(BuildContext context) {
    PositionServices positionServices = PositionServices();
    SizingServices sizingServices = SizingServices();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 247),
      key: scaffoldKey,
      drawer: const Drawer(
        child: WidgetDrawer(),
      ),
      appBar: PreferredSize(
        preferredSize:const  Size.fromHeight(55),
        child: Obx(() {
          return AppBar(
            elevation: 0,
            centerTitle: true,
            title: homeScreenController.isSearchOpen.value
                ? TextFormField(
                    onChanged: (value) {
                      positionServices.refreshUi(query: value);
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      hintText: 'Search here...',
                    ),
                  )
                : Image.asset(
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
            actions: (homeScreenController.tabIndex.value == 3)
                ? [
                    homeScreenController.isSearchOpen.value
                        ? IconButton(
                            onPressed: () {
                              positionServices.refreshUi();
                              homeScreenController.serchOpen(true);
                              homeScreenController.isSearchOpen.value = false;
                            },
                            icon: const Icon(Icons.clear))
                        : IconButton(
                            onPressed: () {
                              homeScreenController.serchOpen(false);
                              homeScreenController.isSearchOpen.value = true;
                            },
                            icon: const Icon(Icons.search),
                          ),
                    PopupMenuButton<ClearPopupItem>(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 0.1),
                          borderRadius: BorderRadius.circular(15)),
                      splashRadius: 20,
                      onSelected: (ClearPopupItem item) async {
                        positionSizingClearAlert(context);
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
          );
        }),
      ),
      body: Obx(() => _pages[homeScreenController.tabIndex.value]),
      floatingActionButton: Obx(() {
        return Visibility(
          visible: (homeScreenController.tabIndex.value != 0) ? true : false,
          child: FloatingActionButton(
            onPressed: () async {
              if (homeScreenController.tabIndex.value == 1) {
                Get.to(PageAddUpdateTradeLog(operation: 'Add'),
                    transition: Transition.leftToRight,
                    duration: const Duration(milliseconds: 350));
              } else if (homeScreenController.tabIndex.value == 2) {
                showFundInputBottomSheet(context);
              } else {
                SizingModel sm =
                    await sizingServices.returnCurrentUserSizingData();
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
        );
      }),
      bottomNavigationBar: const WidgetBottomNavigationBar(),
    );
  }
}
