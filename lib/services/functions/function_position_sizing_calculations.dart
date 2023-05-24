import 'package:my_tradebook/models/positions_model/position_model.dart';

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
    calculatedValues['targetAmount'] = targetAmount.toStringAsFixed(2);
  } else {
    double targetAmount = entryPrice - ((entryPrice * targetPercentage) / 100);
    calculatedValues['targetAmount'] = targetAmount.toStringAsFixed(2);
  }
  if (type == TradeType.buy) {
    double stoplossAmount =
        entryPrice - ((entryPrice * stoplossPercentage) / 100);
    calculatedValues['stoplossAmount'] = stoplossAmount.toStringAsFixed(2);
  } else {
    double stoplossAmount =
        entryPrice + ((entryPrice * stoplossPercentage) / 100);
    calculatedValues['stoplossAmount'] = stoplossAmount.toStringAsFixed(2);
  }

  calculatedValues['quantity'] =
      (targetAmt ~/ ((entryPrice * targetPercentage) / 100)).toString();

  return calculatedValues;
}
