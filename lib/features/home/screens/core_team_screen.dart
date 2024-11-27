import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_atmiya/bloc/core_team/core_team_bloc.dart';
import 'package:gdsc_atmiya/constants/assets_constants.dart';
import 'package:gdsc_atmiya/theme/colors.dart';
import 'package:gdsc_atmiya/utils/ui_utils.dart';
import 'package:go_router/go_router.dart';

import '../../../model/user_model.dart';

class CoreTeamScreen extends StatelessWidget {
  const CoreTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Core Team',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: BlocBuilder<CoreTeamBloc, CoreTeamState>(
        builder: (context, state) {
          if (state is CoreTeamLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CoreTeamError) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<CoreTeamBloc>().add(LoadCoreTeam());
                },
                child: const Text('Reload'),
              ),
            );
          } else if (state is CoreTeamLoaded) {
            return _buildMembersGrid(state.coreTeamMembers);
          } else {
            return const Center(
              child: Text('Some error occurred!'),
            );
          }
        },
      ),
    );
  }

  Widget _buildMembersGrid(List<CoreUserModel> coreTeamMembers) {
    final colors = [
      AppColors.googleRed,
      AppColors.googleBlue,
      AppColors.googleGreen,
      AppColors.googleYellow,
    ];

    return GridView.builder(
      itemCount: coreTeamMembers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 170 / 290,
      ),
      itemBuilder: (context, index) {
        return _buildMemberCard(
          context,
          coreTeamMembers[index],
          colors[index % colors.length],
        );
      },
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    CoreUserModel user,
    Color color,
  ) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: InkWell(
        onTap: () {
          context.push(
            '/profile',
            extra: user,
          );
        },
        child: Container(
          // width: (MediaQuery.of(context).size.width / 2) - 10,
          // height: 290,
          decoration: ShapeDecoration(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            gradient: LinearGradient(
              begin: const Alignment(0.00, -1.00),
              end: const Alignment(0, 1),
              colors: [const Color(0x00202020), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                // width: getWidgetWidth(
                //   targetWidgetWidth: 100,
                //   screenWidth: size.width,
                // ),
                child: CachedNetworkImage(
                  imageUrl: user.thumbnailUrl,
                  // width: 120,
                  height: getWidgetWidth(
                      targetWidgetWidth: 190, screenWidth: size.width),
                  imageBuilder: (context, imageProvider) {
                    return Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    );
                  },
                  placeholder: (context, url) {
                    return Image.asset(
                      AssetsConstants.gdscLogo,
                      width: getWidgetWidth(
                        targetWidgetWidth: 100,
                        screenWidth: size.width,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      AssetsConstants.gdscLogo,
                      width: getWidgetWidth(
                        targetWidgetWidth: 100,
                        screenWidth: size.width,
                      ),
                    );
                  },
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 2) - 10,
                          child: Text(
                            user.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 2) - 10,
                          child: Text(
                            user.lead,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: AppColors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
