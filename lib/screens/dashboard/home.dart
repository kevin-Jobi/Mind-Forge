import 'package:flutter/material.dart';
import 'package:mind_forge/screens/assignments/viewAsmts.dart';
import 'package:mind_forge/screens/dashboard/my_home_content.dart';
import 'package:mind_forge/screens/exam/exam.dart';
import 'package:mind_forge/screens/media/media.dart';
import 'package:mind_forge/screens/account/account.dart';
import 'package:mind_forge/screens/search/search_topics.dart';
import 'package:mind_forge/services/models/model.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _currentIndex = 0;
  final List<Widget> _btmScreens = [
    MyHomeContent(),
    Media(),
    MyAssignments(),
    MyExams(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _currentIndex == 0
            ? PreferredSize(
                preferredSize: Size.fromHeight(85),
                child: AppBar(
                  centerTitle: true,
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
                    child: Text(
                      'TOPICS',
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyProfile(),
                            ),
                          );
                        },
                        icon: Icon(Icons.more_vert, color: Colors.white),
                      ),
                    ),
                  ],
                  backgroundColor: Colors.orange[600],
                ),
              )
            : null,
        //--------------------------------------- body: -------------------------------- start
        body: _btmScreens[_currentIndex],
        //--------------------------------------- body: -------------------------------- end
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.orange[600],
          unselectedItemColor: Colors.orange[200],
          backgroundColor: Color.fromARGB(255, 73, 117, 75),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Media',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Assignment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz_rounded),
              label: 'Exam',
            ),
          ],
        ),
      ),
    );
  }

  void delete(Model model) async {
    await model.delete();
  }
}
