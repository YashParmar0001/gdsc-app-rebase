import 'package:flutter/material.dart';

import '../../../model/announcement_model.dart';
import '../../../theme/colors.dart';
import '../../../utils/conversion_utils.dart';

class AnnouncementWidget extends StatelessWidget {
  const AnnouncementWidget({super.key, required this.announcement});

  final AnnouncementModel announcement;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              Text(
                announcement.description,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                 const Spacer(),
                  Text(
                    Util().formatDate(announcement.time),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        color: AppColors.black.withOpacity(0.6)),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
