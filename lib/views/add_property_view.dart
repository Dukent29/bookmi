import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../providers/auth_provider.dart';
import '../../models/property.dart';

class AddPropertyView extends StatefulWidget {
  @override
  _AddPropertyViewState createState() => _AddPropertyViewState();
}

class _AddPropertyViewState extends State<AddPropertyView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _pricePerNightController = TextEditingController();
  final _maxGuestsController = TextEditingController();
  final _numBedroomsController = TextEditingController();
  final _numBathroomsController = TextEditingController();
  final _amenitiesController = TextEditingController();

  int _currentStep = 0;
  String _message = '';
  List<Uint8List> _images = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      final images = await Future.wait(
        pickedFiles.map((file) => file.readAsBytes()).toList(),
      );
      setState(() {
        _images = images;
      });
    }
  }

  Future<void> _addProperty() async {
    try {
      final property = Property(
        id: 0,
        title: _titleController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: _countryController.text,
        zipCode: _zipCodeController.text,
        pricePerNight: double.parse(_pricePerNightController.text),
        maxGuests: int.parse(_maxGuestsController.text),
        numBedrooms: int.parse(_numBedroomsController.text),
        numBathrooms: int.parse(_numBathroomsController.text),
        amenities: _amenitiesController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await Provider.of<AuthProvider>(context, listen: false).addProperty(
        property: property,
        images: _images,
      );
      setState(() {
        _message = 'Propriété ajoutée avec succès';
      });
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Détails'),
        content: Column(
          children: [
            buildTextField(_titleController, 'Titre'),
            SizedBox(height: 10.0),
            buildTextField(_descriptionController, 'Description'),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Emplacement'),
        content: Column(
          children: [
            buildTextField(_addressController, 'Adresse'),
            SizedBox(height: 10.0),
            buildTextField(_cityController, 'Ville'),
            SizedBox(height: 10.0),
            buildTextField(_stateController, 'État'),
            SizedBox(height: 10.0),
            buildTextField(_countryController, 'Pays'),
            SizedBox(height: 10.0),
            buildTextField(_zipCodeController, 'Code postal'),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Tarifs'),
        content: Column(
          children: [
            buildTextField(_pricePerNightController, 'Prix par nuit', TextInputType.number),
            SizedBox(height: 10.0),
            buildTextField(_maxGuestsController, 'Nombre maximum d\'invités\', TextInputType.number'),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('Agréments'),
        content: Column(
          children: [
            buildTextField(_numBedroomsController, 'Nombre de chambres', TextInputType.number),
            SizedBox(height: 10.0),
            buildTextField(_numBathroomsController, 'Nombre de salles de bains', TextInputType.number),
            SizedBox(height: 10.0),
            buildTextField(_amenitiesController, 'Agréments'),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Choisir des images'),
            ),
            if (_images.isNotEmpty)
              Wrap(
                children: _images.map((image) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(image, height: 100, width: 100),
                  );
                }).toList(),
              ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une propriété'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF292A32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 45.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Ajouter',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: ' Propriété',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Stepper(
                    steps: _getSteps(),
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_currentStep < _getSteps().length - 1) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        if (_formKey.currentState!.validate()) {
                          _addProperty();
                        }
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep -= 1;
                        });
                      }
                    },
                  ),
                  if (_message.isNotEmpty) ...[
                    Text(
                      _message,
                      style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextField buildTextField(TextEditingController controller, String label, [TextInputType type = TextInputType.text]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Poppins'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: type,
    );
  }
}
