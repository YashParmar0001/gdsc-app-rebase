import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_atmiya/constants/assets_constants.dart';
import 'package:gdsc_atmiya/constants/string_constants.dart';
import 'package:gdsc_atmiya/features/home/widgets/event_card.dart';
import 'package:gdsc_atmiya/theme/colors.dart';
import 'package:gdsc_atmiya/utils/ui_utils.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/event/delete/delete_event_bloc.dart';
import '../../../bloc/event/event_bloc.dart';
import '../../../bloc/user/user_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BuildContext? dialogContext;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GDSC Atmiya',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/aboutUs'),
            icon: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(AssetsConstants.aboutUs),
            ),
          ),
        ],
      ),
      floatingActionButton:
          ((context.read<UserBloc>().state as UserRegistered).user.userType ==
                  'core-member')
              ? FloatingActionButton.extended(
                  onPressed: () {
                    context.push('/publish_event');
                  },
                  label: const Row(
                    children: [
                      Icon(Icons.event),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Publish Event',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
      body: BlocListener<DeleteEventBloc, DeleteEventState>(
        listener: (context, state) {
          if (state is EventDeleted) {
            if (dialogContext != null) {
              Navigator.of(dialogContext!).pop();
            }
            showSnackBar(
              context,
              message: 'Event deleted!',
              icon: Icons.done,
              color: Colors.grey,
            );
          } else if (state is EventDeleteError) {
            if (dialogContext != null) {
              Navigator.of(dialogContext!).pop();
            }
            showSnackBar(context, message: state.message, icon: Icons.error);
          } else if (state is EventDeleting) {
            showDialog(
              context: context,
              builder: (context) {
                dialogContext = context;
                return const Dialog(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              },
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              // vertical: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCoreTeamCard(context),
                const SizedBox(
                  height: 15,
                ),
                _buildCommunityCard(context),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Events',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 15,
                ),
                BlocBuilder<EventBloc, EventState>(
                  builder: (context, state) {
                    if (state is EventsLoading || state is EventInitial) {
                      return const CircularProgressIndicator();
                    } else if (state is EventsLoaded) {
                      state.events.sort(
                        (a, b) => b.startTime.compareTo(a.startTime),
                      );

                      return Column(
                        children: List.generate(state.events.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 7,
                            ),
                            child: EventCard(
                              event: state.events[index],
                            ),
                          );
                        }),
                      );
                    } else if (state is EventError) {
                      return Text(
                        state.message,
                      );
                    }

                    return const Text('Something went wrong!');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityCard(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/club-members'),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: AppColors.antiFlashWhite,
          shadows: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(AssetsConstants.gdscAU),
            Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 12,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Colors.white, Color(0xFFF3EDF7)],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 280,
                        child: Text(
                          HomeConstants.communityHeader,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: AppColors.quartz,
                              ),
                        ),
                      ),
                      SvgPicture.asset(
                        AssetsConstants.arrowRight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    HomeConstants.communitySubHeader,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontFamily: 'Roboto',
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoreTeamCard(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/core_team');
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: AppColors.antiFlashWhite,
          shadows: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(AssetsConstants.coreTeam),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 12,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        HomeConstants.coreTeamHeader,
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppColors.quartz,
                                ),
                      ),
                      SvgPicture.asset(
                        AssetsConstants.arrowRight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    HomeConstants.coreTeamSubHeader,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontFamily: 'Roboto',
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
