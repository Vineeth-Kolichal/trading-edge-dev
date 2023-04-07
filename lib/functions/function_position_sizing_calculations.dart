import 'package:my_tradebook/database/local_databse/models/positions/position_model.dart';

Map<String, String> positionSizingCalculation({
  required TradeType type,
  required double targetAmt,
  required double targetPercentage,
  required double stoplossPercentage,
  required double entryPrice,
}) {
  Map<String, String> calculatedValues = {};
  if (type == TradeType.buy) {
    double targetAmount = entryPrice + ((entryPrice * targetPercentage) / 100);
    calculatedValues['targetAmount'] = targetAmount.toString();
  } else {
    double targetAmount = entryPrice - ((entryPrice * targetPercentage) / 100);
    calculatedValues['targetAmount'] = targetAmount.toString();
  }
  if (type == TradeType.buy) {
    double stoplossAmount =
        entryPrice - ((entryPrice * stoplossPercentage) / 100);
    calculatedValues['stoplossAmount'] = stoplossAmount.toString();
  } else {
    double stoplossAmount =
        entryPrice + ((entryPrice * stoplossPercentage) / 100);
    calculatedValues['stoplossAmount'] = stoplossAmount.toString();
  }

  calculatedValues['quantity'] =
      (targetAmt ~/ ((entryPrice * targetPercentage) / 100)).toString();

  return calculatedValues;
}
