import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'util/firebase_options.dart';
import 'screens/welcome.dart';
import 'screens/home.dart';
import 'widgets/navigation/navigation_provider.dart';
import 'widgets/navigation/weather_provider.dart'; // Import the new provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
            create: (_) => WeatherProvider()), // Add the weather provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(), // Wrapper to check authentication
    );
  }
}

// Decides which screen to show (Login or Home)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading
        }
        if (snapshot.hasData) {
          return HomeScreen(); // User is logged in, go to home
        }
        return WelcomeScreen(); // Otherwise, go to welcome/login
      },
    );
  }
}
