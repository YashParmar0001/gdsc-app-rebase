import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  const Event({
    // required this.id,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.tags,
    required this.postedTime,
    required this.startTime,
    required this.endTime,
    this.eventBannerUrl,
    this.eventThumbnailUrl,
    required this.speakers,
    required this.eventVenue,
    required this.venueLine1,
    required this.venueLine2,
    required this.rsvpLink,
    required this.platformLink,
  });

  // final String id;
  final String title;
  final String shortDescription;
  final String description;
  final List<String> tags;
  final DateTime postedTime;
  final DateTime startTime;
  final DateTime endTime;
  final String? eventBannerUrl;
  final String? eventThumbnailUrl;
  final List<EventSpeaker> speakers;
  final String eventVenue;
  final String venueLine1;
  final String venueLine2;
  final String rsvpLink;
  final String platformLink;

  @override
  List<Object?> get props => [
    title,
    shortDescription,
    description,
    tags,
    postedTime,
    startTime,
    endTime,
    eventBannerUrl,
    eventThumbnailUrl,
    speakers,
    eventVenue,
    venueLine1,
    venueLine2,
    rsvpLink,
    platformLink,
  ];

  @override
  String toString() {
    return 'Event{ title: $title, shortDescription: $shortDescription, description: $description, tags: $tags, unixStartTime: $startTime, unixEndTime: $endTime, eventBannerUrl: $eventBannerUrl, eventThumbnailUrl: $eventThumbnailUrl, speakers: $speakers, eventVenue: $eventVenue, venueLine1: $venueLine1, venueLine2: $venueLine2, rsvpLink: $rsvpLink, platformLink: $platformLink,}';
  }

  Event copyWith({
    // String? id,
    String? title,
    String? shortDescription,
    String? description,
    List<String>? tags,
    DateTime? postedTime,
    DateTime? startTime,
    DateTime? endTime,
    String? eventBannerUrl,
    String? eventThumbnailUrl,
    List<EventSpeaker>? speakers,
    String? eventVenue,
    String? venueLine1,
    String? venueLine2,
    String? rsvpLink,
    String? platformLink,
  }) {
    return Event(
      // id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      postedTime: postedTime ?? this.postedTime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      eventBannerUrl: eventBannerUrl ?? this.eventBannerUrl,
      eventThumbnailUrl: eventThumbnailUrl ?? this.eventThumbnailUrl,
      speakers: speakers ?? this.speakers,
      eventVenue: eventVenue ?? this.eventVenue,
      venueLine1: venueLine1 ?? this.venueLine1,
      venueLine2: venueLine2 ?? this.venueLine2,
      rsvpLink: rsvpLink ?? this.rsvpLink,
      platformLink: platformLink ?? this.platformLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'description': description,
      'tags': tags,
      'postedTime' : postedTime,
      'startTime' : startTime,
      'endTime' : endTime,
      'eventBannerUrl': eventBannerUrl ?? '',
      'eventThumbnailUrl': eventThumbnailUrl ?? '',
      'speakers': speakers.map((speaker) => speaker.toMap()),
      'eventVenue': eventVenue,
      'venueLine1': venueLine1,
      'venueLine2': venueLine2,
      'rsvpLink': rsvpLink,
      'platformLink': platformLink,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      // id: map['id'] as String,
      title: map['title'] as String,
      shortDescription: map['shortDescription'] as String,
      description: map['description'] as String,
      tags: (map['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
      postedTime: (map['postedTime'] as Timestamp).toDate(),
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      eventBannerUrl: (map['eventBannerUrl'] as String == '')
          ? null
          : map['eventBannerUrl'] as String,
      eventThumbnailUrl: (map['eventThumbnailUrl'] as String == '')
          ? null
          : map['eventThumbnailUrl'] as String,
      speakers: (map['speakers'] as List<dynamic>)
          .map((e) => EventSpeaker.fromMap(e))
          .toList(),
      eventVenue: map['eventVenue'] as String,
      venueLine1: map['venueLine1'] as String,
      venueLine2: map['venueLine2'] as String,
      rsvpLink: map['rsvpLink'] as String,
      platformLink: map['platformLink'] as String,
    );
  }

  factory Event.fromMapPartial(Map<String, dynamic> map) {
    return Event(
      title: map['title'] as String,
      shortDescription: map['shortDescription'] as String,
      description: map['description'] as String,
      tags: (map['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
      postedTime: (map['postedTime'] as DateTime),
      startTime: map['startTime'] as DateTime,
      endTime: map['endTime'] as DateTime,
      eventBannerUrl: null,
      eventThumbnailUrl: null,
      speakers: const [],
      eventVenue: map['eventVenue'] as String,
      venueLine1: map['venueLine1'] as String,
      venueLine2: map['venueLine2'] as String,
      rsvpLink: map['rsvpLink'] as String,
      platformLink: map['platformLink'] as String,
    );
  }

}

class EventSpeaker extends Equatable {
  const EventSpeaker({
    required this.name,
    required this.organization,
    required this.role,
    this.photoUrl,
  });

  final String name;
  final String organization;
  final String role;
  final String? photoUrl;

  @override
  String toString() {
    return 'EventSpeaker{ name: $name, organization: $organization, role: $role, photoUrl: $photoUrl,}';
  }

  EventSpeaker copyWith({
    String? name,
    String? organization,
    String? role,
    String? photoUrl,
  }) {
    return EventSpeaker(
      name: name ?? this.name,
      organization: organization ?? this.organization,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'organization': organization,
      'role': role,
      'photoUrl': photoUrl,
    };
  }

  factory EventSpeaker.fromMap(Map<String, dynamic> map) {
    return EventSpeaker(
      name: map['name'] as String,
      organization: map['organization'] as String,
      role: map['role'] as String,
      photoUrl: map['photoUrl'] as String,
    );
  }

  @override
  List<Object?> get props => [name, organization, role, photoUrl];

}
