String shortenNumber(double num) {
  if (num >= 0.0) {
    if (num >= 10000 && num < 1000000) {
      return '₹ ${(num / 1000).toStringAsFixed(0)} K';
    } else if (num >= 1000000) {
      return '₹ ${(num / 1000000).toStringAsFixed(0)} M';
    } else {
      return '₹ $num';
    }
  } else {
    if (num <= -10000 && num > -1000000) {
      return '₹${(num * (-1) / 1000).toStringAsFixed(0)} K';
    } else if (num <= -1000000) {
      return '₹${(num * (-1) / 1000000).toStringAsFixed(0)} M';
    } else {
      return '₹${num * (-1)} K';
    }
  }
}
