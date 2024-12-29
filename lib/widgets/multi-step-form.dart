import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class MultiStepForm extends StatefulWidget {
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _address = '';
  String _city = '';
  String _state = '';
  String _country = '';
  String _zipCode = '';
  double _pricePerNight = 0.0;
  List<String> _images = [];

  Future<void> _pickImages() async {
    if (kIsWeb) {
      final input = html.FileUploadInputElement()..accept = 'image/*';
      input.multiple = true;
      input.click();

      input.onChange.listen((event) {
        final files = input.files;
        if (files!.isEmpty) return;
        for (final file in files) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((event) {
            setState(() {
              _images.add(reader.result as String);
            });
          });
        }
      });
    } else {
      // Handle mobile image picking if needed
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle form submission
    }
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: Text('Basic Info'),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              onSaved: (value) => _description = value!,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Location'),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Address'),
              validator: (value) => value!.isEmpty ? 'Please enter an address' : null,
              onSaved: (value) => _address = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'City'),
              validator: (value) => value!.isEmpty ? 'Please enter a city' : null,
              onSaved: (value) => _city = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'State'),
              validator: (value) => value!.isEmpty ? 'Please enter a state' : null,
              onSaved: (value) => _state = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Country'),
              validator: (value) => value!.isEmpty ? 'Please enter a country' : null,
              onSaved: (value) => _country = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Zip Code'),
              validator: (value) => value!.isEmpty ? 'Please enter a zip code' : null,
              onSaved: (value) => _zipCode = value!,
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Pricing'),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Price per Night'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
              onSaved: (value) => _pricePerNight = double.parse(value!),
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('Photos'),
        content: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Pick Images'),
            ),
            if (_images.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _images.map((image) {
                  return Image.network(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
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
      appBar: AppBar(title: Text('Add Property')),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < _buildSteps().length - 1) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              _submitForm();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          steps: _buildSteps(),
        ),
      ),
    );
  }
}
