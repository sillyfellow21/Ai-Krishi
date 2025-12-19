import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aikrishi/models/land_model.dart';
import 'package:aikrishi/providers/land_provider.dart';
import 'package:aikrishi/core/widgets/custom_text_field.dart';
import 'package:aikrishi/core/utils/area_unit_utils.dart';

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
  AreaUnit _selectedUnit = AreaUnit.acre; // Default unit

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.land?.landName ?? '');
    // If editing, we display the area in acres by default.
    // A future improvement could be to store and retrieve the user's preferred unit.
    _areaController = TextEditingController(
        text: widget.land?.area.toString() ?? '');
    _locationController = TextEditingController(text: widget.land?.location ?? '');
  }

  Future<void> _saveLand() async {
    if (_formKey.currentState!.validate()) {
      final landProvider = Provider.of<LandProvider>(context, listen: false);
      final isUpdating = widget.land != null;

      // Convert the input area to acres before saving
      final double areaInAcres = AreaUnitUtils.convertToAcre(
        double.parse(_areaController.text),
        _selectedUnit,
      );

      if (isUpdating) {
        await landProvider.updateLand(
          widget.land!.id,
          _nameController.text,
          areaInAcres, // Always save as acres
          _locationController.text,
        );
      } else {
        await landProvider.addLand(
          _nameController.text,
          areaInAcres, // Always save as acres
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
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: _areaController,
                      labelText: "Area",
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter an area' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<AreaUnit>(
                      value: _selectedUnit,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                      items: AreaUnit.values.map((AreaUnit unit) {
                        return DropdownMenuItem<AreaUnit>(
                          value: unit,
                          child: Text(AreaUnitUtils.getUnitString(unit)),
                        );
                      }).toList(),
                      onChanged: (AreaUnit? newValue) {
                        setState(() {
                          _selectedUnit = newValue!;
                        });
                      },
                    ),
                  ),
                ],
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
