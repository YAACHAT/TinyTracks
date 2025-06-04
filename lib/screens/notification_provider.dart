import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  bool _hasNewEvent = false;

  bool get hasNewEvent => _hasNewEvent;

  void markAsSeen() {
    _hasNewEvent = false;
    notifyListeners();
  }

  void newEventAdded() {
    _hasNewEvent = true;
    notifyListeners();
  }
}
