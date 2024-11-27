import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gdsc_atmiya/bloc/user/user_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;
import '../../../constants/assets_constants.dart';
import '../../../model/user_model.dart';
import '../../../theme/colors.dart';
import '../../../utils/ui_utils.dart';

class ClubMember extends StatelessWidget {
  const ClubMember({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          if ((context.read<UserBloc>().state as UserRegistered)
              .user
              .userType !=
              'club-member'){
            context.push(
              '/profile',
              extra: user,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            top: 8,
            bottom: 8,
          ),
          // height: size.height * 0.175,
          decoration: BoxDecoration(
            color: AppColors.antiFlashWhite,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildProfilePhoto(context),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: size.width - 150,
                    child: _buildAreasOfInterests(context, user),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildUserSocialMedia(context, user),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(BuildContext context) {
    return Container(
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
      ),
      child: AspectRatio(
        aspectRatio: 140 / 200,
        child: CachedNetworkImage(
          imageUrl: user.photoUrl.toString(),
          fit: BoxFit.cover,
          imageBuilder: (context, imageProvider) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            );
          },
          placeholder: (context, url) {
            return ClipRRect(
              child: Image.asset(AssetsConstants.gdscLogo),
            );
          },
          errorWidget: (context, url, error) {
            return ClipRRect(
              child: Image.asset(AssetsConstants.gdscLogo),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAreasOfInterests(BuildContext context, UserModel user) {
    final len = user.areasOfInterest.length;
    final size = len > 5 ? 5 : len;
    final List<Widget> areas = user.areasOfInterest
        .map((area) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(
                  color: AppColors.sonicSilver,
                ),
              ),
            ),
            child: Text(
              area,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
            ),
          );
        })
        .toList()
        .sublist(0, size);

    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: areas,
    );
  }

  Widget _buildUserSocialMedia(BuildContext context, UserModel user) {
    final socialMediaList = <Widget>[];
    if (user.linkedInUrl != null) {
      socialMediaList
          .add(_buildSocialMediaButton(AssetsConstants.linkedInLogo, () async {
        await launchUrl(Uri.parse(user.linkedInUrl!),
            mode: LaunchMode.externalApplication);
        dev.log('LinkedIn clicked', name: 'Profile');
      }));
    }

    if (user.githubUrl != null) {
      socialMediaList
          .add(_buildSocialMediaButton(AssetsConstants.githubLogo, () async {
        await launchUrl(Uri.parse(user.githubUrl!),
            mode: LaunchMode.externalApplication);
        dev.log('GitHub clicked', name: 'Profile');
      }));
    }

    if (user.discordUserName != null) {
      socialMediaList
          .add(_buildSocialMediaButton(AssetsConstants.discordLogo, () async {
        FlutterClipboard.copy(user.discordUserName!).then((value) {
          showSnackBar(
            context,
            message: 'Username copied!',
            icon: Icons.discord,
            color: Colors.grey,
          );
        });

        dev.log('Discord username copied!', name: 'Profile');
      }));
    }

    return Container(
      child: (socialMediaList.isEmpty)
          ? Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...socialMediaList,
              ],
            ),
    );
  }

  Widget _buildSocialMediaButton(String icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 15,
        ),
        child: SizedBox(
          width: 35,
          height: 35,
          child: SvgPicture.asset(icon),
        ),
      ),
    );
  }
}
