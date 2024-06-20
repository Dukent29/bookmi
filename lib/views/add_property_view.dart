import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';

class AddPropertyView extends StatefulWidget {
  @override
  _AddPropertyViewState createState() => _AddPropertyViewState();
}

class _AddPropertyViewState extends State<AddPropertyView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _pricePerNightController = TextEditingController();
  final TextEditingController _maxGuestsController = TextEditingController();
  final TextEditingController _numBedroomsController = TextEditingController();
  final TextEditingController _numBathroomsController = TextEditingController();
  final TextEditingController _amenitiesController = TextEditingController();

  String _message = '';

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

      await Provider.of<AuthProvider>(context, listen: false).addProperty(property);
      setState(() {
        _message = 'Property added successfully';
      });
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Property'),
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
                        text: 'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: ' Property',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                buildTextField(_titleController, 'Title'),
                SizedBox(height: 10.0),
                buildTextField(_descriptionController, 'Description'),
                SizedBox(height: 10.0),
                buildTextField(_addressController, 'Address'),
                SizedBox(height: 10.0),
                buildTextField(_cityController, 'City'),
                SizedBox(height: 10.0),
                buildTextField(_stateController, 'State'),
                SizedBox(height: 10.0),
                buildTextField(_countryController, 'Country'),
                SizedBox(height: 10.0),
                buildTextField(_zipCodeController, 'Zip Code'),
                SizedBox(height: 10.0),
                buildTextField(_pricePerNightController, 'Price Per Night', TextInputType.number),
                SizedBox(height: 10.0),
                buildTextField(_maxGuestsController, 'Max Guests', TextInputType.number),
                SizedBox(height: 10.0),
                buildTextField(_numBedroomsController, 'Number of Bedrooms', TextInputType.number),
                SizedBox(height: 10.0),
                buildTextField(_numBathroomsController, 'Number of Bathrooms', TextInputType.number),
                SizedBox(height: 10.0),
                buildTextField(_amenitiesController, 'Amenities'),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addProperty,
                    child: Text(
                      'Add Property',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  _message,
                  style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
                ),
              ],
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
