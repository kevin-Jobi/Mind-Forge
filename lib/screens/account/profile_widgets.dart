
import "package:flutter/material.dart";
import "package:mind_forge/screens/account/profile_crud.dart";
import "package:mind_forge/services/models/model.dart";
import "package:mind_forge/services/repos/boxes.dart";


// ignore: must_be_immutable
class UserProfileWidget extends StatefulWidget {
   UserProfileWidget({
    super.key,
    
  });

   

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}
 Model1? box;
class _UserProfileWidgetState extends State<UserProfileWidget> {
  void _refreshProfile(){
    setState(() {
      box = Boxes.getData1().get('profile');
    });
  }
  @override
  void initState() {
    
    super.initState();
    box = Boxes.getData1().get('profile');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.orange[200],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.orange[300]!,
          width: 5.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      padding: const EdgeInsets.all(10),
      child: Center(
        //child: widget.box == null
        child: box==null
            ? GestureDetector(
              child: Text(
                  'No profile found',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[900],
                  ),
                ),
                 onTap: () { // Wrap the Navigator call in an anonymous function
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyProfileCrud()),
        ).then((value) => _refreshProfile());
      },
            )
            :ListTile(
      //leading: widget.box!.profileImg.isNotEmpty
      leading: box!.profileImg.isNotEmpty
          ? CircleAvatar(
              radius: 30,
              //backgroundImage: MemoryImage(widget.box!.profileImg),
              backgroundImage: MemoryImage(box!.profileImg),
            )
          : Icon(Icons.person, size: 40, color: Colors.orange[600]),
      title: Text(
        //widget.box!.name,
        box!.name,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.orange[900],
        ),
      ),
      onTap: () { // Wrap the Navigator call in an anonymous function
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyProfileCrud()),
        ).then((value) => _refreshProfile());
      },
    ),
    
      ),
    );
  }
}



  Widget buildProfileOption({
    required IconData icon,
    required Color color,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.orange[200]!,
            width: 3.0,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.orange[900],
              ),
            ),
          ],
        ),
      ),
    );
  }