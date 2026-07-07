import '../domain/wallet_models.dart';

/// Opening balance for the demo wallet (RM).
const double kInitialBalance = 1284.50;

final DateTime _now = DateTime.now();
DateTime _ago({int h = 0, int d = 0}) =>
    _now.subtract(Duration(hours: h, days: d));

/// Seed transaction history.
final List<WalletTxn> kMockTxns = [
  WalletTxn(
    id: 't1',
    title: 'Top up wallet',
    amount: 200,
    type: TxnType.topup,
    method: 'FPX • Maybank2u',
    time: _ago(h: 3),
  ),
  WalletTxn(
    id: 't2',
    title: 'Shopee Malaysia',
    amount: -89.90,
    type: TxnType.payment,
    method: 'Wallet',
    time: _ago(h: 9),
  ),
  WalletTxn(
    id: 't3',
    title: 'Grab ride',
    amount: -18.40,
    type: TxnType.payment,
    method: 'Wallet',
    time: _ago(d: 1),
  ),
  WalletTxn(
    id: 't4',
    title: 'Pindahan dari Aisyah',
    amount: 50,
    type: TxnType.transfer,
    method: 'DuitNow',
    time: _ago(d: 2),
  ),
  WalletTxn(
    id: 't5',
    title: 'Pengeluaran ke Maybank',
    amount: -300,
    type: TxnType.withdraw,
    method: 'Maybank •••• 8842',
    time: _ago(d: 3),
  ),
  WalletTxn(
    id: 't6',
    title: 'Bayaran balik Lazada',
    amount: 42.00,
    type: TxnType.refund,
    method: 'Wallet',
    time: _ago(d: 4),
  ),
];
