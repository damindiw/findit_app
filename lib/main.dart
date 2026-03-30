import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import all your screens
import 'package:findit_app/screens/get_started_page.dart';
import 'package:findit_app/screens/welcome_page.dart';
import 'package:findit_app/screens/signin_page.dart';
import 'package:findit_app/screens/signup_page.dart';
import 'package:findit_app/screens/forget_password_page.dart';
import 'package:findit_app/screens/home_page.dart';
import 'package:findit_app/screens/report_page.dart';
import 'package:findit_app/screens/settings_page.dart';
import 'package:findit_app/screens/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Keep your Firebase initialization so the app can talk to the cloud
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const FinditApp());
}

class FinditApp extends StatelessWidget {
  const FinditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Findit - Lost & Found',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00A86B),
        scaffoldBackgroundColor: const Color(0xFF121B22),
      ),
      
      // The app now starts with your Splash/Get Started screen
      home: const GetStartedPage(), 

      // Define routes for easy navigation between all screens
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/forget_password': (context) => const ForgetPasswordPage(),
        '/main_nav': (context) => const MainNavigationShell(), // Use this after successful login
      },
    );
  }
}

// This is your shell that holds the Bottom Navigation Bar
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),      // Index 0
    const ReportPage(),    // Index 1
    const SettingsPage(),  // Index 2
    const ProfilePage(),   // Index 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1D272F),
        selectedItemColor: const Color(0xFF00A86B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}