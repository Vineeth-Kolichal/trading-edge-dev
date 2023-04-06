import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/database/local_databse/db_functions/position_db_fuctions.dart';
import 'package:my_tradebook/database/local_databse/db_functions/sizing_fuction.dart';
import 'package:my_tradebook/database/local_databse/models/positions/position_model.dart';
import 'package:my_tradebook/database/local_databse/models/sizing/sizing_model.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_position_sized_item.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_search_gif.dart';
import 'package:my_tradebook/widgets/widget_text_form_field.dart';

class PagePositionSizing extends StatelessWidget {
  const PagePositionSizing({super.key});

  @override
  Widget build(BuildContext context) {
    refreshUi();
    getSizingData(returnCurrentUserId());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: positionNotifier,
                  builder: (BuildContext ctx, List<PositionModel> pos,
                      Widget? child) {
                    if (pos.isNotEmpty) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          PositionModel position = pos[index];
                          return WidgetPositionSizedItem(
                            position: position,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: pos.length,
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Center(
                            child: WidgetSearchGif(),
                          ),
                          Text('No position items found! 😧')
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0.5, color: const Color.fromARGB(255, 206, 205, 205)),
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 233, 230, 237),
                  Color.fromARGB(255, 204, 200, 210),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ValueListenableBuilder(
                valueListenable: sizingNotifier,
                builder: (BuildContext ctx, SizingModel? sm, Widget? child) {
                  String targetAmount = '₹${sm?.targetAmount}';
                  String target = '${sm?.targetPercentage}%';
                  String stop = '${sm?.stoplossPercentage}%';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Target Amount/Trade',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 80, 78, 78)),
                          ),
                          sizedBoxTen,
                          Text(
                            targetAmount,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Target(%)',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 80, 78, 78)),
                          ),
                          sizedBoxTen,
                          Text(
                            target,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'SL(%)',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 80, 78, 78),
                            ),
                          ),
                          sizedBoxTen,
                          Text(
                            stop,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setTargetAndStoploss();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void setTargetAndStoploss() {
    final formKey = GlobalKey<FormState>();
    TextEditingController targetAmountController = TextEditingController();
    TextEditingController targetPercentageController = TextEditingController();
    TextEditingController stopLossPercentageController =
        TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        content: SizedBox(
          height: 160,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widgetInputTextFormField(
                  type: TextInputType.number,
                  label: 'Target Amount',
                  isEnabled: true,
                  controller: targetAmountController,
                  width: 300,
                ),
                sizedBoxTen,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widgetInputTextFormField(
                      type: TextInputType.number,
                      label: 'Target(%)',
                      isEnabled: true,
                      controller: targetPercentageController,
                      width: 100,
                    ),
                    widgetInputTextFormField(
                      type: TextInputType.number,
                      label: 'SL(%)',
                      isEnabled: true,
                      controller: stopLossPercentageController,
                      width: 100,
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
                ),
              ),
            ),
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
            onPressed: () {
              if (formKey.currentState!.validate()) {
                SizingModel sm = SizingModel(
                  targetAmount: double.parse(
                    targetAmountController.text.trim(),
                  ),
                  targetPercentage: double.parse(
                    targetPercentageController.text.trim(),
                  ),
                  stoplossPercentage: double.parse(
                    stopLossPercentageController.text.trim(),
                  ),
                );
                addOrUpdateSizing(sizing: sm, key: returnCurrentUserId());
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }
}
