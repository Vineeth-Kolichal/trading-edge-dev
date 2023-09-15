import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/models/sizing/sizing_model.dart';
import 'package:trading_edge/view_model/home_screen_viewmodel/home_screen_viewmodel.dart';
import 'package:trading_edge/view_model/position_sizing_viewmodel/position_sizing_viewmodel.dart';
import 'package:trading_edge/views/screens/home/pages/widgets/utils/add_stck_dialoge.dart';
import 'package:trading_edge/views/screens/home/pages/widgets/utils/fund_input_bottomsheet.dart';
import 'package:trading_edge/views/screens/home/pages/widgets/utils/sizing_section_warning_dialoge.dart';

import '../screens/home/pages/page_add_update_trade_logs.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
     HomeScreenViewModel homeScreenViewModel =
        context.read<HomeScreenViewModel>();
    return Visibility(
      visible: context.watch<HomeScreenViewModel>().index != 0,
      child: FloatingActionButton(
        onPressed: () async {
          if (homeScreenViewModel.index == 1) {
            Get.to(PageAddUpdateTradeLog(operation: 'Add'),
                transition: Transition.leftToRight,
                duration: const Duration(milliseconds: 350));
          } else if (homeScreenViewModel.index == 2) {
            showFundInputBottomSheet(context);
          } else {
            await context.read<PositionSizingViewModel>().getSizingData();
            SizingModel sm =
                context.read<PositionSizingViewModel>().sizingModel!;

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
  }
}