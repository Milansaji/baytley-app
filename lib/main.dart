import 'package:baytley/core/theme/app_theme.dart';
import 'package:baytley/core/localization/app_locale.dart';
import 'package:baytley/core/localization/arabic_font_loading_overlay.dart';
import 'package:baytley/core/localization/arabic_theme.dart';
import 'package:baytley/features/blog/bloc/blog_bloc.dart';
import 'package:baytley/features/blog/bloc/blog_event.dart';
import 'package:baytley/features/auth/bloc/auth_bloc.dart';
import 'package:baytley/features/auth/bloc/auth_event.dart';
import 'package:baytley/features/auth/bloc/auth_state.dart';
import 'package:baytley/features/auth/bloc/signup_bloc.dart';
import 'package:baytley/features/auth/screens/auth_screen.dart';
import 'package:baytley/features/properties/bloc/property_bloc.dart';
import 'package:baytley/features/properties/bloc/property_event.dart';
import 'package:baytley/features/testimonials/bloc/testimonial_bloc.dart';
import 'package:baytley/features/testimonials/bloc/testimonial_event.dart';
import 'package:baytley/features/upcoming_projects/bloc/upcoming_project_bloc.dart';
import 'package:baytley/features/upcoming_projects/bloc/upcoming_project_event.dart';
import 'package:baytley/features/property_enquiries/bloc/property_enquiry_bloc.dart';
import 'package:baytley/features/property_enquiries/bloc/property_enquiry_event.dart';
import 'package:baytley/features/analytics/bloc/analytics_bloc.dart';
import 'package:baytley/features/analytics/bloc/analytics_event.dart';
import 'package:baytley/features/analytics/data/analytics_repository.dart';
import 'package:baytley/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:baytley/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AuthCheckRequested())),
        BlocProvider(create: (_) => SignupBloc()),
        BlocProvider(
          create: (_) => PropertyBloc()..add(FetchPropertiesEvent()),
        ),
        BlocProvider(create: (_) => BlogBloc()..add(FetchBlogsEvent())),
        BlocProvider(
          create: (_) => TestimonialBloc()..add(FetchTestimonialsEvent()),
        ),
        BlocProvider(
          create: (_) =>
              UpcomingProjectBloc()..add(FetchUpcomingProjectsEvent()),
        ),
        BlocProvider(
          create: (_) =>
              PropertyEnquiryBloc()..add(FetchPropertyEnquiriesEvent()),
        ),
        BlocProvider(
          create: (_) =>
              AnalyticsBloc(repository: AnalyticsRepository())
                ..add(FetchAnalyticsEvent()),
        ),
      ],
      child: ValueListenableBuilder<Locale>(
        valueListenable: AppLocaleController.locale,
        builder: (context, locale, _) {
          final isArabic = locale.languageCode == 'ar';
          final lightTheme = isArabic
              ? ArabicTheme.light(AppTheme.lightTheme)
              : AppTheme.lightTheme;
          final darkTheme = isArabic
              ? ArabicTheme.dark(AppTheme.darkTheme)
              : AppTheme.darkTheme;

          return MaterialApp(
            title: 'Baytley',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            locale: locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) => ArabicFontLoadingOverlay(
              child: child ?? const SizedBox.shrink(),
            ),
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return const MainScreen();
                }

                if (state is AuthLoading || state is AuthInitial) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                return const AuthScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
