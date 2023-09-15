import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/view_model/position_sizing_viewmodel/position_sizing_viewmodel.dart';

import 'widgets/position_siging_list_section.dart';
import 'widgets/sizing_parameters_section.dart';

class PagePositionSizing extends StatelessWidget {
  const PagePositionSizing({super.key});

  @override
  Widget build(BuildContext context) {
    final psViewModel = context.read<PositionSizingViewModel>();
    psViewModel.getAllPositions(null);
    psViewModel.getSizingData();
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Stack(
        children: [PositionSizingListSection(), SizingParameterSection()],
      ),
    );
  }
}
