import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/data/services/current_user_data.dart';
import 'package:trading_edge/models/positions/position_model.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/position_sizing_viewmodel/position_sizing_viewmodel.dart';
import 'package:trading_edge/views/widgets/widget_text_form_field.dart';

void addStock(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  TextEditingController stockNameController = TextEditingController();

  TextEditingController entryPriceController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
                  type: TextInputType.name,
                  label: 'Stock Name',
                  isEnabled: true,
                  controller: stockNameController,
                  width: MediaQuery.of(context).size.width * 0.91),
              sizedBoxTen,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widgetInputTextFormField(
                    type: TextInputType.number,
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
                              color: greenTextColor),
                        ),
                        Selector<PositionSizingViewModel, bool>(
                            selector: (p0, p1) => p1.switchValue,
                            builder: (context, switchValue, _) {
                              return Switch(
                                activeColor: redTextColor,
                                inactiveTrackColor:
                                    const Color.fromARGB(255, 119, 206, 122),
                                inactiveThumbColor: greenTextColor,
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
                            color: redTextColor,
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: customPrimaryColor),
              ),
            ),
          ),
          child: const Text(
            "Confirm",
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
              PositionModel position = PositionModel(
                currentUserId: CurrentUserData.returnCurrentUserId(),
                stockName: stockNameController.text.toUpperCase().trim(),
                entryPrice: double.parse(entryPriceController.text),
                type: type,
              );
              context.read<PositionSizingViewModel>().addPosition(position);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}