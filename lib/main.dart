import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_atmiya/bloc/club_members/club_members_bloc.dart';
import 'package:gdsc_atmiya/bloc/event/delete/delete_event_bloc.dart';
import 'package:gdsc_atmiya/bloc/event/event_bloc.dart';
import 'package:gdsc_atmiya/bloc/event/publish/publish_event_bloc.dart';
import 'package:gdsc_atmiya/bloc/notification/notification_bloc.dart';
import 'package:gdsc_atmiya/features/notifications/config.dart';
import 'package:gdsc_atmiya/repositories/admin_repository.dart';
import 'package:gdsc_atmiya/repositories/auth_repository.dart';
import 'package:gdsc_atmiya/repositories/core_team_repository.dart';
import 'package:gdsc_atmiya/repositories/event_repository.dart';
import 'package:gdsc_atmiya/repositories/notification_repository.dart';
import 'package:gdsc_atmiya/repositories/user_repository.dart';
import 'package:gdsc_atmiya/router.dart';
import 'package:gdsc_atmiya/theme/app_theme.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'bloc/admin/admin_bloc.dart';
import 'bloc/announcement/announcement_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/core_team/core_team_bloc.dart';
import 'bloc/log_in/log_in_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  OneSignal.Notifications.clearAll();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(OneSignalConfig.appId);
  OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final userRepository = UserRepository();
    final coreTeamRepository = CoreTeamRepository();
    final notificationRepository = NotificationRepository();
    final eventRepository = EventRepository();
    final adminRepository = AdminRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: authRepository,
          )..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => LogInBloc(authRepository: authRepository),
        ),
        BlocProvider(
          create: (context) => UserBloc(
            authRepository: authRepository,
            userRepository: userRepository,
          ),
        ),
        BlocProvider(
          create: (context) => CoreTeamBloc(
            coreTeamRepository: coreTeamRepository,
          )..add(LoadCoreTeam()),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(
            notificationRepository: notificationRepository,
          )..add(LoadNotifications()),
        ),
        BlocProvider(
          create: (context) => AnnouncementBloc(
            notificationRepository: notificationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => PublishEventBloc(
            eventRepository: eventRepository,
            notificationRepository: notificationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => DeleteEventBloc(
            eventRepository: eventRepository,
          ),
        ),
        BlocProvider(
          create: (context) => EventBloc(
            eventRepository: eventRepository,
          )..add(LoadEvents()),
        ),
        BlocProvider(
          create: (context) => AdminBloc(
            adminRepository: adminRepository,
          )..add(LoadDataEvent()),
        ),
        BlocProvider(
          create: (context) => ClubMembersBloc(
            userRepository: userRepository,
          )..add(LoadClubMembers()),
        )
      ],
      child: MaterialApp.router(
        title: 'GDSC Atmiya',
        showSemanticsDebugger: false,
        theme: AppTheme.getTheme(),
        routerConfig: router,
      ),
    );
  }
}
