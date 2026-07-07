import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A selectable currency. [rate] is relative to USD (base = 1.0) so mock
/// amounts stored in USD can be converted on the fly.
class Currency {
  final String code;
  final String symbol;
  final String name;
  final String flag;
  final double rate;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.flag,
    required this.rate,
  });
}

const List<Currency> kCurrencies = [
  Currency(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit', flag: '🇲🇾', rate: 4.72),
  Currency(code: 'USD', symbol: r'$', name: 'US Dollar', flag: '🇺🇸', rate: 1.0),
  Currency(code: 'EUR', symbol: '€', name: 'Euro', flag: '🇪🇺', rate: 0.92),
  Currency(code: 'GBP', symbol: '£', name: 'British Pound', flag: '🇬🇧', rate: 0.79),
  Currency(code: 'SGD', symbol: r'S$', name: 'Singapore Dollar', flag: '🇸🇬', rate: 1.35),
  Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen', flag: '🇯🇵', rate: 157.2),
];

class CurrencyNotifier extends Notifier<Currency> {
  @override
  Currency build() => kCurrencies.first; // default MYR

  void select(Currency currency) => state = currency;
}

final currencyProvider =
    NotifierProvider<CurrencyNotifier, Currency>(CurrencyNotifier.new);
