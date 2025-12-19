import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aikrishi/models/crop_model.dart';
import 'package:aikrishi/models/crop_log_model.dart';
import 'package:aikrishi/providers/crop_provider.dart';
import 'package:aikrishi/features/crop/add_crop_log_screen.dart';

class CropDetailScreen extends StatefulWidget {
  final Crop crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  _CropDetailScreenState createState() => _CropDetailScreenState();
}

class _CropDetailScreenState extends State<CropDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the logs for this specific crop when the screen loads
    Provider.of<CropProvider>(context, listen: false).fetchCropLogs(widget.crop.id);
  }

  void _navigateAndRefresh(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddCropLogScreen(cropId: widget.crop.id),
      ),
    );
    // No need to manually refresh here as the provider will notify listeners
  }

  @override
  Widget build(BuildContext context) {
    final cropProvider = Provider.of<CropProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crop.cropName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusSection(context, cropProvider),
            const SizedBox(height: 24),
            Text("Activity Log",
                style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),
            Expanded(
              child: Consumer<CropProvider>(
                builder: (context, provider, child) {
                  if (provider.cropLogs.isEmpty) {
                    return const Center(child: Text("No activities logged yet."));
                  }
                  return ListView.builder(
                    itemCount: provider.cropLogs.length,
                    itemBuilder: (context, index) {
                      final log = provider.cropLogs[index];
                      return ListTile(
                        leading: const Icon(Icons.article),
                        title: Text(log.activity),
                        subtitle: Text(log.notes ?? 'No notes'),
                        trailing: Text(DateFormat.yMMMd().format(log.date)),
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
        onPressed: () => _navigateAndRefresh(context),
        tooltip: 'Add Log',
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, CropProvider cropProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Status:", style: Theme.of(context).textTheme.titleMedium),
                DropdownButton<CropStatus>(
                  value: widget.crop.status,
                  items: CropStatus.values.map((CropStatus status) {
                    return DropdownMenuItem<CropStatus>(
                      value: status,
                      child: Text(status.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (CropStatus? newStatus) {
                    if (newStatus != null) {
                      setState(() {
                        widget.crop.status = newStatus;
                        if (newStatus == CropStatus.Harvested &&
                            widget.crop.harvestDate == null) {
                          widget.crop.harvestDate = DateTime.now();
                        }
                      });
                      cropProvider.updateCrop(widget.crop); // Update in DB
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
                "Planted on: ${DateFormat.yMMMd().format(widget.crop.plantingDate)}"),
            if (widget.crop.status == CropStatus.Harvested &&
                widget.crop.harvestDate != null)
              Text(
                  "Harvested on: ${DateFormat.yMMMd().format(widget.crop.harvestDate!)}"),
            // Add yield tracking fields here in a future step if needed
          ],
        ),
      ),
    );
  }
}
