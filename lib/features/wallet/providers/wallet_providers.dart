import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wallet_mock.dart';
import '../domain/wallet_models.dart';

class WalletState {
  final double balance;
  final List<WalletTxn> txns;

  const WalletState({required this.balance, required this.txns});

  WalletState copyWith({double? balance, List<WalletTxn>? txns}) {
    return WalletState(
      balance: balance ?? this.balance,
      txns: txns ?? this.txns,
    );
  }
}

class WalletNotifier extends Notifier<WalletState> {
  @override
  WalletState build() =>
      WalletState(balance: kInitialBalance, txns: List.of(kMockTxns));

  String _id() => 'w${DateTime.now().microsecondsSinceEpoch}';

  void _record(WalletTxn txn) {
    state = state.copyWith(
      balance: state.balance + txn.amount,
      txns: [txn, ...state.txns],
    );
  }

  void topup(double amount, TopupMethod method, {String detail = ''}) {
    final label = detail.isEmpty ? method.label : '${method.label} • $detail';
    _record(WalletTxn(
      id: _id(),
      title: 'Top up wallet',
      amount: amount,
      type: TxnType.topup,
      method: label,
      time: DateTime.now(),
    ));
  }

  /// Returns false when the amount exceeds the balance (nothing recorded).
  bool withdraw(double amount, String bank, String accountNo) {
    if (amount > state.balance) return false;
    final masked =
        accountNo.length >= 4 ? accountNo.substring(accountNo.length - 4) : accountNo;
    _record(WalletTxn(
      id: _id(),
      title: 'Pengeluaran ke $bank',
      amount: -amount,
      type: TxnType.withdraw,
      method: '$bank •••• $masked',
      time: DateTime.now(),
    ));
    return true;
  }
}

final walletProvider =
    NotifierProvider<WalletNotifier, WalletState>(WalletNotifier.new);
