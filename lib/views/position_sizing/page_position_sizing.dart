import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/models/positions_model/position_model.dart';
import 'package:my_tradebook/models/sizing_model/sizing_model.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';
import 'package:my_tradebook/services/position_sizing_services/position_services.dart';
import 'package:my_tradebook/services/position_sizing_services/sizing_services.dart';
import 'package:my_tradebook/views/position_sizing/widgets/widget_position_sized_item.dart';
import 'package:my_tradebook/views/login/screen_login.dart';
import 'package:my_tradebook/views/widgets/widget_search_gif.dart';

import 'widgets/set_sl_target.dart';

class PagePositionSizing extends StatelessWidget {
  const PagePositionSizing({super.key});

  @override
  Widget build(BuildContext context) {
    PositionServices positionServices = PositionServices();
    SizingServices sizingServices = SizingServices();
    positionServices.refreshUi();
    sizingServices.getSizigData(
      key: returnCurrentUserId(),
    );
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
                      return SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetSearchGif(),
                              Text('No position items found! 😧')
                            ],
                          ),
                        ),
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
                  String targetAmount =
                      sm?.targetAmount == null ? '₹0' : '₹${sm?.targetAmount}';
                  String target = sm?.targetPercentage == null
                      ? '0%'
                      : '${sm?.targetPercentage}%';
                  String stop = sm?.stoplossPercentage == null
                      ? '0%'
                      : '${sm?.stoplossPercentage}%';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: const AutoSizeText(
                              overflow: TextOverflow.ellipsis,
                              presetFontSizes: [13.0, 12.0, 11.0, 8.0],
                              maxLines: 1,
                              'Target Amount/Trade ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 80, 78, 78)),
                            ),
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
                      const VerticalDivider(),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: const AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              presetFontSizes: [13.0, 12.0, 11.0, 8.0],
                              'Target(%) ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 80, 78, 78)),
                            ),
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
                      const VerticalDivider(),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: const AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              presetFontSizes: [13.0, 12.0, 11.0, 8.0],
                              'SL(%) ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 80, 78, 78),
                              ),
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


}
