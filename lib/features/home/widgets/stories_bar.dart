import 'package:flutter/material.dart';

import '../../../core/widgets/app_snackbar.dart';

class Story {
  final String name;
  final Color color;
  final bool seen;
  const Story(this.name, this.color, {this.seen = false});
}

const _stories = [
  Story('Aisyah', Color(0xFF6C4DF6)),
  Story('Imran', Color(0xFFEB5757)),
  Story('Farah', Color(0xFF17A67B)),
  Story('Nadia', Color(0xFFF2994A)),
  Story('Zaid', Color(0xFF2D9CDB)),
  Story('Lisa', Color(0xFF9B51E0)),
  Story('Danish', Color(0xFF00B8A9), seen: true),
  Story('Sofea', Color(0xFFF25F5C), seen: true),
];

/// Instagram-style horizontally scrollable stories row (scroll X).
class StoriesBar extends StatelessWidget {
  const StoriesBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _stories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          if (i == 0) {
            return _StoryAvatar.yourStory(
              onTap: () =>
                  AppSnackbar.info(context, 'Tambah story anda — demo'),
            );
          }
          final s = _stories[i - 1];
          return _StoryAvatar(
            story: s,
            onTap: () => AppSnackbar.info(context, 'Story ${s.name} — demo'),
          );
        },
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  final Story? story;
  final VoidCallback onTap;
  final bool isYours;

  const _StoryAvatar({required this.story, required this.onTap})
      : isYours = false;
  const _StoryAvatar.yourStory({required this.onTap})
      : story = null,
        isYours = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final seen = story?.seen ?? false;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              width: 66,
              height: 66,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: seen || isYours
                    ? null
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF58529),
                          Color(0xFFDD2A7B),
                          Color(0xFF8134AF),
                        ],
                      ),
                color: seen
                    ? scheme.outlineVariant
                    : (isYours ? scheme.outlineVariant : null),
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundColor:
                      isYours ? scheme.surfaceContainerHighest : story!.color,
                  child: isYours
                      ? Icon(Icons.add_rounded, color: scheme.onSurface)
                      : Text(
                          story!.name.substring(0, 1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isYours ? 'You' : story!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
