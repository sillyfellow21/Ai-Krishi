import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aikrishi/providers/auth_provider.dart';
import 'package:aikrishi/providers/land_provider.dart';
import 'package:aikrishi/providers/crop_provider.dart';
import 'package:aikrishi/providers/user_profile_provider.dart';
import 'package:aikrishi/features/auth/auth_screen.dart';
import 'package:aikrishi/features/home_screen.dart';
import 'package:aikrishi/features/splash_screen.dart';

void main() {
  runApp(const KrishibondhuApp());
}

class KrishibondhuApp extends StatelessWidget {
  const KrishibondhuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, UserProfileProvider>(
          create: (context) => UserProfileProvider(authProvider: Provider.of<AuthProvider>(context, listen: false)),
          update: (context, authProvider, previous) => UserProfileProvider(authProvider: authProvider),
        ),
        ChangeNotifierProxyProvider<AuthProvider, LandProvider>(
          create: (context) => LandProvider(authProvider: Provider.of<AuthProvider>(context, listen: false)),
          update: (context, authProvider, previous) => LandProvider(authProvider: authProvider),
        ),
        // **MODIFIED**: CropProvider now depends directly on AuthProvider
        ChangeNotifierProxyProvider<AuthProvider, CropProvider>(
          create: (context) => CropProvider(authProvider: Provider.of<AuthProvider>(context, listen: false)),
          update: (context, authProvider, previous) => CropProvider(authProvider: authProvider),
        ),
      ],
      child: MaterialApp(
        title: 'Krishibondhu',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
        routes: {
          '/auth': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
