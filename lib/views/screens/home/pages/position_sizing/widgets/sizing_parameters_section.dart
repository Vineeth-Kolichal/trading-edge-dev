import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/models/sizing/sizing_model.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/position_sizing_viewmodel/position_sizing_viewmodel.dart';

import 'set_target_and_sl_dialoge.dart';

class SizingParameterSection extends StatelessWidget {
  const SizingParameterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Selector<PositionSizingViewModel, SizingModel?>(
          selector: (ctx, positionSizingViewModel) {
            return positionSizingViewModel.sizingModel;
          },
          builder: (BuildContext ctx, SizingModel? sm, _) {
            String targetAmount = '₹${sm?.targetAmount}';
            String target = '${sm?.targetPercentage}%';
            String stop = '${sm?.stoplossPercentage}%';
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
                    setTargetAndStoploss(context);
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}