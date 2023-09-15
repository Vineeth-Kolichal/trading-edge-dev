import 'package:trading_edge/database/firebase/dashbord_calculations/pnl_calculations.dart';
import 'package:trading_edge/database/firebase/dashbord_calculations/total_pnl_section.dart';

Future<double> percentageCalculations(int index) async {
  double currentBalance = await getCurrentBalance();
  double pnl = await totalPnlCalculations(index);
  double currentbalanceBeforeThePeriod = currentBalance - pnl;

  double pnlPercentage = ((pnl / currentbalanceBeforeThePeriod) * 100);

  return pnlPercentage;
}
