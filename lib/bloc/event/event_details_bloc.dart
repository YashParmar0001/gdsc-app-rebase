import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gdsc_atmiya/constants/string_constants.dart';

class EventDetailsBloc extends FormBloc<Map<String, dynamic>, String> {
  EventDetailsBloc() {
    addFieldBlocs(
      fieldBlocs: [
        title,
        shortDescription,
        description,
        eventTags,
        eventVenue,
        eventStartTime,
        eventEndTime,
        eventVenueLine1,
        eventVenueLine2,
        rsvpLink,
        platformLink,
      ],
    );
  }

  final title = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final shortDescription = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final description = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final eventTags = MultiSelectFieldBloc(
    items: UserDataConstants.eventTags,
    validators: [
          (value) {
        if ((value as List<String>).isEmpty) {
          return 'Select at least one tag!';
        }
        return null;
      }
    ],
  );

  final eventVenue = SelectFieldBloc(
    items: UserDataConstants.eventVenue,
    initialValue: UserDataConstants.eventVenue[0],
    validators: [
          (value) {
        if (value == null) {
          return 'Select event venue';
        }
        return null;
      }
    ],
  );
  
  final eventStartTime = InputFieldBloc<DateTime, Object>(
    initialValue: DateTime.now(),
    validators: [FieldBlocValidators.required],
  );

  final eventEndTime = InputFieldBloc<DateTime, Object>(
    initialValue: DateTime.now().add(const Duration(days: 1)),
    validators: [FieldBlocValidators.required],
  );

  final eventVenueLine1 = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final eventVenueLine2 = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final rsvpLink = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final platformLink = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  @override
  FutureOr<void> onSubmitting() {
    try {
      final eventData = {
        'title' : title.value,
        'shortDescription' : shortDescription.value,
        'description' : description.value,
        'tags' : eventTags.value,
        'eventVenue' : eventVenue.value,
        'postedTime' : DateTime.now(),
        'startTime' : eventStartTime.value,
        'endTime' : eventEndTime.value,
        'venueLine1' : eventVenueLine1.value,
        'venueLine2' : eventVenueLine2.value,
        'rsvpLink' : rsvpLink.value,
        'platformLink' : platformLink.value,
      };

      emitSuccess(successResponse: eventData);
    } catch(e) {
      emitFailure(failureResponse: 'Event details error: $e');
    }
  }
}