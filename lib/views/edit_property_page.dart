import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';

class EditPropertyPage extends StatefulWidget {
  final Property property;

  EditPropertyPage({required this.property});

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
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

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.property.title;
    _descriptionController.text = widget.property.description;
    _addressController.text = widget.property.address;
    _cityController.text = widget.property.city;
    _stateController.text = widget.property.state;
    _countryController.text = widget.property.country;
    _zipCodeController.text = widget.property.zipCode;
    _pricePerNightController.text = widget.property.pricePerNight.toString();
    _maxGuestsController.text = widget.property.maxGuests.toString();
    _numBedroomsController.text = widget.property.numBedrooms.toString();
    _numBathroomsController.text = widget.property.numBathrooms.toString();
    _amenitiesController.text = widget.property.amenities;
  }

  Future<void> _updateProperty() async {
    try {
      final property = Property(
        id: widget.property.id,
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
        createdAt: widget.property.createdAt,
        updatedAt: DateTime.now(),
      );

      await Provider.of<AuthProvider>(context, listen: false).updateProperty(
        property.id,
        property.toJson(),
      );
      setState(() {
        _message = 'Propriété mise à jour avec succès';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Propriété mise à jour avec succès')));
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la mise à jour de la propriété: $e')));
    }
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Détails', style: TextStyle(color: _currentStep == 0 ? Color(0xFFF7B818) : Colors.white, fontFamily: 'Poppins')),
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
        title: Text('Emplacement', style: TextStyle(color: _currentStep == 1 ? Color(0xFFF7B818) : Colors.white, fontFamily: 'Poppins')),
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
        title: Text('Tarifs', style: TextStyle(color: _currentStep == 2 ? Color(0xFFF7B818) : Colors.white, fontFamily: 'Poppins')),
        content: Column(
          children: [
            buildTextField(_pricePerNightController, 'Prix par nuit', TextInputType.number),
            SizedBox(height: 10.0),
            buildTextField(_maxGuestsController, 'Nombre maximum d\'invités', TextInputType.number),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('Agréments', style: TextStyle(color: _currentStep == 3 ? Color(0xFFF7B818) : Colors.white, fontFamily: 'Poppins')),
        content: Column(
          children: [
            buildTextField(_numBedroomsController, 'Nombre de chambres', TextInputType.number),
            SizedBox(height: 10.0),
            buildTextField(_numBathroomsController, 'Nombre de salles de bains', TextInputType.number),
            SizedBox(height: 10.0),
            buildTextField(_amenitiesController, 'Agréments'),
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
        title: Text('Modifier la propriété', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
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
                          text: 'Modifier',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: ' Propriété',
                          style: TextStyle(color: Color(0xFFF7B818)),
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
                          _updateProperty();
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
                    controlsBuilder: (BuildContext context, ControlsDetails controls) {
                      return Column(
                        children: [
                          Row(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: controls.onStepContinue,
                                child: Text(
                                  _currentStep < _getSteps().length - 1 ? 'Continuer' : 'Mettre à jour',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF7B818),
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: controls.onStepCancel,
                                child: Text(
                                  'Annuler',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),  // Added space between fields and buttons
                        ],
                      );
                    },
                  ),
                  if (_message.isNotEmpty) ...[
                    Text(
                      _message,
                      style: TextStyle(color: Colors.green, fontFamily: 'Poppins'),
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
