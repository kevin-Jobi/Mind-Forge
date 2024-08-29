import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_forge/screens/account/profile_widgets.dart';
import 'package:mind_forge/screens/tabbar/subTopics.dart';
import 'package:mind_forge/services/models/model.dart';
import 'package:mind_forge/services/repos/boxes.dart';
//import 'package:audioplayers/audioplayers.dart';


class PomodoroModel extends ChangeNotifier {
  Map<String, SubtopicTimer> _subtopicTimers = {};
  String _currentSubtopic = '';
  Model? _model;

  String get currentSubtopic => _currentSubtopic;

  int get timeRemaining => _subtopicTimers[_currentSubtopic]?.timeRemaining ?? 1500;
  bool get isRunning => _subtopicTimers[_currentSubtopic]?.isRunning ?? false;
  bool isSubtopicCompleted(String subtopic) => _subtopicTimers[subtopic]?.isCompleted ?? false;

  void setModel(Model model) {
    _model = model;
  }

   void initializeSubtopicTimers(List<String> subtopics) {
    for (String subtopic in subtopics) {
      if (!_subtopicTimers.containsKey(subtopic)) {
        _subtopicTimers[subtopic] = SubtopicTimer();
        _subtopicTimers[subtopic]!.addListener(notifyListeners);
      }
    }
  }

  void setSubtopic(String subtopic) {
    _currentSubtopic = subtopic;
    if (!_subtopicTimers.containsKey(subtopic)) {
      _subtopicTimers[subtopic] = SubtopicTimer();
      _subtopicTimers[subtopic]!.addListener(notifyListeners);
    }
    notifyListeners();
  }

  void startPomodoro(BuildContext context) {
    if (_currentSubtopic.isNotEmpty) {
      _subtopicTimers[_currentSubtopic]?.startTimer(context, _currentSubtopic,this);
    }
  }

  void stopPomodoro() {
    if (_currentSubtopic.isNotEmpty) {
      _subtopicTimers[_currentSubtopic]?.stopTimer();
    }
  }

  void resetPomodoro(int minutes) {
    if (_currentSubtopic.isNotEmpty) {
      _subtopicTimers[_currentSubtopic]?.resetTimer(minutes);
    }
  }

  SubtopicTimer? getSubtopicTimer(String subtopic) {
    return _subtopicTimers[subtopic];
  }

  void markSubtopicCompleted(String subtopic) {
    if (subtopic.isNotEmpty) {
      _subtopicTimers[subtopic]?.markCompleted();
      updateSubtopicCheckedStatus(subtopic, true);
      notifyListeners();
    }
  }

 void updateSubtopicCheckedStatus(String subtopic, bool isChecked) {
    if (_model != null) {
      int index = _model!.subtopic.indexOf(subtopic);
      if (index != -1) {
        _model!.subtopicChecked[index] = isChecked;
        _model!.save();
        notifyListeners();
      }
    }
  }

}

class SubtopicTimer extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _timeRemaining = 1500;
  bool _isRunning = false;
  bool _isCompleted = false;
  Timer? _timer;

  int get timeRemaining => _timeRemaining;
  bool get isRunning => _isRunning;
  bool get isCompleted => _isCompleted;

  void startTimer(BuildContext context, String subtopic, PomodoroModel pomodoroModel) {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_timeRemaining > 0) {
          _timeRemaining--;
          notifyListeners();
        } else {
          stopTimer();
          _playBeepSound();
          showCompletionDialog(context, subtopic, pomodoroModel);
        }
      });
      notifyListeners();
    }
  }

  void stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void resetTimer(int minutes) {
    stopTimer();
    _timeRemaining = minutes * 60;
    _isCompleted = false;
    notifyListeners();
  }

  void markCompleted() {
    _isCompleted = true;
    notifyListeners();
  }

  // void _playBeepSound()async{
  //   await _audioPlayer.play(AssetSource('assets/sounds/beep.mpeg'));
  // }
  
  // void _stopBeepSound()async{
  //   await _audioPlayer.stop();
  // }

//   void _playBeepSound() async {
//   try {
//     await _audioPlayer.play(AssetSource('assets/sounds/beep.mpeg'));
//     print('Beep sound played.');
//   } catch (e) {
//     print('Error playing sound: $e');
//   }
// }

Future<void> _playBeepSound() async{
  try{
    await _audioPlayer.release();
    await _audioPlayer.setSource(AssetSource('sounds/beep.mpeg'));
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.resume();
   
  } catch(e){
    print('Error playing sound: $e');
  }
}

void _stopBeepSound() async {
  try {
    await _audioPlayer.stop();
    await _audioPlayer.release();
    print('Beep sound stopped.');
  } catch (e) {
    print('Error stopping sound: $e');
  }
}

  void showCompletionDialog(BuildContext context, String subtopic, PomodoroModel pomodoroModel) {
  //Box<Model> boxes;
  showDialog(
    
    context: context,
    builder: (BuildContext context) {
      //Boxes model =Boxes.getData() as Boxes;
      return AlertDialog(
        title: Text('Timer Finished'),
        content: Text('Did you cover it properly?'),
        actions: [
          TextButton(
            onPressed: () {
              _stopBeepSound();
              pomodoroModel.markSubtopicCompleted(subtopic);
               Navigator.of(context).pop(); 
              
              },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              _stopBeepSound();
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
        ],
      );
    },
  );
}
}










