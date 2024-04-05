import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notify_me/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;

  void showNotification() async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'notify_me', 'notify kar',
        priority: Priority.max, importance: Importance.max);

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    NotificationDetails notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await notificationsPlugin.show(
        0, 'Notify ME', 'Notify Karta hu', notiDetails);
  }

  tz.TZDateTime _nextInstanceOfFiveSecondsFromNow() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    return now.add(const Duration(seconds: 5));
  }

  // tz.TZDateTime _nextInstanceOfMondayTenAM() {
  //   tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
  //   while (scheduledDate.weekday != DateTime.monday) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }
  Future<void> _zonedScheduleNotification() async {
    await notificationsPlugin.zonedSchedule(
        1,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void startTimer() {
    print("Will print after 5 seconds");
    _timer = Timer(Duration(seconds: 5), () {
      showNotification();
    });
  }

  void showPeriodicalNotification() async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'notify_me', 'notify kar',
        priority: Priority.max, importance: Importance.max);

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    NotificationDetails notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await notificationsPlugin.periodicallyShow(
      2,
      'repeating title',
      'repeating body',
      RepeatInterval.everyMinute,
      notiDetails,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Notify_ME'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: showPeriodicalNotification,
            child: Icon(Icons.notifications_active),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: startTimer,
            child: Icon(Icons.notification_important),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            // onPressed: showNotification,
            onPressed: showNotification,
            child: Icon(Icons.notification_add),
          ),
        ],
      ),
    );
  }
}
