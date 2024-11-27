import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/assets_constants.dart';
import '../../../theme/colors.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: AppColors.googleBlue,
            ),
          ),
          shadows: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AssetsConstants.googleLogo),
            const SizedBox(width: 10,),
            Text(
              'Sign in With Google',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
