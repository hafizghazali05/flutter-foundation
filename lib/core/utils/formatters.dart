import 'package:intl/intl.dart';

import '../providers/currency_provider.dart';

/// Formatting helpers. [money] converts a USD base amount into the currently
/// selected [Currency] so the currency changer visibly updates every amount.
class Formatters {
  Formatters._();

  static String money(double usdAmount, Currency currency) {
    final converted = usdAmount * currency.rate;
    final decimals = currency.code == 'JPY' ? 0 : 2;
    return NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: decimals,
    ).format(converted);
  }

  static String compact(num value) => NumberFormat.compact().format(value);

  static String date(DateTime dt) => DateFormat('d MMM yyyy').format(dt);

  static String time(DateTime dt) => DateFormat('h:mm a').format(dt);

  /// Short relative label: "now", "5m", "3h", "2d", else a date.
  static String relative(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('d MMM').format(dt);
  }
}
