                  import 'package:flutter/material.dart';
import 'package:mind_forge/services/models/model.dart';
import 'package:mind_forge/services/repos/boxes.dart';

Future <void> elevatedButton(profilename,nameConroller,context,imageBytes) async {
                    profilename = nameConroller.text;
                    if (profilename.isNotEmpty && imageBytes != null) {
                      final data = Model1(name: profilename, profileImg: imageBytes!);
                      final box = Boxes.getData1();
                      box.put('profile', data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile saved successfully')),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Enter a name and select an image')),
                      );
                    }
                  }