import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_forge/screens/dashboard/details.dart';
import 'package:mind_forge/screens/search/filter_page.dart';
import 'package:mind_forge/services/models/model.dart';
import 'package:mind_forge/services/repos/boxes.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> topics = [];
  List<String> filteredTopics = [];
  List<Model> models = [];
  bool _isExamsChecked = false;
  bool _isAssignmentsChecked = false;
  DateTime? _selectedDate;

  getAllTopics() {
    final box = Boxes.getData();
    for (var model in box.values) {
      topics.add(model.subject);
      models.add(model);
    }
    return topics;
  }

  @override
  void initState() {
    super.initState();
    getAllTopics();
    filteredTopics = topics;
  }

  void filterSearchResults(String query) {
    setState(() {
      if (_isExamsChecked || _isAssignmentsChecked) {
        filteredTopics = [];
        for (var model in models) {
          if (_isExamsChecked && model.exams.isNotEmpty) {
            for (var i = 0; i < model.exams.length; i++) {
              if (model.examDates[i] == query) {
                filteredTopics.add("Exam: ${model.exams[i]} (${model.subject})");
              }
            }
          }
          if (_isAssignmentsChecked && model.assignments.isNotEmpty) {
            for (var i = 0; i < model.assignments.length; i++) {
              if (model.assignmentDeadlines![i] == query) {
                filteredTopics.add("Assignment: ${model.assignments[i]} (${model.subject})");
              }
            }
          }
        }
      } else {
        filteredTopics = topics
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        filterSearchResults(DateFormat('dd-MM-yyyy').format(_selectedDate!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text('Search Topics'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FilterPage(
                    isExamsChecked: _isExamsChecked,
                    isAssignmentsChecked: _isAssignmentsChecked,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  _isExamsChecked = result['isExamsChecked'];
                  _isAssignmentsChecked = result['isAssignmentsChecked'];
                  if (_isExamsChecked || _isAssignmentsChecked) {
                    _showDatePicker();
                  } else {
                    _selectedDate = null;
                    filteredTopics = topics;
                  }
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTap: () {
                if (_isExamsChecked || _isAssignmentsChecked) {
                  _showDatePicker();
                }
              },
              readOnly: _isExamsChecked || _isAssignmentsChecked,
              onChanged: (value) {
                if (!(_isExamsChecked || _isAssignmentsChecked)) {
                  filterSearchResults(value);
                }
              },
              decoration: InputDecoration(
                labelText: _isExamsChecked || _isAssignmentsChecked
                    ? 'Select Date'
                    : 'Search',
                hintText: _isExamsChecked || _isAssignmentsChecked
                    ? _selectedDate != null
                        ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
                        : 'Tap to select date'
                    : 'Enter search term',
                labelStyle: TextStyle(color: Colors.green[900]),
                prefixIcon: Icon(
                  _isExamsChecked || _isAssignmentsChecked ? Icons.calendar_today : Icons.search,
                  color: Colors.green[900],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.green[900]!, width: 3.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.green[700]!, width: 3.0),
                ),
              ),
              cursorColor: Colors.green[700],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (filteredTopics.isNotEmpty) ...[
                  ListTile(
                    title: Text(
                      'Results',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                  ...filteredTopics.map((item) {
                    final model = models.firstWhere(
                      (model) => model.subject == item.split(' (').last.replaceAll(')', '') ||
                                 model.exams.contains(item.split(': ').last.split(' (').first) ||
                                 model.assignments.contains(item.split(': ').last.split(' (').first),
                      orElse: () => Model(
                        subject: '',
                        duration: '',
                        subtopic: [],
                        links: [],
                        images: [],
                        assignments: [],
                        exams: [],
                        assignmentDeadlines: [],
                        assignmentDescriptions: [],
                        examDates: [],
                        examDescriptions: [],
                        subtopicChecked: [],
                      ),
                    );
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: GestureDetector(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: Colors.green[900],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => MyDetails(
                                      assignments: model.assignments,
                                      subject: model.subject,
                                      subTopics: model.subtopic,
                                      imageList: model.images,
                                      linkList: model.links,
                                      exams: model.exams,
                                      ModelKey: model.key,
                                      model: model,
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ] else ...[
                  ListTile(
                    title: Text(
                      'No Results Found',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}