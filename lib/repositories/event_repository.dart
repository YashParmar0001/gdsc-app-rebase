import 'dart:io';
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../model/event_model.dart';

class EventRepository {
  EventRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Stream<List<Event>> getEvents() {
    return _firestore.collection('events').snapshots().map((event) {
      return event.docs.map((e) => Event.fromMap(e.data())).toList();
    });
  }

  Future<String?> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
      dev.log('Event successfully deleted! $eventId', name: 'Events');
      return null;
    } catch(e) {
      dev.log('Event delete error: $e', name: 'Events');
      return e.toString();
    }
  }

  Future<Event?> publishEvent(Map<String, dynamic> eventData) async {
    var event = Event.fromMapPartial(eventData);
    if (eventData['eventBannerUrl'] != null) {
      event = event.copyWith(eventBannerUrl: eventData['eventBannerUrl']);
    }

    if (eventData['eventThumbnailUrl'] != null) {
      event = event.copyWith(eventThumbnailUrl: eventData['eventThumbnailUrl']);
    }

    try {
      // First upload event banner and thumbnail
      if (eventData['thumbnailImage'] != null) {
        final thumbnailUrl = await _uploadEventThumbnail(
          eventData['thumbnailImage'],
          // event.unixStartTime.toString(),
          event.postedTime.toString(),
        );

        if (thumbnailUrl == null) {
          return null;
        } else {
          event = event.copyWith(eventThumbnailUrl: thumbnailUrl);
        }
      }

      if (eventData['bannerImage'] != null) {
        final bannerUrl = await _uploadEventBanner(
          eventData['bannerImage'],
          event.postedTime.toString(),
        );

        if (bannerUrl == null) {
          return null;
        } else {
          event = event.copyWith(eventBannerUrl: bannerUrl);
        }
      }

      // Uploading speakers data
      final List<Map<String, dynamic>> speakersData = eventData['speakers'];
      final List<EventSpeaker> speakers = [];
      if (speakersData.isNotEmpty) {
        for (var speaker in speakersData) {
          if (speaker['image'] != null) {
            final photoUrl = await _uploadSpeakerImage(speaker);
            if (photoUrl == null) {
              return null;
            } else {
              speaker['photoUrl'] = photoUrl;
            }
          }

          speakers.add(EventSpeaker.fromMap(speaker));
        }
      }

      event = event.copyWith(speakers: speakers);

      // Post event to firestore
      await _firestore
          .collection('events')
          .doc(DateFormat('yyyy-MM-dd HH:mm').format(event.postedTime))
          .set(event.toMap());
      return event;
    } catch (e) {
      dev.log('Got event error: $e', name: 'Event');
      return null;
    }
  }

  Future<String?> _uploadEventThumbnail(
    File thumbnailFile,
    String eventId,
  ) async {
    try {
      await _storage.ref('event_thumbnails/$eventId').putFile(thumbnailFile);
      dev.log('Successfully uploaded event thumbnail', name: 'Event');
      return await _storage.ref('event_thumbnails/$eventId').getDownloadURL();
    } catch (e) {
      dev.log('Error occurred while uploading event thumbnail', name: 'Event');
      return null;
    }
  }

  Future<String?> _uploadEventBanner(
    File bannerFile,
    String eventId,
  ) async {
    try {
      await _storage.ref('event_banners/$eventId').putFile(bannerFile);
      dev.log('Successfully uploaded event banner', name: 'Event');
      return await _storage.ref('event_banners/$eventId').getDownloadURL();
    } catch (e) {
      dev.log('Error occurred while uploading event banner', name: 'Event');
      return null;
    }
  }

  Future<String?> _uploadSpeakerImage(
      Map<String, dynamic> speakerData,
  ) async {
    try {
      await _storage.ref('speakers_images/${speakerData['name']}').putFile(speakerData['image']);
      dev.log('Successfully uploaded speaker image: ${speakerData['name']}', name: 'Event');
      return await _storage.ref('speakers_images/${speakerData['name']}').getDownloadURL();
    } catch (e) {
      dev.log('Error occurred while uploading speaker image: ${speakerData['name']}', name: 'Event');
      return null;
    }
  }
}
