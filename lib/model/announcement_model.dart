import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AnnouncementModel extends Equatable {
  final DateTime time;
  final String title;
  final String description;

  const AnnouncementModel({
    required this.time,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [
        time,
        title,
        description,
      ];

  @override
  String toString() {
    return "Announcement : {time : ${time.toString()} ,title : $title, Description : $description}";
  }

  Map<String , dynamic> toMap(){
    return {
      'time' : time,
      'title' :title,
      'description' :description,
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    final DateTime dateTime = (map['time'] as Timestamp).toDate();
    return AnnouncementModel(
      time: dateTime,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }
}
