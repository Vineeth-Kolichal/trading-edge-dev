import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:provider/provider.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/view_model/home_screen_viewmodel/home_screen_viewmodel.dart';
import 'package:trading_edge/view_model/position_sizing_viewmodel/position_sizing_viewmodel.dart';
import 'package:trading_edge/views/screens/home/pages/page_dashboard.dart';
import 'package:trading_edge/views/screens/home/pages/page_fund.dart';
import 'package:trading_edge/views/screens/home/pages/position_sizing_page/page_position_sizing.dart';
import 'package:trading_edge/views/screens/home/pages/page_trades_log.dart';
import 'package:trading_edge/views/widgets/bottom_navigation_bar_widget.dart';
import 'package:trading_edge/views/widgets/floating_action_button_widget.dart';
import 'package:trading_edge/views/drawer_view/drawer_view.dart';

import 'pages/utils/position_sizing_clear_dialoge.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();
final formKey = GlobalKey<FormState>();

EntryType fundType = EntryType.deposite;

enum ClearPopupItem { clear }

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final List pages = [
      const PageDashboard(),
      const PageTradesLog(),
      PageFund(),
      const PagePositionSizing()
    ];
    HomeScreenViewModel homeScreenViewModel =
        context.read<HomeScreenViewModel>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 247),
      key: scaffoldKey,
      drawer: const Drawer(
        child: WidgetDrawer(),
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Selector<HomeScreenViewModel, bool>(
          selector: (p0, p1) => p1.isSearch,
          builder: (context, value, child) {
            if (value) {
              return TextFormField(
                onChanged: (value) {
                  context
                      .read<PositionSizingViewModel>()
                      .getAllPositions(value);
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  hintText: 'Search here...',
                ),
              );
            } else {
              return Image.asset(
                'assets/images/my_trade_book.png',
                scale: 3,
              );
            }
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Iconsax.profile_circle,
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
        actions: [
          Consumer<HomeScreenViewModel>(builder: (context, viewModel, _) {
            return Visibility(
              visible: viewModel.index == 3,
              child: IconButton(
                  onPressed: () {
                    homeScreenViewModel.searchOpen();
                  },
                  icon: Icon(!viewModel.isSearch
                      ? Iconsax.search_normal_1
                      : Iconsax.close_square)),
            );
          }),
          Visibility(
            visible: context.watch<HomeScreenViewModel>().index == 3,
            child: PopupMenuButton<ClearPopupItem>(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.1),
                  borderRadius: BorderRadius.circular(15)),
              splashRadius: 20,
              onSelected: (ClearPopupItem item) async {
                positionSizingListClear(context);
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
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
      floatingActionButton: const FloatingActionButtonWidget(),
      body: Selector<HomeScreenViewModel, int>(
        selector: (p0, p1) => p1.index,
        builder: (context, value, child) => pages[value],
      ),
    );
  }
}
