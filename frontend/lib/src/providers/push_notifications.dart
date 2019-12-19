import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final topic = 'products';

  final _messageStreamController = StreamController<String>.broadcast();

  Stream<String> get messages => _messageStreamController.stream;

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.subscribeToTopic(topic);

    _firebaseMessaging.configure(
        onMessage: (info) async {
          String argument = 'no-data';
          if (Platform.isAndroid) {
            argument = info['data']['name'] ?? 'no-data';
          }
          _messageStreamController.sink.add(argument);
        },
        onLaunch: (info) async {},
        onResume: (info) async {});
  }

  dispose() {
    _messageStreamController?.close();
  }
}
