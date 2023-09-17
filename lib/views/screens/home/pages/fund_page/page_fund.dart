import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/database/firebase/common_functions/trade_fund_collection_references.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/fund_page_viewmodel/fund_page_viewmodel.dart';
import 'package:trading_edge/views/screens/home/pages/fund_page/widgets/widget_fund_tile.dart';
import 'package:trading_edge/views/widgets/no_data_animation.dart';

class PageFund extends StatelessWidget {
  const PageFund({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<FundPageViewModel>().getAllTransactions();
      },
    );
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Consumer<FundPageViewModel>(
        builder: (context, fundViewModel, child) {
          if (fundViewModel.isLoading) {
            return const Center(
                child: SpinKitCircle(
              color: whiteColor,
              duration: Duration(milliseconds: 3000),
            ));
          } else {
            if (fundViewModel.allTrasaction.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NoDataAnimation(),
                    Text('No fund entries found! 😧')
                  ],
                ),
              );
            }
            return ListView.separated(
              itemBuilder: ((context, index) {
                return WidgetFundTile(
                  tradeOrFundModel: fundViewModel.allTrasaction[index],
                );
              }),
              separatorBuilder: (context, index) => sizedBoxTen,
              itemCount: fundViewModel.allTrasaction.length,
            );
          }
        },
      ),
    );
  }
}
