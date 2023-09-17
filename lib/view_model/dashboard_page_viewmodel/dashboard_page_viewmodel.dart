
import 'package:flutter/material.dart';
import 'package:trading_edge/data/repositories/trade_or_fund_repo/trade_or_fund_repo.dart';
import 'package:trading_edge/data/services/trade_fund_services/trade_fund_services.dart';
import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';
import 'package:trading_edge/utils/constants/const_values.dart';

class DashboardPageViewModel extends ChangeNotifier {
  ///This viewmodel class is responsible for handle the dashboard states
  ///in dashboard data is categorized into 4 that is controlled by choice chips
  ///[selctedIndex] state is for showing which choice chip is selected currently
  ///the states [currentBalance],[pnl],[percentage] are the states in the balance
  ///and pnl section in the dashboard page.
  ///
 
  TradeOrFundRepository tradeOrFundRepository = TradeFundServices();
  int selctedIndex = 0;
  double currentBalance = 0.0;
  double pnl = 0.0;
  double percentage = 0.0;
  List<TradeOrFundModel> _transactionList = [];
  List<Map<String, dynamic>> barChartData = [];
  Map<String, int> pieChartData = {};
  Future<void> selectChoiceChip(int index) async {
    selctedIndex = index;
    notifyListeners();
    await _findTotalPnl(index);
    _percentageCalculations();
  }

  Future<void> calculateCurrentBalance() async {
    selctedIndex = 0;
    double sum = 0;
    _transactionList = await tradeOrFundRepository.getTransactions();
    for (final TradeOrFundModel transaction in _transactionList) {
      final double value = transaction.amount;
      if (transaction.type == EntryType.loss ||
          transaction.type == EntryType.withdraw) {
        sum += (value * -1);
      } else {
        sum += value;
      }
    }
    currentBalance = sum;
    notifyListeners();
    setBarGraphData();
    setPieGraphValues(selctedIndex);
  }

  Future<void> _findTotalPnl(int index) async {
    //Current day date
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int startMonth = 4;
    int endMonth = 3;
    int startYear = (currentMonth < startMonth) ? now.year - 1 : now.year;
    int endYear = (currentMonth > endMonth) ? now.year + 1 : now.year;
    int yearOffset = (currentMonth >= startMonth) ? 0 : -1;
    int currentQuarter =
        ((currentMonth - startMonth + yearOffset) / 3).floor() + 1;
    //last day date
    DateTime lastDay = DateTime.now().subtract(const Duration(days: 2));

    //This week dates
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    // this quarter date calculation
    DateTime startOfQuarter =
        DateTime(startYear, startMonth + (currentQuarter - 1) * 3, 1);
    DateTime endOfQuarter =
        DateTime(endYear, startMonth + currentQuarter * 3, 0);
    //this financila year date calculation
    int currentYear = now.year;
    int startYear2 = (now.month >= 4) ? currentYear : currentYear - 1;
    int endYear2 = startYear + 1;
    DateTime startOfYear = DateTime(startYear2, 4, 1);
    DateTime endOfYear = DateTime(endYear2, 3, 31);

    if (index == 0) {
      await _calculateTotalPnL(lastDay, now);
    } else if (index == 1) {
      await _calculateTotalPnL(startOfWeek, endOfWeek);
    } else if (index == 2) {
      await _calculateTotalPnL(startOfQuarter, endOfQuarter);
    } else {
      await _calculateTotalPnL(startOfYear, endOfYear);
    }
  }

  Future<void> _calculateTotalPnL(DateTime start, DateTime end) async {
    double totalPnl = 0.0;
    // List<TradeOrFundModel> _transactionList =
    //     await tradeOrFundRepository.getTransactions();
    for (var transaction in _transactionList) {
      if ((transaction.date.isAfter(start) && transaction.date.isBefore(end)) &&
          (transaction.type == EntryType.profit ||
              transaction.type == EntryType.loss)) {
        if (transaction.type == EntryType.profit) {
          totalPnl = totalPnl + transaction.amount;
        } else {
          totalPnl = totalPnl + (-1 * transaction.amount);
        }
      }
    }
    pnl = totalPnl;
  }

  Future<void> _percentageCalculations() async {
    double currentbalanceBeforeThePeriod = currentBalance - pnl;
    percentage = ((pnl / currentbalanceBeforeThePeriod) * 100);
    notifyListeners();
  }

  Future<void> setBarGraphData() async {
    List<Map<String, dynamic>> barChartData = [];
    List displayAmountList = List.generate(10, (index) => null);

    List<double> totalAmountList = _lastTenWeeksData();
    double tenWeekTotal = 0.0;
    for (var x = 0; x < totalAmountList.length; x++) {
      tenWeekTotal = tenWeekTotal + totalAmountList[x];
    }

    double balanceBeforeTenWeek = currentBalance - tenWeekTotal;
    double prevWeekAmt = 0.0;
    for (var i = 0; i < totalAmountList.length; i++) {
      if (i == 0) {
        displayAmountList[i] = totalAmountList[i] + balanceBeforeTenWeek;
        prevWeekAmt = displayAmountList[i];
      } else {
        if (totalAmountList[i] == 0.0) {
          displayAmountList[i] = 0.0;
        } else {
          displayAmountList[i] = prevWeekAmt + totalAmountList[i];
          prevWeekAmt = displayAmountList[i];
        }
      }
    }

    for (int a = 1; a <= 10; a++) {
      if (a == 0) {
        barChartData.add(
          {'domain': 0.toString(), 'measure': balanceBeforeTenWeek},
        );
      } else {
        barChartData.add(
          {'domain': 'Week$a', 'measure': displayAmountList[a - 1]},
        );
      }
    }
    this.barChartData = barChartData;
    notifyListeners();
  }

  List<double> _lastTenWeeksData() {
    List<double> amountList = [];
    DateTime now = DateTime.now();
    for (int i = 1; i <= 10; i++) {
      double amount = 0.0;
      DateTime startOfWeek = now
          .subtract(Duration(days: now.weekday - DateTime.sunday))
          .subtract(Duration(days: i * 7));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
      for (var transaction in _transactionList) {
        if ((transaction.date.isAfter(startOfWeek) &&
            transaction.date.isBefore(endOfWeek))) {
          if (transaction.type == EntryType.profit ||
              transaction.type == EntryType.deposite) {
            amount = amount + transaction.amount;
          } else {
            amount = amount + (-1 * transaction.amount);
          }
        }
      }

      amountList.add(amount);
    }
    return amountList;
  }

  void setPieGraphValues(int index) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int startMonth = 4;
    int endMonth = 3;
    int startYear = (currentMonth < startMonth) ? now.year - 1 : now.year;
    int endYear = (currentMonth > endMonth) ? now.year + 1 : now.year;
    int yearOffset = (currentMonth >= startMonth) ? 0 : -1;
    int currentQuarter =
        ((currentMonth - startMonth + yearOffset) / 3).floor() + 1;
    //last day date
    DateTime lastDay = DateTime.now().subtract(const Duration(days: 2));

    //This week dates
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    // this quarter date calculation
    DateTime startOfQuarter =
        DateTime(startYear, startMonth + (currentQuarter - 1) * 3, 1);
    DateTime endOfQuarter =
        DateTime(endYear, startMonth + currentQuarter * 3, 0);
    //this financila year date calculation
    int currentYear = now.year;
    int startYear2 = (now.month >= 4) ? currentYear : currentYear - 1;
    int endYear2 = startYear + 1;
    DateTime startOfYear = DateTime(startYear2, 4, 1);
    DateTime endOfYear = DateTime(endYear2, 3, 31);

    if (index == 0) {
      _filterDataForPieGraph(lastDay, now);
    } else if (index == 1) {
      _filterDataForPieGraph(startOfWeek, endOfWeek);
    } else if (index == 2) {
      _filterDataForPieGraph(startOfQuarter, endOfQuarter);
    } else {
      _filterDataForPieGraph(startOfYear, endOfYear);
    }
  }

//this fuction is used to calculate percentage
  int percentageCalc({required int total, required int value}) {
    return ((value / total) * 100).round();
  }

//this function is return the data to be put the map for the pie graph
  void _putPieGraphpercentages(List<TradeOrFundModel> transactionList) {
    int totalIntraProfit = 0;
    int totalIntraLoss = 0;
    int totalSwingProfit = 0;
    int totalSwingLoss = 0;

    for (var x in transactionList) {
      if (x.type == EntryType.profit || x.type == EntryType.loss) {
        totalSwingProfit += x.swingProfit as int;
        totalSwingLoss += x.swingLoss as int;
        totalIntraProfit += x.intraProfit as int;
        totalIntraLoss += x.intraLoss as int;
      }
    }
    var totalTrades =
        totalSwingLoss + totalSwingProfit + totalIntraLoss + totalIntraProfit;
    Map<String, int> pieData = {
      'Profit-swing':
          percentageCalc(total: totalTrades, value: totalSwingProfit),
      'Loss-swing': percentageCalc(total: totalTrades, value: totalSwingLoss),
      'Profit-intraday':
          percentageCalc(total: totalTrades, value: totalIntraProfit),
      'Loss-intraday': percentageCalc(total: totalTrades, value: totalIntraLoss)
    };
    pieChartData = pieData;
    notifyListeners();
  }

  void _filterDataForPieGraph(DateTime start, DateTime end) {
    List<TradeOrFundModel> filtered = [];
    // List<TradeOrFundModel> _transactionList =
    //     await tradeOrFundRepository.getTransactions();
    for (var transaction in _transactionList) {
      if ((transaction.date.isAfter(start) && transaction.date.isBefore(end)) &&
          (transaction.type == EntryType.profit ||
              transaction.type == EntryType.loss)) {
        filtered.add(transaction);
      }
    }
    _putPieGraphpercentages(filtered);
  }
}
