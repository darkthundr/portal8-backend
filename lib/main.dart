import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:portal8/screens/home_screen.dart';
import 'package:portal8/screens/practice_uploader_screen.dart';
import 'firebase_options.dart';

// Screens
import 'package:portal8/screens/auth_gate.dart';
import 'package:portal8/screens/login_screen.dart';
import 'package:portal8/screens/signup_screen.dart';
import 'package:portal8/screens/dashboard_screen.dart';
import 'package:portal8/screens/settings_screen.dart';
import 'package:portal8/screens/cosmic_nexus_screen.dart';
import 'package:portal8/screens/portal_zero_overview_screen.dart';
import 'package:portal8/screens/portal_completion_screen.dart';
import 'package:portal8/screens/portals_home_screen.dart';
import 'package:portal8/screens/portal_screen.dart';
import 'package:portal8/screens/chapter_screen.dart';
import 'package:portal8/screens/infinity_portal_screen.dart';
import 'package:portal8/screens/ritual_confirmation_screen.dart';
import 'package:portal8/screens/advanced_practices_screen.dart';
import 'package:portal8/screens/infinity_scroll_screen.dart';
import 'package:portal8/screens/purchase_screen.dart';
import 'package:portal8/screens/individual_portal_screen.dart';


// Models
import 'package:portal8/models/chapter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    final razorpayKey = dotenv.env['RAZORPAY_TEST_KEY_ID'];
    final paypalOrderUrl = dotenv.env['PAYPAL_ORDER_URL'];

    debugPrint('✅ Razorpay Key Loaded: $razorpayKey');
    debugPrint('✅ PayPal Order URL Loaded: $paypalOrderUrl');
  } catch (e) {
    debugPrint('⚠️ Failed to load .env file: $e');
  }

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('Firebase already initialized: $e');
  }

  runApp(const Portal8App());
}

class Portal8App extends StatelessWidget {
  const Portal8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal8',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Orbitron',
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Orbitron',
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      // ✅ Updated: no parameters passed to PurchaseScreen
      onGenerateRoute: (settings) {
        if (settings.name == '/purchase') {
          return MaterialPageRoute(
            builder: (_) => const PurchaseScreen(),
          );
        }
        return null;
      },
      routes: {
        '/': (context) => const AuthGate(),
        '/signup': (context) => const SignupScreen(),

        '/home': (context) => HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),

        '/nexus': (context) => const CosmicNexusScreen(),
        '/settings': (context) => SettingsScreen(),
        '/portals': (context) => const PortalsHomeScreen(),
        '/portal0': (context) => const PortalZeroOverviewScreen(),
        '/portal0complete': (context) => const PortalCompletionScreen(),
        '/infinity': (context) => const InfinityPortalScreen(),

        // Portals
        '/portal1': (context) => const PortalScreen(portalId: 'portal1'),
        '/portal2': (context) => const PortalScreen(portalId: 'portal2'),
        '/portal3': (context) => const PortalScreen(portalId: 'portal3'),
        '/portal4': (context) => const PortalScreen(portalId: 'portal4'),
        '/portal5': (context) => const PortalScreen(portalId: 'portal5'),
        '/portal6': (context) => const PortalScreen(portalId: 'portal6'),
        '/portal7': (context) => const PortalScreen(portalId: 'portal7'),
        '/portal8': (context) => const PortalScreen(portalId: 'portal8'),

        // Others
        '/ritual_confirmation': (context) => const RitualConfirmationScreen(),
        '/advanced_practices': (context) => AdvancedPracticesScreen(),
        '/infinity_scroll': (context) => InfinityScrollScreen(),
        '/advancedPractices': (context) => AdvancedPracticesScreen(),
        '/infinityScroll': (context) => InfinityScrollScreen(),
        '/admin-upload': (context) => PracticeUploaderScreen(),


        // Individual portal purchase screens
        '/purchasePortal1': (context) =>
        const IndividualPortalScreen(portalIndex: 1),
        '/purchasePortal2': (context) =>
        const IndividualPortalScreen(portalIndex: 2),
        '/purchasePortal3': (context) =>
        const IndividualPortalScreen(portalIndex: 3),
        '/purchasePortal4': (context) =>
        const IndividualPortalScreen(portalIndex: 4),
        '/purchasePortal5': (context) =>
        const IndividualPortalScreen(portalIndex: 5),
        '/purchasePortal6': (context) =>
        const IndividualPortalScreen(portalIndex: 6),
        '/purchasePortal7': (context) =>
        const IndividualPortalScreen(portalIndex: 7),
        '/purchasePortal8': (context) =>
        const IndividualPortalScreen(portalIndex: 8),
      },
    );
  }
}