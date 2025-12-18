import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aikrishi/providers/auth_provider.dart';
import 'package:aikrishi/providers/user_profile_provider.dart';
import 'package:aikrishi/features/profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    // Trigger profile load when the screen is built
    userProfileProvider.loadUserProfile();

    final user = userProfileProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রোফাইল'), // Profile
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/auth', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Name: ${user.name}', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Email: ${user.email}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Text('Phone: ${user.phone ?? 'Not set'}', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Address: ${user.address ?? 'Not set'}', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}
