import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc_atmiya/features/notifications/config.dart';
import 'package:http/http.dart' as http;

import '../model/announcement_model.dart';
import '../model/notification_model.dart';

import 'dart:developer' as dev;

class NotificationRepository {
  NotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<dynamic>> getStreamOfNotifications() {
    return _firestore
        .collection('notifications')
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) {
      List<dynamic> notifications = [];

      for (var document in event.docs) {
        if (document.data()['description'] != null) {
          notifications.add(AnnouncementModel.fromMap(document.data()));
        } else {
          notifications.add(NotificationModel.fromMap(document.data()));
        }
      }
      return notifications;
    });
  }

  Future<void> addNotification(NotificationModel notification) async {
    await _firestore
        .collection('notifications')
        .doc(notification.time.toString())
        .set(notification.toMap());
  }

  Future<void> sendPushNotification(String notificationContents,
      String notificationTitle,) async {
    try {
      var url = Uri.parse(OneSignalConfig.apiUrl);
      var client = http.Client();
      var headers = {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Basic ${OneSignalConfig.serverKey}",
      };
      var body = {
        "app_id": OneSignalConfig.appId,
        "contents": {"en": notificationContents},
        "included_segments": ["All"],
        "headings": {"en": notificationTitle},
        "priority": "HIGH",
        "small_icon" : 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
      };

      var response =
      await client.post(url, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        dev.log("Notification is send Successfully ${response.body} ",
            name: 'Notification');
      } else {
        dev.log("Got errors : ${response.body}", name: "Notification");
      }
    } catch (e) {
      dev.log("Got errors : $e", name: "Notification");
    }
  }

  Future<void> addAnnouncement(AnnouncementModel announcement) async {
    await _firestore
        .collection('notifications')
        .doc(announcement.time.toString())
        .set(announcement.toMap());
  }
}
