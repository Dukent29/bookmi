import 'package:flutter/material.dart';
import 'add_property_view.dart';

class AnnounceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announce'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPropertyView()),
            );
          },
          child: Text('Add Property'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
        ),
      ),
    );
  }
}
