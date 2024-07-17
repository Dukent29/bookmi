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
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Addresse',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchProperties,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _searchProperties,
          child: Text('Search'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
        ),
        SizedBox(height: 16.0),
        if (_message.isNotEmpty) ...[
          Text(
            _message,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 16.0),
        ],
      ],
    );
  }
}
