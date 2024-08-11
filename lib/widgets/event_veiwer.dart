import 'package:flutter/material.dart';
import 'dart:math';

class EventViewer extends StatelessWidget {
  final List<Map<String, TimeOfDay>> otherEvents;

  EventViewer({
    required this.otherEvents,
  });

  @override
  Widget build(BuildContext context) {
    final eventColors = _generateEventColors(otherEvents.length);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 12, // 12 hours from 8 AM to 8 PM
              itemBuilder: (context, index) {
                final currentHour = 8 + index;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the hour label
                    Text(
                      _formatTimeOfDay(
                          TimeOfDay(hour: currentHour, minute: 0), context),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: List.generate(4, (subIndex) {
                        final currentTimeSlot = TimeOfDay(
                          hour: currentHour,
                          minute: subIndex * 15,
                        );

                        // Find the event that includes this time slot
                        final eventIndex =
                            _findEventIndexForSlot(currentTimeSlot);

                        return Expanded(
                          child: Container(
                            height: 40, // Adjust height based on your needs
                            color: eventIndex != null
                                ? eventColors[eventIndex]
                                : Colors.white,
                            child: Center(
                              child: Text(
                                _formatTimeOfDay(currentTimeSlot, context),
                                style: TextStyle(
                                  color: eventIndex != null
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isWithinTimeRange(TimeOfDay slot, TimeOfDay start, TimeOfDay end) {
    final slotMinutes = slot.hour * 60 + slot.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return slotMinutes >= startMinutes && slotMinutes < endMinutes;
  }

  int? _findEventIndexForSlot(TimeOfDay slot) {
    for (int i = 0; i < otherEvents.length; i++) {
      final event = otherEvents[i];
      if (_isWithinTimeRange(slot, event['start']!, event['end']!)) {
        return i;
      }
    }
    return null;
  }

  List<Color> _generateEventColors(int count) {
    final random = Random();
    return List.generate(
        count,
        (_) => Color.fromRGBO(
              random.nextInt(256),
              random.nextInt(256),
              random.nextInt(256),
              1.0,
            ));
  }

  String _formatTimeOfDay(TimeOfDay time, BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: true);
  }
}
