// coverage:ignore-file
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

abstract class LibrariesModule {
  @singleton
  FlutterLocalNotificationsPlugin getFlutterLocalNotificationsPlugin() =>
      FlutterLocalNotificationsPlugin();
}
