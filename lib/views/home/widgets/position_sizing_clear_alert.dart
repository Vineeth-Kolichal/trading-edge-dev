import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/services/position_sizing_services/position_services.dart';
import 'package:my_tradebook/views/widgets/widget_loading_alert.dart';

void positionSizingClearAlert(BuildContext context) {
    PositionServices positionServices = PositionServices();
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
                  side: const BorderSide(color: customPrimaryColor),
                ),
              ),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              await positionServices.clearPosition();
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