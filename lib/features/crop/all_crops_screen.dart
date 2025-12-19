import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:aikrishi/providers/crop_provider.dart';
import 'package:aikrishi/features/crop/crop_detail_screen.dart';

class AllCropsScreen extends StatefulWidget {
  const AllCropsScreen({super.key});

  @override
  State<AllCropsScreen> createState() => _AllCropsScreenState();
}

class _AllCropsScreenState extends State<AllCropsScreen> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the provider is available when this is called.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CropProvider>(context, listen: false).fetchAllCropsForUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার ফসল'), // My Crops
      ),
      body: Consumer<CropProvider>(
        builder: (context, cropProvider, child) {
          if (cropProvider.crops.isEmpty) {
            return const Center(
              child: Text('You have not added any crops yet.'),
            );
          }
          return ListView.builder(
            itemCount: cropProvider.crops.length,
            itemBuilder: (context, index) {
              final crop = cropProvider.crops[index];
              return ListTile(
                leading: const Icon(Icons.grass),
                title: Text(crop.cropName),
                subtitle: Text('Planted: ${DateFormat.yMMMd().format(crop.plantingDate)}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CropDetailScreen(crop: crop),
                    ),
                  ).then((_) {
                    // After returning from detail screen, refresh the list
                    Provider.of<CropProvider>(context, listen: false).fetchAllCropsForUser();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
