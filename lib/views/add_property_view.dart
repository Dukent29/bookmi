import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../providers/auth_provider.dart';
import '../../models/property.dart';
import 'announce_view.dart'; // Make sure this import points to the correct path

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
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Succès', style: TextStyle(fontFamily: 'Poppins')),
        content: Text('Propriété ajoutée avec succès', style: TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AnnounceView()), // Adjust userId as needed
              );
            },
            child: Text('OK', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF7B818))),
          ),
        ],
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Détails', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF7B818))),
        content: Column(
          children: [
            buildTextField(_titleController, 'Titre'),
            SizedBox(height: 10.0),
            buildTextField(_descriptionController, 'Description'),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep >= 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Emplacement', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF7B818))),
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
        state: _currentStep >= 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Tarifs', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF7B818))),
        content: Column(
          children: [
            buildTextField(_pricePerNightController, 'Prix par nuit', TextInputType.number),
            SizedBox(height: 10.0),
            buildTextField(_maxGuestsController, 'Nombre maximum d\'invités', TextInputType.number),
          ],
        ),
        isActive: _currentStep >= 2,
        state: _currentStep >= 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Agréments', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFF7B818))),
        content: Column(
          children: [
            buildTextField(_numBedroomsController, 'Nombre de chambres', TextInputType.number),
            SizedBox(height: 10.0),
            buildTextField(_numBathroomsController, 'Nombre de salles de bains', TextInputType.number),
            SizedBox(height: 10.0),
            buildTextField(_amenitiesController, 'Agréments'),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: Icon(Icons.image, color: Colors.white),
              label: Text('Choisir des images', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF7B818),
                padding: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
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
        state: _currentStep >= 3 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une propriété', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
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
                    controlsBuilder: (BuildContext context, ControlsDetails details) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: Text('Suivant', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF7B818), // Yellow color for next button
                                padding: EdgeInsets.all(16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: Text('Précédent', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700], // Grey color for back button
                                padding: EdgeInsets.all(16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
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
