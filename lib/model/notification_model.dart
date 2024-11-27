import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.time,
    required this.title,
    required this.eventId,
    required this.thumbnailUrl,
  });

  final DateTime time;
  final String title;
  final String eventId;
  final String thumbnailUrl;

  @override
  List<Object?> get props => [
        time,
        title,
        eventId,
        thumbnailUrl,
      ];

  @override
  String toString() {
    return 'Notification{ time : ${time.toString()} ,title : $title, eventId : $eventId, URL ; $thumbnailUrl }';
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time ,
      'title': title,
      'eventId': eventId,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    final DateTime dateTime = (map['time'] as Timestamp).toDate();
    return NotificationModel(
      time: dateTime,
      title: map['title'] as String,
      eventId: map['eventId'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
    );
  }
}
