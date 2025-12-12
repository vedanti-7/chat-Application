import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsServices {
  static final FlutterLocalNotificationsPlugin _notifications=FlutterLocalNotificationsPlugin();  // Create a single instance of the notification plugin

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInit=AndroidInitializationSettings('@mipmap/ic_launcher');  // Android setup - this tells Android which icon to show in notifications.

    final iosInit=DarwinInitializationSettings(    // iOS setup - permissions are handled here.
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:null,
    );  

    final settings=InitializationSettings(   // Combine Android + iOS initialization settings. 
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        print('Notification tapped: ${response.payload}');
      },
    );

    await _notifications
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        sound: true,
        badge: true,
      );
}

  // Call this whenever you want to display a notification.
  static Future<void> showNotifications({required String title, required String body}) async {

    const androidDetails=AndroidNotificationDetails(  // Notification settings for Android 
      'chat_channel',               //channelId, 
      'Chat Notifications',         //channelName
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails=DarwinNotificationDetails(   // Notification settings for ios
      presentAlert: true,
      presentBadge: true, 
      presentSound: true,
    );   

    const details=NotificationDetails(  // Combine Android + iOS details
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(     // Show the notification
    DateTime.now().millisecondsSinceEpoch ~/ 1000,                    //id, 
    title,                //title, 
    body,                 //body, 
    details,              //notificationDetails
    );
  }
}