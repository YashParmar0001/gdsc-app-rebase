import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gdsc_atmiya/bloc/user/user_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/assets_constants.dart';
import '../../../model/user_model.dart';
import '../../../theme/colors.dart';
import '../../../utils/ui_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontSize: 22),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            // vertical: 20,
          ),
          child: Column(
            children: [
              _buildUserDetails(user, context),
              const SizedBox(
                height: 15,
              ),
              if (user is CoreUserModel)
                _buildCoreMemberBadge(context, user as CoreUserModel),
              const SizedBox(
                height: 15,
              ),
              _buildUserDescription(context, user),
              const SizedBox(
                height: 15,
              ),
              _buildUserSocialMedia(context, user),
              const SizedBox(
                height: 15,
              ),
              _buildAreasOfInterests(context, user),
              const SizedBox(
                height: 15,
              ),
              if ((context.read<UserBloc>().state as UserRegistered)
                      .user
                      .userType !=
                  'club-member')
                _buildContactDetails(context, user),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetails(BuildContext context, UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.antiFlashWhite,
        boxShadow: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EMAIL',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'OpenSans',
                      color: AppColors.slateGray,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Text(user.email),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PHONE',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'OpenSans',
                      color: AppColors.slateGray,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Text((user.userType == 'admin')
                  ? '--'
                  : '+91 ${user.contactNumber}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAreasOfInterests(BuildContext context, UserModel user) {
    final List<Widget> areas = user.areasOfInterest.map((area) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
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
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.antiFlashWhite,
        boxShadow: [
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
          Text(
            'AREAS OF INTEREST',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'OpenSans',
                  color: AppColors.slateGray,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: areas,
          ),
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.antiFlashWhite,
        boxShadow: [
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
          Text(
            'ON THE WEB',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'OpenSans',
              color: AppColors.slateGray,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          (socialMediaList.isEmpty)
              ? const Text('Nothing to Show')
              : Row(
            children: [
              ...socialMediaList,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserDescription(BuildContext context, UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.antiFlashWhite,
        boxShadow: [
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
          Text(
            'DESCRIPTION',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'OpenSans',
                  color: AppColors.slateGray,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            user.description == null ? 'Nothing to Show' : user.description!,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Roboto',
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreMemberBadge(BuildContext context, CoreUserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.antiFlashWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        user.lead,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'Roboto',
            ),
      ),
    );
  }

  Widget _buildUserDetails(UserModel user, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final names = user.name.split(' ');
    final firstName = names[0];
    final lastName = names[1];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.antiFlashWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProfilePhoto(user, context),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width:
                    getWidgetWidth(targetWidgetWidth: 160, screenWidth: width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'OpenSans',
                        color: AppColors.slateGray,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      lastName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'OpenSans',
                        color: AppColors.slateGray,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width:
                    getWidgetWidth(targetWidgetWidth: 160, screenWidth: width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      user.department,
                      style:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: 'Roboto',
                        color: AppColors.slateGray,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Semester',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      (user.userType == 'admin')
                          ? '--'
                          : user.semester.toString(),
                      style:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: 'Roboto',
                        color: AppColors.slateGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePhoto(UserModel user, BuildContext context) {
    return InkWell(
      onLongPress: () {
        _showFullProfileDialog(context, user);
      },
      child: Container(
        width: 140,
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
      ),
    );
  }

  void _showFullProfileDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Container(
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
                        width: 100,
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
            ),
          ),
        );
      },
    );
  }
}
