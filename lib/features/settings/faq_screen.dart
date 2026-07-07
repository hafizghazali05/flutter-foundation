import 'package:flutter/material.dart';

import '../../core/utils/extensions.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _faqs = [
    (
      'Apa itu Flutter Foundation?',
      'Ia satu template starter dengan struktur feature-first, Riverpod untuk '
          'state management, dan contoh modul (chat, email, charts, calendar) '
          'guna mock data.',
    ),
    (
      'Macam mana nak tukar tema?',
      'Pergi Settings → Dark mode. Toggle akan tukar seluruh app serta-merta '
          'sebab ThemeMode di-watch di peringkat root.',
    ),
    (
      'Data ni real ke?',
      'Tidak — semua guna mock data. Repository/provider direka supaya senang '
          'ditukar ke backend sebenar (REST/Firebase) nanti.',
    ),
    (
      'Boleh ke tambah currency baru?',
      'Boleh. Tambah entri dalam kCurrencies (currency_provider.dart) dengan '
          'kadar relatif kepada USD.',
    ),
    (
      'Macam mana 2FA berfungsi di sini?',
      'Skrin 2FA adalah template UI sahaja untuk tunjuk flow. Tiada verifikasi '
          'sebenar dilakukan.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ & Help')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final f in _faqs)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ExpansionTile(
                shape: const Border(),
                leading: Icon(Icons.help_outline_rounded,
                    color: context.colors.primary),
                title: Text(f.$1,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                childrenPadding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    f.$2,
                    style: TextStyle(
                        color: context.colors.onSurfaceVariant, height: 1.4),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
