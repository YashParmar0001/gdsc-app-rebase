import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_atmiya/features/notifications/widgets/announcement.dart';
import 'package:gdsc_atmiya/features/notifications/widgets/notification.dart';
import 'package:gdsc_atmiya/model/notification_model.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/notification/notification_bloc.dart';
import '../../../model/announcement_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NotificationError) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<NotificationBloc>().add(LoadNotifications());
                },
                child: const Text('Reload'),
              ),
            );
          } else if (state is NotificationLoaded) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final item = state.notifications[index];

                  if (item is NotificationModel) {
                    return NotificationWidget(
                      notification: item,
                    );
                  } else if (item is AnnouncementModel) {
                    return AnnouncementWidget(announcement: item);
                  } else {
                    return Container();
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/announcement');
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
