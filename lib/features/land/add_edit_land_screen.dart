import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aikrishi/models/land_model.dart';
import 'package:aikrishi/providers/land_provider.dart';
import 'package:aikrishi/core/widgets/custom_text_field.dart';

class AddEditLandScreen extends StatefulWidget {
  final Land? land;

  const AddEditLandScreen({super.key, this.land});

  @override
  _AddEditLandScreenState createState() => _AddEditLandScreenState();
}

class _AddEditLandScreenState extends State<AddEditLandScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _areaController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.land?.landName ?? '');
    _areaController = TextEditingController(text: widget.land?.area.toString() ?? '');
    _locationController = TextEditingController(text: widget.land?.location ?? '');
  }

  Future<void> _saveLand() async {
    if (_formKey.currentState!.validate()) {
      final landProvider = Provider.of<LandProvider>(context, listen: false);
      final isUpdating = widget.land != null;

      if (isUpdating) {
        await landProvider.updateLand(
          widget.land!.id,
          _nameController.text,
          double.parse(_areaController.text),
          _locationController.text,
        );
      } else {
        await landProvider.addLand(
          _nameController.text,
          double.parse(_areaController.text),
          _locationController.text,
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.land == null ? 'Add Land' : 'Edit Land'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: "Land Name",
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _areaController,
                labelText: "Area (in acres)",
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter an area' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _locationController,
                labelText: "Location",
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveLand,
                child: const Text('Save Land'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
