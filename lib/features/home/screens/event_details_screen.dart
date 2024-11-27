import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_atmiya/model/event_model.dart';
import 'package:gdsc_atmiya/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/assets_constants.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event Details',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildEventBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildDate(context),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildVenue(context),
                  const SizedBox(
                    height: 15,
                  ),
                  if (event.speakers.isNotEmpty) _buildEventSpeakers(context),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildEventVenue(context),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildEventTags(context),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'About this Event',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildEventDescription(context),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildRSVPButton(),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // _buildPlatformButton(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventSpeakers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Speakers',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(
          height: 10,
        ),
        ...List.generate(event.speakers.length, (index) {
          return _buildSpeaker(context, event.speakers[index]);
        }),
      ],
    );
  }

  // Widget _buildPlatformButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         launchUrl(Uri.parse(event.platformLink), mode: LaunchMode.externalApplication,);
  //       },
  //       child: const Text('Show on Community Platform'),
  //     ),
  //   );
  // }

  Widget _buildRSVPButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          launchUrl(Uri.parse(event.rsvpLink), mode: LaunchMode.externalApplication,);
        },
        child: const Text('RSVP for the Event'),
      ),
    );
  }

  Widget _buildEventDescription(BuildContext context) {
    // return Text(
    //   event.description,
    //   style: Theme.of(context).textTheme.headlineSmall,
    // );
    return SelectableLinkify(
      onOpen: (link) async {
        print('This is link: ${link.url}');
        await launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication);
      },
      options: const LinkifyOptions(
        humanize: true,
      ),
      text: event.description,
    );
  }

  Widget _buildEventTags(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: event.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: AppColors.slateGray),
          )),
          child: Text(
            tag,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.quartz,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventVenue(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.quartz),
      )),
      child: Text(
        '${event.eventVenue} event',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.quartz,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
      ),
    );
  }

  Widget _buildSpeaker(BuildContext context, EventSpeaker speaker) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: speaker.photoUrl.toString(),
            imageBuilder: (context, imageProvider) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image: imageProvider,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              );
            },
            placeholder: (context, url) {
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.slateGray,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.slateGray,
                ),
              );
            },
          ),
          const SizedBox(
            width: 14,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                speaker.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'OpenSans',
                    ),
              ),
              Text(
                speaker.organization,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.slateGray,
                    ),
              ),
              Text(
                speaker.role,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.slateGray,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVenue(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AssetsConstants.locationBox),
        const SizedBox(
          width: 14,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.venueLine1,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: 'OpenSans',
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              event.venueLine2,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Roboto Condensed',
                    color: AppColors.slateGray,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDate(BuildContext context) {
    final dateFormat = DateFormat('MMM dd');
    final startDate = dateFormat.format(event.startTime);
    final endDate = dateFormat.format(event.endTime);

    final sameDay = event.startTime.day == event.endTime.day;
    String formattedDate = startDate;
    if (!sameDay) {
      formattedDate += ' to $endDate';
    }

    String formattedTime = '${getWeekday(event.startTime.weekday)}, ';
    final timeFormat = DateFormat('hh:mm a');
    final startTime = timeFormat.format(event.startTime);
    final endTime = timeFormat.format(event.endTime);
    formattedTime += '$startTime - $endTime';

    return Row(
      children: [
        SvgPicture.asset(AssetsConstants.calendarBox),
        const SizedBox(
          width: 14,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: 'OpenSans',
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              formattedTime,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Roboto Condensed',
                    color: AppColors.slateGray,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  String getWeekday(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  Widget _buildEventBanner() {
    return CachedNetworkImage(
      imageUrl: event.eventBannerUrl.toString(),
      imageBuilder: (context, imageProvider) {
        return AspectRatio(
          aspectRatio: 360 / 92,
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
            width: double.infinity,
            // height: 92,
          ),
        );
      },
      placeholder: (context, url) {
        return Image.asset(AssetsConstants.eventBanner);
      },
      errorWidget: (context, url, error) {
        return Image.asset(AssetsConstants.eventBanner);
      },
    );
  }
}
