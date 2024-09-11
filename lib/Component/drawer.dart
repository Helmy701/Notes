import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/Component/loading.dart';
import 'package:notes/Component/setting.dart';
import 'package:notes/Component/showAvatar.dart';
// ignore: must_be_immutable
class Mydrawer extends StatelessWidget {
  late String myUsername, myEmail, myPassword, myId;
  Mydrawer(String username, String email, String password, String id) {
    myUsername = username;
    myEmail = email;
    myPassword = password;
    myId = id;
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 300,
        backgroundColor: Color(0xFF6034A6),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              padding: EdgeInsets.fromLTRB(15,50,15,15),
              decoration: BoxDecoration(
                color: Color(0xFF0F0F1E)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShowAvatar(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(myUsername, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 175,
                          child: Text(
                            "${myEmail}",
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white54, fontSize: 10,))
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      color: Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(Icons.auto_stories_rounded, color: Colors.white, size: 30,),
                    ),
                    title: Text("Notes", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Divider(color: Color(0xFF0F0F1E), indent: 15, endIndent: 15, thickness: 2,),
                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      color: Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(Icons.border_color_rounded, color: Colors.white, size: 30,),
                    ),
                    title: Text("Add Note", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).pushNamed("AddNote");
                    },
                  ),
                  Divider(color: Color(0xFF0F0F1E), indent: 15, endIndent: 15, thickness: 2,),
                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      color: Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(Icons.settings, color: Colors.white, size: 30,),
                    ),
                    title: Text("Setting", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Setting(
                        id: myId,
                        username: myUsername,
                        email: myEmail,
                        password: myPassword,
                      )));
                    },
                  ),
                  Divider(color: Color(0xFF0F0F1E), indent: 15, endIndent: 15, thickness: 2,),
                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      color: Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(Icons.handshake_outlined, color: Colors.white, size: 30,),
                    ),
                    title: Text("Help", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).pushNamed("Help");
                    },
                  ),
                  Divider(color: Color(0xFF0F0F1E), indent: 15, endIndent: 15, thickness: 2,),
                  
                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      color: Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(Icons.logout_rounded, color: Colors.white, size: 30,),
                    ),
                    title: Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Color(0xFF0F0F1E),
                            title: Text("Are you sure you want to Logout ?"),
                            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            titlePadding: EdgeInsets.symmetric(horizontal: 10),
                            icon: Icon(Icons.warning_amber_outlined, color: Colors.red, size: 60,),
                            iconPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.red, width: 4, strokeAlign: BorderSide.strokeAlignInside),
                              borderRadius: BorderRadius.circular(25)
                            ),
                            actionsPadding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                            actions: [
                              ElevatedButton(
                                onPressed: () async{
                                  showLoading(context);
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushReplacementNamed("SplashScreen");
                                },
                                child: Text("Yes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(135, 40),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60))),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("No", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                style: ElevatedButton.styleFrom(
                                          minimumSize: Size(135, 40),
                                          backgroundColor: Color(0xFF0F0F1E),
                                          foregroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: Colors.red, width: 3, strokeAlign: BorderSide.strokeAlignInside),
                                            borderRadius: BorderRadius.circular(60))),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }
}