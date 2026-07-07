import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats a Ringgit amount, e.g. `RM 1,250.00`.
String formatRm(num value) =>
    NumberFormat.currency(symbol: 'RM ', decimalDigits: 2).format(value);

/// The kind of movement a wallet transaction represents. Drives the row icon
/// and colour, plus whether the amount reads as money in or out.
enum TxnType {
  topup(Icons.add_rounded, 'Top up', Color(0xFF1F8A50)),
  withdraw(Icons.north_east_rounded, 'Pengeluaran', Color(0xFFC0392B)),
  payment(Icons.shopping_bag_rounded, 'Bayaran', Color(0xFFEB5757)),
  transfer(Icons.swap_horiz_rounded, 'Pindahan', Color(0xFF2D9CDB)),
  refund(Icons.replay_rounded, 'Bayaran balik', Color(0xFF17A67B));

  final IconData icon;
  final String label;
  final Color color;
  const TxnType(this.icon, this.label, this.color);
}

/// How a top-up is funded.
enum TopupMethod {
  card(Icons.credit_card_rounded, 'Kad Kredit / Debit', Color(0xFF6C4DF6)),
  fpx(Icons.account_balance_rounded, 'FPX Online Banking', Color(0xFF17A67B)),
  grabpay(Icons.account_balance_wallet_rounded, 'GrabPay', Color(0xFF00B14F));

  final IconData icon;
  final String label;
  final Color color;
  const TopupMethod(this.icon, this.label, this.color);
}

class WalletTxn {
  final String id;
  final String title;

  /// Signed Ringgit amount: positive = money in, negative = money out.
  final double amount;
  final TxnType type;
  final String method;
  final DateTime time;

  const WalletTxn({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.method,
    required this.time,
  });
}

/// A bank shown in the FPX picker.
class Bank {
  final String name;
  final Color color;
  const Bank(this.name, this.color);

  String get initials {
    final parts = name.split(RegExp(r'\s+'));
    return (parts.length == 1
            ? parts.first.substring(0, 2)
            : parts.first[0] + parts[1][0])
        .toUpperCase();
  }
}

/// Malaysian banks available over FPX.
const List<Bank> kFpxBanks = [
  Bank('Maybank2u', Color(0xFFFFC20E)),
  Bank('CIMB Clicks', Color(0xFFED1C24)),
  Bank('Public Bank', Color(0xFFC8102E)),
  Bank('RHB Now', Color(0xFF0033A0)),
  Bank('Hong Leong Connect', Color(0xFF00539B)),
  Bank('AmBank', Color(0xFFED1B2E)),
  Bank('Bank Islam', Color(0xFF00563F)),
  Bank('Bank Rakyat', Color(0xFF005BAC)),
  Bank('BSN', Color(0xFF00A0DF)),
  Bank('Affin Bank', Color(0xFFF58220)),
  Bank('Alliance Bank', Color(0xFFED1C24)),
  Bank('UOB Bank', Color(0xFF005EB8)),
  Bank('OCBC Bank', Color(0xFFE01F26)),
  Bank('Standard Chartered', Color(0xFF0473EA)),
];
