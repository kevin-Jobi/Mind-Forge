import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_forge/screens/account/sav_profile.dart';
import 'package:mind_forge/services/repos/boxes.dart';

class MyProfileCrud extends StatefulWidget {
  const MyProfileCrud({super.key});

  @override
  State<MyProfileCrud> createState() => _MyProfileCrudState();
}

class _MyProfileCrudState extends State<MyProfileCrud> {
  TextEditingController nameConroller = TextEditingController();
  String profilename = "";
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    final profile = Boxes.getData1().get('profile');
    if (profile != null) {
      nameConroller.text = profile.name;
      imageBytes = profile.profileImg;
    }
  }

  Future<void> pickAndStoreImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: 29, color: Colors.white),
            ),
          ),
          backgroundColor: Colors.orange[600],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 50, 28, 8),
        child: Container(
          height: 450,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.orange[100],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                GestureDetector(
                  onTap: pickAndStoreImage,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      image: DecorationImage(
                        image: imageBytes == null
                            ? AssetImage('assets/images/Ellipse 1.png')
                            : MemoryImage(imageBytes!) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: TextField(
                    controller: nameConroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 50,
                    ),
                    elevation: 5,
                  ),
                  onPressed: 
                (){
                    elevatedButton(profilename,nameConroller,context,imageBytes);
                },
                  child: Text("Submit", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
