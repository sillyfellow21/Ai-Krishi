import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:aikrishi/models/land_model.dart';
import 'package:aikrishi/models/crop_model.dart';
import 'package:aikrishi/providers/crop_provider.dart';
import 'package:aikrishi/features/crop/add_crop_screen.dart';
import 'package:aikrishi/features/crop/crop_detail_screen.dart'; // Import the new screen

class LandDetailScreen extends StatefulWidget {
  final Land land;

  const LandDetailScreen({super.key, required this.land});

  @override
  State<LandDetailScreen> createState() => _LandDetailScreenState();
}

class _LandDetailScreenState extends State<LandDetailScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CropProvider>(context, listen: false)
        .fetchCropsByLand(widget.land.id);
  }

  void _navigateAndRefreshAdd(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddCropScreen(landId: widget.land.id),
      ),
    );
    Provider.of<CropProvider>(context, listen: false)
        .fetchCropsByLand(widget.land.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.land.landName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Area: ${widget.land.area.toStringAsFixed(2)} acres",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text("Location: ${widget.land.location ?? 'N/A'}",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            Text("Crops", style: Theme.of(context).textTheme.headlineSmall),
            Expanded(
              child: Consumer<CropProvider>(
                builder: (context, cropProvider, child) {
                  if (cropProvider.crops.isEmpty) {
                    return const Center(
                      child: Text('No crops added yet.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: cropProvider.crops.length,
                    itemBuilder: (context, index) {
                      final crop = cropProvider.crops[index];
                      return ListTile(
                        title: Text(crop.cropName),
                        subtitle: Text(
                            'Planted: ${DateFormat.yMMMd().format(crop.plantingDate)}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () { // Navigate to the new CropDetailScreen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CropDetailScreen(crop: crop),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefreshAdd(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
