import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_atmiya/constants/assets_constants.dart';
import 'package:gdsc_atmiya/features/auth/widgets/google_sign_in_button.dart';
import 'package:gdsc_atmiya/utils/ui_utils.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/log_in/log_in_bloc.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../theme/colors.dart';

import 'dart:developer' as dev;

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<LogInBloc, LogInState>(
            listener: (context, state) {
              if (state.isFailure) {
                showSnackBar(
                  context,
                  message: 'LogIn Failure!',
                  icon: Icons.error,
                );
              } else if (state.isSuccess) {
                BlocProvider.of<AuthBloc>(context).add(LoggedIn());
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                BlocProvider.of<UserBloc>(context)
                    .add(GetUser(email: state.email));
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserRegistered) {
                dev.log('Going to HomeScreen from LogInScreen');
                context.go('/home');
              } else if (state is UserNotRegistered) {
                context.go('/register');
              }
            },
          ),
        ],
        child: BlocBuilder<LogInBloc, LogInState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 140,
                    child: Image.asset(
                      AssetsConstants.gdscLogo,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Column(
                    children: [
                      Text(
                        'Welcome',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.googleRed,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        'To',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.googleBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'GDSC ',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  color: AppColors.googleGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            'Atmiya',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  color: AppColors.googleYellow,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  (state.isSubmitting || context.read<UserBloc>().state is GettingUser)
                      ? const CircularProgressIndicator()
                      : GoogleSignInButton(
                          onTap: () {
                            _onGooglePressed(context);
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onGooglePressed(BuildContext context) {
    BlocProvider.of<LogInBloc>(context).add(LogInWithGooglePressed());
  }
}
