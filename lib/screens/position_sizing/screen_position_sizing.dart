import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
//import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/screens/position_sizing/widgets/widget_position_sized_item.dart';
import 'package:my_tradebook/widgets/widget_appbar.dart';
import 'package:my_tradebook/widgets/widget_text_form_field.dart';

class ScreenPositionSizing extends StatelessWidget {
  final SwitchController controller = Get.put(SwitchController());
  ScreenPositionSizing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 255),
      appBar: WidgetAppbar(title: 'Position Sizing'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addStock(context);
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return WidgetPositionSizedItem();
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 7,
                          );
                        },
                        itemCount: 20))
              ],
            ),
            Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.5, color: Color.fromARGB(255, 206, 205, 205)),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 233, 230, 237),
                      Color.fromARGB(255, 204, 200, 210),
                    ],
                  )),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Target Amount/Trade',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 80, 78, 78)),
                          ),
                          sizedBoxTen,
                          Text('1000',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Target(%)',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 80, 78, 78)),
                          ),
                          sizedBoxTen,
                          Text('0.5%',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('SL(%)',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 80, 78, 78),
                              )),
                          sizedBoxTen,
                          Text('0.3%',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            setTargetAndStoploss(context);
                          },
                          icon: Icon(Icons.edit))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setTargetAndStoploss(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController targetAmountController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        // title: const Text('Set Target & SL'),
        content: SizedBox(
          height: 160,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                inputTextFormField(
                    label: 'Target Amount',
                    isEnabled: true,
                    controller: targetAmountController,
                    width: MediaQuery.of(context).size.width * 0.91),
                sizedBoxTen,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    inputTextFormField(
                        label: 'Target(%)',
                        isEnabled: true,
                        controller: targetAmountController,
                        width: MediaQuery.of(context).size.width * 0.3),
                    inputTextFormField(
                        label: 'SL(%)',
                        isEnabled: true,
                        controller: targetAmountController,
                        width: MediaQuery.of(context).size.width * 0.3)
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print('Validated');
              }
            },
          ),
        ],
      ),
    );
  }

  void addStock(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController targetAmountController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        // title: const Text('Set Target & SL'),
        content: SizedBox(
          height: 160,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                inputTextFormField(
                    label: 'Stock Name',
                    isEnabled: true,
                    controller: targetAmountController,
                    width: MediaQuery.of(context).size.width * 0.91),
                sizedBoxTen,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    inputTextFormField(
                      label: 'Entry Price',
                      isEnabled: true,
                      controller: targetAmountController,
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text(
                            'Buy',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Obx(
                            () => Switch(
                              activeColor: Colors.red,
                              inactiveTrackColor: Colors.green,
                              inactiveThumbColor: Colors.green,
                              value: controller.switchValue.value,
                              onChanged: (value) =>
                                  controller.toggleSwitch(value),
                            ),
                          ),
                          Text('Sell'),
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
            onPressed: () {
              if (controller.isEnabled) {
                print('hi');
              } else {
                print('hello');
              }
              if (_formKey.currentState!.validate()) {
                print('Validated');
              }
            },
          ),
        ],
      ),
    );
  }
}

class SwitchController extends GetxController {
  RxBool switchValue = false.obs;

  void toggleSwitch(bool value) {
    switchValue.value = value;
  }

  bool get isEnabled => switchValue.value;
}
