import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';

import 'core/theme.dart';
import 'providers/app_state.dart';
import 'providers/chat_provider.dart';
import 'providers/language_provider.dart';

// Auth screens
import 'auth/splash_screen.dart';
import 'auth/role_selection_screen.dart';
import 'auth/login_screen.dart';
import 'auth/otp_screen.dart';
import 'auth/register_screen.dart';
import 'auth/forgot_password_screen.dart';

// User screens
import 'user/user_shell.dart';
import 'user/match_detail_screen.dart';
import 'user/chat_screen.dart';
import 'user/profile_creation_screen.dart';
import 'user/subscription_screen.dart';
import 'user/horoscope_screen.dart';
import 'user/notifications_screen.dart';
import 'user/interest_management_screen.dart';
import 'user/privacy_settings_screen.dart';
import 'user/help_support_screen.dart';

// Mediator screens
import 'mediator/mediator_shell.dart';

// Admin screens
import 'admin/admin_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MatrimonyApp());
}

class MatrimonyApp extends StatelessWidget {
  const MatrimonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()..loadSavedLanguage()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Matrimony',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(),
            locale: languageProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('hi'), // Hindi
              Locale('ta'), // Tamil
              Locale('te'), // Telugu
            ],
            initialRoute: '/',
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case '/':
        page = const SplashScreen();
        break;
      case '/role-selection':
        page = const RoleSelectionScreen();
        break;
      case '/login':
        page = const LoginScreen();
        break;
      case '/otp':
        page = const OtpScreen();
        break;
      case '/register':
        page = const RegisterScreen();
        break;
      case '/forgot-password':
        page = const ForgotPasswordScreen();
        break;
      case '/user':
        page = const UserShell();
        break;
      case '/match-detail':
        page = const MatchDetailScreen();
        break;
      case '/chat':
        page = const ChatScreen();
        break;
      case '/profile-creation':
        page = const ProfileCreationScreen();
        break;
      case '/subscription':
        page = const SubscriptionScreen();
        break;
      case '/horoscope':
        page = const HoroscopeScreen();
        break;
      case '/notifications':
        page = const NotificationsScreen();
        break;
      case '/interests':
        page = const InterestManagementScreen();
        break;
      case '/privacy-settings':
        page = const PrivacySettingsScreen();
        break;
      case '/help-support':
        page = const HelpSupportScreen();
        break;
      case '/mediator':
        page = const MediatorShell();
        break;
      case '/admin':
        page = const AdminShell();
        break;
      default:
        page = const SplashScreen();
    }

    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
