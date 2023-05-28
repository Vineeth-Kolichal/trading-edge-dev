import 'package:flutter/material.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/views/dashboard/widgets/current_balance.dart';
import 'package:my_tradebook/views/dashboard/widgets/profit_or_loss_section.dart';

class BalanceAndPnlSection extends StatelessWidget {
  const BalanceAndPnlSection({
    super.key,
    required this.pnlTitle,
    required int selectedIdex,
  }) : _selectedIdex = selectedIdex;

  final List<String> pnlTitle;
  final int _selectedIdex;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: whiteColor,
      borderRadius: BorderRadius.circular(13),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: 100,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const  SizedBox(
                height: 80,
                width: 130,
                child: CurrentBalance(),
              ),
              const VerticalDivider(
                width: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Colors.grey,
              ),
              ProfitOrLoss(pnlTitle: pnlTitle, selectedIdex: _selectedIdex),
            ],
          ),
        ),
      ),
    );
  }
}



