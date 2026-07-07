import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/section_header.dart';
import '../domain/wallet_models.dart';
import '../providers/wallet_providers.dart';
import 'topup_sheet.dart';
import 'withdraw_sheet.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _BalanceCard(balance: wallet.balance),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.add_rounded,
                  label: 'Top Up',
                  color: const Color(0xFF1F8A50),
                  onTap: () => showTopupSheet(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.north_east_rounded,
                  label: 'Withdraw',
                  color: const Color(0xFFC0392B),
                  onTap: () => showWithdrawSheet(context),
                ),
              ),
            ],
          ),
          const SectionHeader(title: 'Transaksi terkini'),
          for (var i = 0; i < wallet.txns.length; i++)
            _TxnTile(txn: wallet.txns[i])
                .animate()
                .fadeIn(delay: (40 * i).ms)
                .slideX(begin: 0.05),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C4DF6), Color(0xFF9B51E0)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Baki e-wallet',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const Spacer(),
              const Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatRm(balance),
            style: const TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_rounded, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text('DuitNow • FPX • GrabPay',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(label,
                  style:
                      TextStyle(color: color, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TxnTile extends StatelessWidget {
  final WalletTxn txn;
  const _TxnTile({required this.txn});

  @override
  Widget build(BuildContext context) {
    final incoming = txn.amount >= 0;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: txn.type.color.withValues(alpha: 0.15),
        child: Icon(txn.type.icon, color: txn.type.color),
      ),
      title: Text(txn.title,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${txn.method} • ${Formatters.relative(txn.time)}',
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        '${incoming ? '+' : '-'}${formatRm(txn.amount.abs())}',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: incoming ? const Color(0xFF1F8A50) : context.colors.onSurface,
        ),
      ),
    );
  }
}
