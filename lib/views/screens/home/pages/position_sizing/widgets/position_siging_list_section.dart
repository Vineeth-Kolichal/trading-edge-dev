import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/models/positions/position_model.dart';
import 'package:trading_edge/view_model/position_sizing_viewmodel/position_sizing_viewmodel.dart';
import 'package:trading_edge/views/screens/home/pages/widgets/widget_position_sized_item.dart';
import 'package:trading_edge/views/widgets/widget_search_gif.dart';

class PositionSizingListSection extends StatelessWidget {
  const PositionSizingListSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        Expanded(
          child: Consumer<PositionSizingViewModel>(
            builder: (ctx, positionSizing, _) {
              if (positionSizing.positionList.isNotEmpty) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    PositionModel position =
                        positionSizing.positionList[index];
                    return WidgetPositionSizedItem(
                      position: position,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: positionSizing.positionList.length,
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
    );
  }
}