import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meeting_planner/models/booking.dart' as meeting;
import 'package:timezone/data/latest.dart' as tzn;

// Helper class to handle local notification triggers by app itself
class LocalNotification {
  static final LocalNotification instance = LocalNotification._private();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotification._private() {
    tzn.initializeTimeZones();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  void initialize() {
    // initialise the plugin. app_icon needs to be a added as a drawable
    // resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String payload) async {}

  Future<void> cancel() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

  Future<void> createNotificationChannel(
      String id, String name, String description) async {
    var androidNotificationChannel = AndroidNotificationChannel(
      id,
      name,
      description,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> deleteNotificationChannel(String channelId) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId);
  }

  Future<void> scheduleNotification(meeting.Booking booking) async {
    DateTime scheduledNotificationDateTime = booking.meetingDateTime.subtract(
        Duration(
            hours: booking.reminderDuration.duration.hour == null
                ? 0
                : booking.reminderDuration.duration.hour,
            minutes: booking.reminderDuration.duration.minute == null
                ? 0
                : booking.reminderDuration.duration.minute));
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails("1", "MeetingPlanner", "MeetingPlanner");
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        booking.title,
        booking.description,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  void scheduledNotification(List<meeting.Booking> booking) {
    if (booking != null) {
      booking.forEach((element) {
        LocalNotification.instance.scheduleNotification(element);
      });
    }
  }
}
