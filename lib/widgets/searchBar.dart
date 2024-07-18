import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/property.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(List<Property>) onSearchCompleted;

  CustomSearchBar({required this.onSearchCompleted});

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _addressController = TextEditingController();
  String _message = '';

  Future<void> _searchProperties() async {
    try {
      final properties = await Provider.of<AuthProvider>(context, listen: false)
          .searchProperties(address: _addressController.text);

      setState(() {
        _message = properties.isEmpty ? 'Aucune propriété trouvée' : '';
      });

      widget.onSearchCompleted(properties);
    } catch (e) {
      setState(() {
        _message = 'Échec du chargement des propriétés: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Addresse',
                  labelStyle: TextStyle(color: Color(0xFFF7B818), fontFamily: 'Poppins'),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xFFF7B818),
                      width: 2.0,
                    ),
                  ),
                ),
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: _searchProperties,
              child: Text('Rechercher', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF7B818),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        if (_message.isNotEmpty) ...[
          Text(
            _message,
            style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
          ),
          SizedBox(height: 16.0),
        ],
      ],
    );
  }
}
