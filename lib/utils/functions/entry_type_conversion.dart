import 'package:trading_edge/utils/constants/const_values.dart';

String entryTypeConvertToString({required EntryType type}) {
  if (type == EntryType.profit) {
    return 'profit';
  }
  if (type == EntryType.loss) {
    return 'loss';
  }
  if (type == EntryType.deposite) {
    return 'deposite';
  }
  if (type == EntryType.withdraw) {
    return 'withdraw';
  }
  return '';
}