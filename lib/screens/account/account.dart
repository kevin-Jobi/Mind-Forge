import 'package:flutter/material.dart';
import 'package:mind_forge/screens/account/profile_widgets.dart';
import 'package:mind_forge/screens/search/search_subtopics.dart';
import 'package:mind_forge/screens/account/settings/settings.dart';
import 'package:mind_forge/services/models/model.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Model1? box;



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange[100  ],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            centerTitle: true,
            title: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2,28,45,8),
                child: Text(
                  'Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            backgroundColor: Colors.orange[600],
          ),
        ),
        body: Column(
          children: [
            UserProfileWidget(),
           
            buildProfileOption(
              icon: Icons.search,
              color: Colors.blue,
              label: 'Search Subtopics',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SearchSubtopic()),
                );
              },
            ),
            buildProfileOption(
              icon: Icons.settings,
              color: Colors.green,
              label: 'Settings',
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MySettings()))
                    .then((value) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  
}


