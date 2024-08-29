import 'package:flutter/material.dart';
import 'package:mind_forge/screens/dashboard/details.dart';
import 'package:mind_forge/screens/tabbarfab/add_new_subtopics.dart';
import 'package:mind_forge/screens/timer/pomodoro_model.dart';
import 'package:mind_forge/screens/timer/timer.dart';
import 'package:mind_forge/services/models/model.dart';
import 'package:mind_forge/services/repos/boxes.dart';
import 'package:provider/provider.dart';

class Subtopics extends StatefulWidget {
  final MyDetails? widget;
  final Model? model;

   Subtopics({Key? key,  this.widget,  this.model}) : super(key: key);

  @override
  State<Subtopics> createState() => _SubtopicsState();
}

class _SubtopicsState extends State<Subtopics> {
  final TextEditingController _subTopicEditController = TextEditingController();
  String newSubTopic = '';

  void _showAlertDialog(BuildContext context, int index, Model model) {
    _subTopicEditController.text = model.subtopic[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                'Edit Subtopic',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _subTopicEditController,
                    decoration: InputDecoration(
                      hintText: 'Subtopic',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 114, 202, 119),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      newSubTopic = _subTopicEditController.text;
                      if (_subTopicEditController.text.isNotEmpty) {
                        model.subtopic[index] = newSubTopic;
                        final box = Boxes.getData();
                        box.put(model.key, model);
                        setState(() {});
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in the subtopic'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  void deleteSubtopic(Model model, String valueToRemove) async {
    int index = model.subtopic.indexOf(valueToRemove);
    // model.subtopic.remove(valueToRemove);
    // await model.save();
    // setState(() {});
    if (index !=-1){
      model.subtopic.removeAt(index);
      model.subtopicChecked.removeAt(index);
      await model.save();
      setState(() { });
    }
  }

bool isChecked = false;
  @override
  // void initState() {
  //   super.initState();
  // _isChecked = false;
  // if (widget.model.subtopicChecked.length != widget.model.subtopic.length){
  //   widget.model.subtopicChecked = List.generate(widget.model.subtopic.length, (_) => false);
  // }
  // }

  @override
void initState() {
  super.initState();
  //_isChecked = false;
  if (widget.model!.subtopicChecked.length != widget.model!.subtopic.length) {
    widget.model!.subtopicChecked = List.generate(widget.model!.subtopic.length, (_) => false);
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final pomodoroModel = context.read<PomodoroModel>();
      pomodoroModel.setModel(widget.model!);
   pomodoroModel.initializeSubtopicTimers(widget.model!.subtopic);
      });
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text('Subtopics'),
        backgroundColor: Colors.green[700],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: widget.model!.subtopic.length,
          itemBuilder: (context, index) {
            var subtopicData = widget.model!.subtopic[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: 
          ListTile(
  title: Text(
    subtopicData??'',
    style: TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.green[900],
    ),
  ),
  onTap: () {
     final pomodoroModel = context.read<PomodoroModel>();
    pomodoroModel.setSubtopic(subtopicData);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PomodoroScreen()));
  },
  trailing: Row(
    mainAxisSize: MainAxisSize.min, // Add this line
    children: [
    
      Checkbox(
  value: widget.model!.subtopicChecked[index],
  onChanged: (bool? newValue) {
    setState(() {
      widget.model!.subtopicChecked[index] = newValue!;
        widget.model!.save();
    context.read<PomodoroModel>().updateSubtopicCheckedStatus(subtopicData, newValue);
    });
  
  },
),
      PopupMenuButton(
        onSelected: (value) {
          if (value == 'edit') {
            _showAlertDialog(context, index, widget.model!);
          } else if (value == 'delete') {
            deleteSubtopic(widget.model!, subtopicData);
            setState(() {
              
            });
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit, color: Colors.green[800]),
              title: Text('Edit'),
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete'),
            ),
          ),
        ],
      ),
    ],
  ),
)
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new subtopic page
          // You'll need to create a NewSubtopics widget similar to NewAssignments
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewSubtopics(model: widget.model!))).then((value) => setState(() {}));
        },
        backgroundColor: Colors.deepOrange[600],
        child: Icon(Icons.add),
      ),
    );
  }
}