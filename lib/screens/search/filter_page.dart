

import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final bool isExamsChecked;
  final bool isAssignmentsChecked;

  FilterPage({
    required this.isExamsChecked,
    required this.isAssignmentsChecked,
  });

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late bool _isExamsChecked;
  late bool _isAssignmentsChecked;

  @override
  void initState() {
    super.initState();
    _isExamsChecked = widget.isExamsChecked;
    _isAssignmentsChecked = widget.isAssignmentsChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          CheckboxListTile(
            title: Text('Exams'),
            value: _isExamsChecked,
            onChanged: (bool? value) {
              setState(() {
                _isExamsChecked = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Assignments'),
            value: _isAssignmentsChecked,
            onChanged: (bool? value) {
              setState(() {
                _isAssignmentsChecked = value!;
              });
            },
          ),
          ElevatedButton(
            child: Text('Apply Filters'),
            onPressed: () {
              Navigator.pop(context, {
                'isExamsChecked': _isExamsChecked,
                'isAssignmentsChecked': _isAssignmentsChecked,
              });
            },
          ),
        ],
      ),
    );
  }
}