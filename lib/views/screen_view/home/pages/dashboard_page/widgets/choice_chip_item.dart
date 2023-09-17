import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/view_model/dashboard_page_viewmodel/dashboard_page_viewmodel.dart';

class ChoiceChipItem extends StatelessWidget {
  const ChoiceChipItem({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Selector<DashboardPageViewModel, int>(
          selector: (p0, p1) => p1.selctedIndex,
          builder: (context, sectedIndex, _) {
            return ChoiceChip(
              pressElevation: 0,
              elevation: 0,
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              label: AutoSizeText(choiceChipNameList[index],
                  maxLines: 1,
                  style: TextStyle(
                      color: (sectedIndex == index)
                          ? Colors.white
                          : Colors.black)),
              selected: sectedIndex == index,
              selectedColor: customPrimaryColor,
              onSelected: (value) {
                context.read<DashboardPageViewModel>().selectChoiceChip(index);
              },
            );
          }),
    );
  }
}
