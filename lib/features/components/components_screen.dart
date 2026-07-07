import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../../core/utils/extensions.dart';
import '../../core/widgets/animated_toggle_icon.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_loaders.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/section_header.dart';

class ComponentsScreen extends StatefulWidget {
  const ComponentsScreen({super.key});

  @override
  State<ComponentsScreen> createState() => _ComponentsScreenState();
}

class _ComponentsScreenState extends State<ComponentsScreen> {
  int _segment = 0;
  bool _switchOn = true;
  double _slider = 0.4;
  final Set<String> _chips = {'Flutter'};

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Components')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- Snackbars ----
          const SectionHeader(title: 'Snackbars (setiap action)'),
          AppCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () =>
                      AppSnackbar.success(context, 'Berjaya disimpan ✓'),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Success'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      AppSnackbar.error(context, 'Alamak, ada masalah!'),
                  icon: const Icon(Icons.error_outline),
                  label: const Text('Error'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      AppSnackbar.warning(context, 'Hati-hati ya…'),
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: const Text('Warning'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      AppSnackbar.info(context, 'Sekadar makluman.'),
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Info'),
                ),
              ],
            ),
          ),

          // ---- Buttons ----
          const SectionHeader(title: 'Buttons'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: () =>
                      AppSnackbar.info(context, 'Filled button ditekan'),
                  child: const Text('Filled'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () =>
                      AppSnackbar.info(context, 'Outlined button ditekan'),
                  child: const Text('Outlined'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () =>
                      AppSnackbar.info(context, 'Text button ditekan'),
                  child: const Text('Text'),
                ),
              ],
            ),
          ),

          // ---- Selection controls ----
          const SectionHeader(title: 'Selection controls'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Day')),
                    ButtonSegment(value: 1, label: Text('Week')),
                    ButtonSegment(value: 2, label: Text('Month')),
                  ],
                  selected: {_segment},
                  onSelectionChanged: (s) {
                    setState(() => _segment = s.first);
                    AppSnackbar.info(context, 'Segment: ${s.first}');
                  },
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final c in ['Flutter', 'Dart', 'Riverpod'])
                      FilterChip(
                        label: Text(c),
                        selected: _chips.contains(c),
                        onSelected: (v) {
                          setState(() {
                            v ? _chips.add(c) : _chips.remove(c);
                          });
                          AppSnackbar.info(context, '$c ${v ? 'dipilih' : 'dibuang'}');
                        },
                      ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Enable feature'),
                  value: _switchOn,
                  onChanged: (v) {
                    setState(() => _switchOn = v);
                    AppSnackbar.info(context, v ? 'Switched ON' : 'Switched OFF');
                  },
                ),
                Row(
                  children: [
                    const Icon(Icons.volume_down_rounded),
                    Expanded(
                      child: Slider(
                        value: _slider,
                        onChanged: (v) => setState(() => _slider = v),
                        onChangeEnd: (v) => AppSnackbar.info(
                            context, 'Volume: ${(v * 100).round()}%'),
                      ),
                    ),
                    const Icon(Icons.volume_up_rounded),
                  ],
                ),
              ],
            ),
          ),

          // ---- Animated icons ----
          const SectionHeader(title: 'Animated icons (built-in)'),
          AppCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedToggleIcon(
                  icon: AnimatedIcons.menu_close,
                  label: 'menu',
                  onChanged: (v) =>
                      AppSnackbar.info(context, v ? 'Opened' : 'Closed'),
                ),
                AnimatedToggleIcon(
                  icon: AnimatedIcons.play_pause,
                  label: 'play',
                  onChanged: (v) =>
                      AppSnackbar.info(context, v ? 'Playing' : 'Paused'),
                ),
                AnimatedToggleIcon(
                  icon: AnimatedIcons.add_event,
                  label: 'event',
                ),
                AnimatedToggleIcon(
                  icon: AnimatedIcons.arrow_menu,
                  label: 'arrow',
                ),
              ],
            ),
          ),

          // ---- Loaders ----
          const SectionHeader(title: 'Loaders (flutter_spinkit)'),
          AppCard(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 20,
              runSpacing: 20,
              children: [
                _LoaderTile('fadingCircle', AppLoaders.fadingCircle(color: primary)),
                _LoaderTile('wave', AppLoaders.wave(color: primary)),
                _LoaderTile('pulse', AppLoaders.pulse(color: primary)),
                _LoaderTile('cubeGrid', AppLoaders.cubeGrid(color: primary)),
                _LoaderTile('threeBounce', AppLoaders.threeBounce(color: primary)),
                _LoaderTile('ring', AppLoaders.ring(color: primary)),
                _LoaderTile('spinningLines', AppLoaders.spinningLines(color: primary)),
              ],
            ),
          ),

          // ---- Lottie (real bundled animation) ----
          const SectionHeader(title: 'Lottie (kartun)'),
          AppCard(
            child: Column(
              children: [
                Lottie.asset(
                  'assets/lottie/loader.json',
                  width: 120,
                  height: 120,
                  repeat: true,
                ),
                const SizedBox(height: 8),
                Text(
                  'Animasi Lottie sebenar (assets/lottie/loader.json). '
                  'Ganti fail tu dengan mana-mana .json dari LottieFiles.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: context.colors.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ),
          ),

          // ---- flutter_animate demo ----
          const SectionHeader(title: 'flutter_animate'),
          AppCard(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, const Color(0xFFEB5757)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text('Shimmer + Scale',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .shimmer(duration: 1400.ms, color: Colors.white54)
                  .scaleXY(end: 1.05, duration: 1400.ms),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _LoaderTile extends StatelessWidget {
  final String name;
  final Widget loader;
  const _LoaderTile(this.name, this.loader);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        children: [
          SizedBox(height: 60, child: Center(child: loader)),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
