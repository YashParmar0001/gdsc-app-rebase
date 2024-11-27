import 'package:clipboard/clipboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gdsc_atmiya/bloc/admin/admin_bloc.dart';
import 'package:gdsc_atmiya/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/assets_constants.dart';
import '../../../constants/string_constants.dart';
import 'dart:developer' as dev;
import '../../../utils/ui_utils.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About us',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeText(context),
              const SizedBox(height: 10),
              _appText(
                text: AboutUsConstants.ourMissionTitle,
                fontSize: 18,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 5),
              _appText(
                text: AboutUsConstants.ourMissionDescription,
                fontSize: 14,
                weight: FontWeight.normal,
              ),
              const SizedBox(height: 10),
              _appText(
                text: AboutUsConstants.whoWeAreTitle,
                fontSize: 18,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 5),
              _appText(
                text: AboutUsConstants.whoWeAreDescription,
                fontSize: 14,
                weight: FontWeight.normal,
              ),
              const SizedBox(height: 10),
              _appText(
                text: AboutUsConstants.connectWithUs,
                fontSize: 18,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 5),
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  if (state is InitialData) {
                    return Container();
                  } else if (state is LoadingData) {
                    return const CircularProgressIndicator();
                  } else if (state is LoadedData) {
                    return _buildSocialMedia(context, state.urls);
                  } else if (state is AdminErrorState) {
                    return const Text('Some error is occurred');
                  } else {
                    return const Text('error is occurred');
                  }
                },
              ),
              const SizedBox(height: 5),
              _appText(
                text: 'Contact Us',
                fontSize: 18,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 10),
              _buildContactUsText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: 'Welcome to ',
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Google ',
            style: TextStyle(
              color: AppColors.googleRed,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
              text: 'Developer ',
              style: TextStyle(
                color: AppColors.googleBlue,
                fontWeight: FontWeight.bold,
              )),
          TextSpan(
              text: 'Student ',
              style: TextStyle(
                color: AppColors.googleGreen,
                fontWeight: FontWeight.bold,
              )),
          TextSpan(
              text: 'Club ',
              style: TextStyle(
                color: AppColors.googleYellow,
                fontWeight: FontWeight.bold,
              )),
          TextSpan(
            text: 'at ',
          ),
          TextSpan(
            text: 'Atmiya University!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _appText({
    required String text,
    required double fontSize,
    required FontWeight weight,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: weight,
        fontFamily: 'Open Sans',
      ),
    );
  }

  Widget _buildSocialMedia(BuildContext context, Map<String, String> map) {
    final socialMediaList = <Widget>[];

    if (map['linkedinUrl'] != "") {
      socialMediaList
          .add(_buildSocialMediaButton(AssetsConstants.linkedInLogo, () async {
        await launchUrl(
          Uri.parse(map['linkedinUrl']!),
          mode: LaunchMode.externalApplication,
        );
        dev.log('LinkedIn clicked', name: 'About Us');
      }));
    }

    if (map['githubUrl'] != "") {
      socialMediaList
          .add(_buildSocialMediaButton(AssetsConstants.githubLogo, () async {
        await launchUrl(
          Uri.parse(map['githubUrl']!),
          mode: LaunchMode.externalApplication,
        );
        dev.log('GitHub clicked', name: 'About Us');
      }));
    }

    if (map['youtubeUrl'] != "") {
      socialMediaList
          .add(_buildSocialMediaButton(AssetsConstants.youtubeLogo, () async {
        await launchUrl(
          Uri.parse(map['youtubeUrl']!),
          mode: LaunchMode.externalApplication,
        );
        dev.log('Youtube clicked', name: 'About Us');
      }));
    }

    if (map['instagramUrl'] != "") {
      socialMediaList
          .add(_buildSocialMediaButton(AssetsConstants.instagramLogo, () async {
        await launchUrl(
          Uri.parse(map['instagramUrl']!),
          mode: LaunchMode.externalApplication,
        );
        dev.log('Instagram Url clicked  ${map['instagramUrl']}', name: 'About Us');
      }));
    }

    if (map['discordUrl'] != "") {
      socialMediaList
          .add(_buildSocialMediaButton(AssetsConstants.discordLogo, () async {
        FlutterClipboard.copy(map['discordUrl']!).then((value) {
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
      child: Row(
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

  Widget _buildContactUsText(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is InitialData) {
          return Container();
        } else if (state is LoadingData) {
          return const CircularProgressIndicator();
        } else if (state is LoadedData) {
          return RichText(
            text: TextSpan(
              text: AboutUsConstants.contactUs,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.normal,
                color: Colors.black,
                height: 1.5,
              ),
              children: <TextSpan>[
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        onClickEmail(state.urls['email'].toString(), context),
                  text: state.urls['email'].toString(),
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
                const TextSpan(
                  text: AboutUsConstants.contactUsEnd,
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        onClickLink(state.urls['communityUrl'].toString()),
                  text: 'GDSC Platform',
                  style: const TextStyle(
                    color: Colors.blue,
                    height: 4,
                  ),
                ),
              ],
            ),
          );
        } else if (state is AdminErrorState) {
          return const Text('Some error is occurred');
        } else {
          return const Text('error is occurred');
        }
      },
    );
  }

  onClickEmail(String email, BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      dev.log('email is launch successfully', name: 'About Us');
    } else {
      dev.log('Launch Url Error', name: 'About Us');
    }
  }

  onClickLink(String link) async {
    if (await launchUrl(Uri.parse(link),
        mode: LaunchMode.externalApplication)) {
      dev.log('GDSC is launch successfully', name: 'About Us');
    } else {
      dev.log('Launch Url Error', name: 'About Us');
    }
  }
}
