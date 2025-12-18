import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aikrishi/providers/land_provider.dart';
import 'package:aikrishi/features/land/land_detail_screen.dart';
import 'package:aikrishi/features/land/add_edit_land_screen.dart';

class MyLandsScreen extends StatelessWidget {
  const MyLandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার জমি'), // My Lands
      ),
      body: Consumer<LandProvider>(
        builder: (context, landProvider, child) {
          if (landProvider.lands.isEmpty) {
            return const Center(
              child: Text('No lands added yet.'),
            );
          }
          return ListView.builder(
            itemCount: landProvider.lands.length,
            itemBuilder: (context, index) {
              final land = landProvider.lands[index];
              return ListTile(
                title: Text(land.landName),
                subtitle: Text('Area: ${land.area} acres'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LandDetailScreen(land: land),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditLandScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
