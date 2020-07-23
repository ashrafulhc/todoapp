class Event {
  EventType _eventType;

  Event(EventType eventType) {
    _eventType = eventType;
  }

  EventType get eventType => _eventType;
}

enum EventType {
  DATA_ADDED,
  DATA_RETRIEVED,
  DATA_REFRESHED,
  LOGGED_IN,
  LOGGED_OUT,
}