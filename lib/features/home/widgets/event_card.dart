import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_atmiya/model/event_model.dart';
import 'package:gdsc_atmiya/utils/ui_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../bloc/event/delete/delete_event_bloc.dart';
import '../../../constants/assets_constants.dart';
import '../../../theme/colors.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        context.push('/event_details', extra: event);
      },
      onLongPress: () {
        _showEventOptions(context);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: MediaQuery.of(context).size.width - 20,
        // height: 87,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: (event.endTime.isAfter(DateTime.now()))
              ? AppColors.paleLavender
              : AppColors.antiFlashWhite,
          shadows: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CachedNetworkImage(
                      imageUrl: event.eventBannerUrl.toString(),
                      imageBuilder: (context, imageProvider) {
                        return AspectRatio(
                          aspectRatio: 340 / 87,
                          child: Image(
                            image: imageProvider,
                            width: MediaQuery.of(context).size.width - 20,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return const AspectRatio(
                          aspectRatio: 340 / 87,
                          child: Image(
                            image: AssetImage(AssetsConstants.eventBanner),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return const AspectRatio(
                          aspectRatio: 340 / 87,
                          child: Image(
                            image: AssetImage(AssetsConstants.eventBanner),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: getWidgetHeight(
                        targetWidgetHeight: 75, screenHeight: screenHeight),
                    left: 5,
                    child: CachedNetworkImage(
                      imageUrl: event.eventThumbnailUrl.toString(),
                      imageBuilder: (context, imageProvider) {
                        return Image(
                          image: imageProvider,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        );
                      },
                      placeholder: (context, url) {
                        return const Image(
                          image: AssetImage(AssetsConstants.eventThumbnail),
                          width: 70,
                          height: 70,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return const Image(
                          image: AssetImage(AssetsConstants.eventThumbnail),
                          width: 70,
                          height: 70,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: getWidgetHeight(
                        targetWidgetHeight: 92, screenHeight: screenHeight),
                    left: 82,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateOfEvent(),
                        SizedBox(
                          width: 250,
                          child: Text(
                            event.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Text(
                event.shortDescription,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 5,
                children: event.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: AppColors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(color: AppColors.black.withOpacity(0.7)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  void _showEventOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Event'),
              onTap: () {
                Navigator.pop(context);
                context.push('/edit_event', extra: event);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Event'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Are you sure you want to delete this event?',
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    final eventId =
                                        DateFormat('yyyy-MM-dd HH:mm')
                                            .format(event.postedTime);
                                    BlocProvider.of<DeleteEventBloc>(context).add(
                                      DeleteEvent(eventId),
                                    );
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateOfEvent() {
    final DateFormat dateFormat = DateFormat('MMM d');
    final DateFormat timeFormat = DateFormat('hh:mm a');

    final String startDate = dateFormat.format(event.startTime);
    final String startTime = timeFormat.format(event.startTime);
    final String endTime = timeFormat.format(event.endTime);

    final bool sameDay = event.startTime.day == event.endTime.day;
    final String endDate = sameDay ? '' : dateFormat.format(event.endTime);

    String formattedDate = '$startDate - $startTime';
    if (sameDay) {
      formattedDate += ' to $endTime';
    } else {
      formattedDate += ' to $endDate - $endTime';
    }

    return Text(
      formattedDate,
    );
  }
}
