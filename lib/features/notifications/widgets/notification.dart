import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gdsc_atmiya/constants/assets_constants.dart';
import 'package:gdsc_atmiya/model/notification_model.dart';
import 'package:gdsc_atmiya/theme/colors.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/event/event_bloc.dart';
import '../../../utils/conversion_utils.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        final eventBloc = context.read<EventBloc>();
        if (eventBloc.state is EventsLoaded) {
          dev.log('Notification event id: ${notification.eventId}');
          dev.log(
              'Event ids: ${(eventBloc.state as EventsLoaded).events[0].startTime}');
          final event = (eventBloc.state as EventsLoaded).events.firstWhere(
                (event) =>
                    notification.eventId ==
                    DateFormat('yyyy-MM-dd HH:mm').format(event.postedTime),
              );
          context.push('/event_details', extra: event);
        }
      },
      child: Container(
        height: 90,
        decoration: const BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CachedNetworkImage(
                height: 70,
                width: 70,
                imageUrl: notification.thumbnailUrl,
                placeholder: (context, url) {
                  return Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage(AssetsConstants.eventThumbnail,),),
                      borderRadius:  BorderRadius.all(Radius.circular(10)),
                    ),

                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage(AssetsConstants.eventThumbnail,),),
                      borderRadius:  BorderRadius.all(Radius.circular(10)),
                    ),
                   
                  );
                },
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width - 120,
              height: 70,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      width: width - 120,
                      child: Text(
                        notification.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      Util().formatDate(notification.time),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          color: AppColors.black.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
