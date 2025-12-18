import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:aikrishi/providers/crop_provider.dart';
import 'package:aikrishi/core/widgets/custom_text_field.dart';

class AddCropScreen extends StatefulWidget {
  final String landId;

  const AddCropScreen({super.key, required this.landId});

  @override
  _AddCropScreenState createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropNameController = TextEditingController();
  final _varietyController = TextEditingController();
  DateTime? _plantingDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _plantingDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _plantingDate) {
      setState(() {
        _plantingDate = picked;
      });
    }
  }

  Future<void> _saveCrop() async {
    if (_formKey.currentState!.validate()) {
      if (_plantingDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a planting date')),
        );
        return;
      }
      final cropProvider = Provider.of<CropProvider>(context, listen: false);
      await cropProvider.addCrop(
        widget.landId,
        _cropNameController.text,
        _varietyController.text,
        _plantingDate!,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Crop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _cropNameController,
                labelText: "Crop Name",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a crop name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _varietyController,
                labelText: "Variety",
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _plantingDate == null
                          ? 'No date chosen!'
                          : 'Planted: ${DateFormat.yMd().format(_plantingDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Choose Date'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCrop,
                child: const Text('Save Crop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
