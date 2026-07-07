import 'package:flutter/material.dart';

import '../domain/courier_models.dart';

/// Major courier / last-mile companies operating in Malaysia, with brand
/// colours and realistic tracking-number formats. Used to drive the courier
/// picker and the adaptive tracking-number placeholder.
const List<Courier> kCouriers = [
  Courier(
    id: 'poslaju',
    name: 'Pos Laju',
    color: Color(0xFFE30613),
    hint: 'Format: 2 huruf + 9 digit + "MY"',
    sample: 'ELM739284756MY',
  ),
  Courier(
    id: 'jnt',
    name: 'J&T Express',
    color: Color(0xFFE2231A),
    hint: '12 digit nombor',
    sample: '630087654321',
  ),
  Courier(
    id: 'gdex',
    name: 'GDex',
    color: Color(0xFFD71920),
    hint: '11 digit nombor',
    sample: '60061234567',
  ),
  Courier(
    id: 'citylink',
    name: 'City-Link Express',
    color: Color(0xFF00A24B),
    hint: 'Cth: MYCLK01234567',
    sample: 'MYCLK01234567',
  ),
  Courier(
    id: 'ninjavan',
    name: 'Ninja Van',
    color: Color(0xFFC8102E),
    hint: 'Cth: NVMY00123456789',
    sample: 'NVMY00123456789',
  ),
  Courier(
    id: 'dhl',
    name: 'DHL eCommerce',
    color: Color(0xFFFFCC00),
    hint: 'Cth: JJD0099998888',
    sample: 'JJD0099998888',
  ),
  Courier(
    id: 'skynet',
    name: 'SkyNet',
    color: Color(0xFF1B75BC),
    hint: 'Cth: SKN0012345678',
    sample: 'SKN0012345678',
  ),
  Courier(
    id: 'flash',
    name: 'Flash Express',
    color: Color(0xFFFDDB00),
    hint: 'Cth: FMY123456789',
    sample: 'FMY123456789',
  ),
  Courier(
    id: 'best',
    name: 'Best Express',
    color: Color(0xFFED1C24),
    hint: '13 digit nombor',
    sample: '6031234567890',
  ),
  Courier(
    id: 'spx',
    name: 'Shopee Express',
    color: Color(0xFFEE4D2D),
    hint: 'Cth: SPXMY012345678',
    sample: 'SPXMY012345678',
  ),
  Courier(
    id: 'teleport',
    name: 'Teleport',
    color: Color(0xFFFF0000),
    hint: 'Cth: TP12345678MY',
    sample: 'TP12345678MY',
  ),
  Courier(
    id: 'abx',
    name: 'ABX Express',
    color: Color(0xFF0054A6),
    hint: 'Cth: ABX12345678',
    sample: 'ABX12345678',
  ),
  Courier(
    id: 'nationwide',
    name: 'Nationwide Express',
    color: Color(0xFF00843D),
    hint: 'Cth: NW1234567890',
    sample: 'NW1234567890',
  ),
  Courier(
    id: 'aramex',
    name: 'Aramex',
    color: Color(0xFFE30613),
    hint: '10 digit nombor',
    sample: '1234567890',
  ),
  Courier(
    id: 'pgeon',
    name: 'Pgeon',
    color: Color(0xFF00C2B5),
    hint: 'Cth: PGN12345678',
    sample: 'PGN12345678',
  ),
];

Courier courierById(String id) =>
    kCouriers.firstWhere((c) => c.id == id, orElse: () => kCouriers.first);
