import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aikrishi/providers/crop_provider.dart';
import 'package:aikrishi/core/widgets/custom_text_field.dart';

class AddCropLogScreen extends StatefulWidget {
  final String cropId;

  const AddCropLogScreen({super.key, required this.cropId});

  @override
  _AddCropLogScreenState createState() => _AddCropLogScreenState();
}

class _AddCropLogScreenState extends State<AddCropLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String _selectedActivity = 'Watering'; // Default activity

  final List<String> _activities = [
    'Watering',
    'Fertilizing',
    'Pest Control',
    'Weeding',
    'Observation',
    'Other'
  ];

  Future<void> _saveLog() async {
    if (_formKey.currentState!.validate()) {
      final cropProvider = Provider.of<CropProvider>(context, listen: false);
      await cropProvider.addCropLog(
        widget.cropId,
        _selectedActivity,
        _notesController.text,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Crop Log'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedActivity,
                decoration: const InputDecoration(
                  labelText: 'Activity',
                  border: OutlineInputBorder(),
                ),
                items: _activities.map((String activity) {
                  return DropdownMenuItem<String>(
                    value: activity,
                    child: Text(activity),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedActivity = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                labelText: "Notes (Optional)",
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveLog,
                child: const Text('Save Log'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
