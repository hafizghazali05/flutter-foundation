import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/utils/extensions.dart';
import '../../core/widgets/app_snackbar.dart';

class CalendarEvent {
  final String title;
  final Color color;
  const CalendarEvent(this.title, this.color);
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late final Map<DateTime, List<CalendarEvent>> _events = _seedEvents();

  Map<DateTime, List<CalendarEvent>> _seedEvents() {
    final now = DateTime.now();
    DateTime d(int addDays) =>
        DateTime.utc(now.year, now.month, now.day).add(Duration(days: addDays));
    return {
      d(0): const [
        CalendarEvent('Standup 9:30am', Color(0xFF6C4DF6)),
        CalendarEvent('Design review', Color(0xFF17A67B)),
      ],
      d(1): const [CalendarEvent('Lunch with Nadia', Color(0xFFF2994A))],
      d(3): const [CalendarEvent('Release v1.0', Color(0xFFEB5757))],
      d(5): const [CalendarEvent('1:1 with Imran', Color(0xFF2D9CDB))],
    };
  }

  List<CalendarEvent> _eventsFor(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    return _events[key] ?? const [];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final selected = _selectedDay ?? _focusedDay;
    final dayEvents = _eventsFor(selected);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: TableCalendar<CalendarEvent>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _format,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _eventsFor,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonShowsNext: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: scheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) => setState(() => _format = format),
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            ),
          ),
          Expanded(
            child: dayEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_available_rounded,
                            size: 48, color: scheme.onSurfaceVariant),
                        const SizedBox(height: 8),
                        Text('Takde acara hari ni',
                            style:
                                TextStyle(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      for (final e in dayEvents)
                        ListTile(
                          leading: Container(
                            width: 6,
                            height: 40,
                            decoration: BoxDecoration(
                              color: e.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          title: Text(e.title),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () =>
                              AppSnackbar.info(context, e.title),
                        ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppSnackbar.success(context, 'Acara baru — demo'),
        icon: const Icon(Icons.add),
        label: const Text('Event'),
      ),
    );
  }
}
