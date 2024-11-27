import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_atmiya/constants/assets_constants.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/auth/auth_bloc.dart';

import 'dart:developer' as dev;

import '../../../bloc/user/user_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Uninitialized) {
          dev.log('Uninitialized State', name: 'AuthState');
        } else if (state is UnAuthenticated) {
          Future.delayed(const Duration(seconds: 2), () {
            context.go('/login');
          },);
        } else if (state is Authenticated) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              context.read<UserBloc>().add(GetUser(email: state.email));
            },
          );
        } else {
          dev.log('Unknown state', name: 'AuthState');
        }
      },
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserNotRegistered) {
            context.go('/register');
          } else if (state is UserRegistered) {
            dev.log('Going to HomeScreen from AuthScreen');
            context.go('/home');
          } else if (state is UserError) {
            context.read<AuthBloc>().add(LoggedOut());
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: Image.asset(
                    AssetsConstants.gdscLogo,
                  ),
                ),
                const SizedBox(height: 50,),
                const CircularProgressIndicator(),
                const Text('Please wait'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
