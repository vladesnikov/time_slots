import 'package:flutter/material.dart';
import 'widgets/event_veiwer.dart';
import 'data/mock_events.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Event Scheduler')),
      body: EventViewer(
        otherEvents: mockEvents,
      ),
    ),
  ));
}
