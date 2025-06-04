// YACHAT.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/notification_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/service_locator.dart';

// Widgets
import 'widgets/auth_wrapper.dart';

// Screens
import 'screens/welcome_screen.dart';
import 'screens/about_screen.dart';
import 'screens/get_started_screen.dart';
import 'screens/signin_or_signup_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_step1_screen.dart';
import 'screens/sign_up_step2_screen.dart';
import 'screens/sign_up_step3_screen.dart';
import 'screens/sign_up_step4_screen.dart';
import 'screens/home_screen.dart';
import 'screens/events_screen.dart';
import 'screens/budgeting_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/feeding_screen.dart';
import 'screens/sleep_screen.dart';
import 'screens/diaper_change_screen.dart';
import 'screens/milestones_screen.dart';
import 'screens/health_screen.dart';
import 'screens/caregiver_screen.dart';
import 'screens/hygiene_screen.dart';
import 'screens/growth_screen.dart';
import 'screens/feeding_documents_screen.dart';
import 'screens/sleep_documents_screen.dart';
import 'screens/diaper_change_documents_screen.dart';
import 'screens/milestones_documents_screen.dart';
import 'screens/health_documents_screen.dart';
import 'screens/caregiver_documents_screen.dart';
import 'screens/growth_documents_screen.dart';
import 'screens/expense_documents_screen.dart';
import 'screens/events_documents_screen.dart';
import 'screens/external_documents_screen.dart';


final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://klwodsejngvjlpaovpye.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtsd29kc2Vqbmd2amxwYW92cHllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg2NjU0NTcsImV4cCI6MjA2NDI0MTQ1N30.5Vf-ZLCuOzicVpkQ5KWYBCxtkDgfSwr2L8BxmmtXlIs',
    debug: true,
  );

  // Service locator setup
  setupServiceLocator();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NotificationProvider(),
      child: const TinyTracksApp(),
    ),
  );
}

class TinyTracksApp extends StatelessWidget {
  const TinyTracksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TinyTracks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3F3F3),
        fontFamily: 'Poppins',
      ),
      home: const AuthWrapper(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/get-started': (context) => const GetStartedScreen(),
      '/auth-choice': (context) => const SignInOrSignUpScreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/sign-up-step1': (context) => const SignUpStep1Screen(),
        '/sign-up-step2': (context) => const SignUpStep2Screen(),
        '/sign-up-step3': (context) => const SignUpStep3Screen(),
        '/sign-up-step4': (context) => const SignUpStep4Screen(),
        '/home': (context) => const HomeScreen(),
        '/budgeting': (context) => const BudgetingScreen(),
        '/events': (context) => const EventScreen(),
        '/documents': (context) => const DocumentsScreen(),
        '/feeding-documents': (context) => const FeedingDocumentScreen(),
        '/sleep-documents': (context) => const SleepDocumentScreen(),
        '/diaper-change-documents': (context) => const DiaperChangeDocumentScreen(),
        '/milestones-documents': (context) => const MilestonesDocumentScreen(),
        '/health-documents': (context) => const HealthDocumentScreen(),
        '/caregiver-documents': (context) => const CaregiverDocumentScreen(),
        '/growth-documents': (context) => const GrowthDocumentScreen(),
        '/expense-documents': (context) => const ExpenseDocumentScreen(),
        '/events-documents': (context) => const EventsDocumentScreen(),
        '/external-documents': (context) => const ExternalDocumentScreen(),
        '/feeding': (context) => const FeedingScreen(),
        '/sleep': (context) => const SleepScreen(),
        '/diaper-change': (context) => const DiaperChangeScreen(),
        '/milestones': (context) => const MilestonesScreen(),
        '/health': (context) => const HealthScreen(),
        '/caregiver': (context) => const CaregiverScreen(),
        '/hygiene': (context) => const HygieneScreen(),
        '/growth': (context) => const GrowthScreen(),
      },
    );
  }
}