import 'dart:async';

import 'package:todoapp/src/model/event.dart';

class EventStream {
  static StreamController<Event> _streamController =
  new StreamController.broadcast();

  static Stream<Event> getStream() {
    return _streamController.stream;
  }

  static void putEvent(Event event) {
    print("EventCreated:");
    print(event.eventType.toString());
    _streamController.sink.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}
