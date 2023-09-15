import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/data/current_user_data.dart';
import 'package:trading_edge/functions/function_position_sizing_calculations.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/models/positions/position_model.dart';
import 'package:trading_edge/models/sizing/sizing_model.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/fund_page_viewmodel/fund_page_viewmodel.dart';
import 'package:trading_edge/view_model/position_sizing_viewmodel/position_sizing_viewmodel.dart';
import 'package:trading_edge/views/screens/home/pages/widgets/widget_trade_log_item.dart';
import 'package:trading_edge/views/widgets/widget_text_form_field.dart';

class WidgetPositionSizedItem extends StatelessWidget {
  final PositionModel position;
  WidgetPositionSizedItem({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: whiteColor,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  position.stockName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                PopupMenuButton<PopupItem>(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  splashRadius: 20,
                  onSelected: (PopupItem item) async {
                    if (item == PopupItem.delete) {
                      await context
                          .read<PositionSizingViewModel>()
                          .deletePosition(position.key);
                    } else {
                      updateStock(
                        context: context,
                        stockName: position.stockName,
                        entry: position.entryPrice.toString(),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<PopupItem>>[
                    const PopupMenuItem<PopupItem>(
                      value: PopupItem.edit,
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<PopupItem>(
                      value: PopupItem.delete,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 0),
            child: Selector<PositionSizingViewModel, SizingModel?>(
                selector: (p0, p1) => p1.sizingModel,
                builder: (BuildContext ctx, SizingModel? sizing, _) {
                  double? tarPer = sizing?.targetPercentage;
                  double? slPer = sizing?.stoplossPercentage;
                  double? targetAmt = sizing?.targetAmount;
                  Map<String, String> calculatedValues =
                      positionSizingCalculation(
                          type: position.type,
                          targetAmt: targetAmt!,
                          targetPercentage: tarPer!,
                          stoplossPercentage: slPer!,
                          entryPrice: position.entryPrice);
                  String? targetAmount = calculatedValues['targetAmount'];
                  String? stoplossAmount = calculatedValues['stoplossAmount'];
                  String? quantity = calculatedValues['quantity'];
                  return GridView.count(
                    childAspectRatio: 3.2,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      gridItemColumn(
                          title: 'Trade Type',
                          content: (position.type == TradeType.buy)
                              ? 'Buy'
                              : 'Sell'),
                      gridItemColumn(
                        title: 'Entry Price',
                        content: position.entryPrice.toString(),
                      ),
                      gridItemColumn(
                        title: 'Target',
                        content: targetAmount!,
                      ),
                      gridItemColumn(
                        title: 'Stoploss',
                        content: stoplossAmount!,
                      ),
                      gridItemColumn(
                        title: 'Quantity',
                        content: quantity!,
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget gridItemColumn({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey)),
        sizedBoxTen,
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: (content == 'Sell')
                ? Colors.red
                : (content == 'Buy')
                    ? Colors.green
                    : Colors.black,
          ),
        ),
      ],
    );
  }

  void updateStock({
    required BuildContext context,
    required String stockName,
    required String entry,
  }) {
    final formKey = GlobalKey<FormState>();
    TextEditingController stockNameController = TextEditingController();

    TextEditingController entryPriceController = TextEditingController();
    stockNameController.text = stockName;
    entryPriceController.text = entry;

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
                          Selector<PositionSizingViewModel, bool>(
                              selector: (p0, p1) => p1.switchValue,
                              builder: (context, switchValue, _) {
                                return Switch(
                                  activeColor: Colors.red,
                                  inactiveTrackColor:
                                      const Color.fromARGB(255, 119, 206, 122),
                                  inactiveThumbColor: Colors.green,
                                  value: switchValue,
                                  onChanged: (value) => context
                                      .read<PositionSizingViewModel>()
                                      .setSwitchValue(value),
                                );
                              }),
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
              "Update",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              TradeType type;
              if (context.read<PositionSizingViewModel>().switchValue) {
                type = TradeType.sell;
              } else {
                type = TradeType.buy;
              }
              if (formKey.currentState!.validate()) {
                // ignore: non_constant_identifier_names
                PositionModel updatedposition = PositionModel(
                    stockName: stockNameController.text.toUpperCase().trim(),
                    entryPrice: double.parse(entryPriceController.text),
                    type: type,
                    currentUserId: CurrentUserData.returnCurrentUserId());
                await context
                    .read<PositionSizingViewModel>()
                    .updatePosition(updatedposition, position.key);
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }
}