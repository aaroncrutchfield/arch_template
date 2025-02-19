// coverage:ignore-file
import 'package:arch_template/firebase/firebase_options_dev.dart' as dev;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifications/notifications.dart';

/// Top-level function to handle background messages
/// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> devFirebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  // Initialize Firebase for background messages
  await Firebase.initializeApp(
    options: dev.DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local notifications
  final localNotifications = LocalNotifications();
  await localNotifications.initialize();

  // Handle the message
  final handlers = NotificationHandlers(localNotifications);
  await handlers.handleRemoteMessage(message);
}
