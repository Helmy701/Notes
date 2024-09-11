import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/Crud/editNote.dart';
import 'package:notes/Component/drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  final String id;
  final String username;
  final String email;
  final String password;

  const Home(
      {required this.id,
      required this.email,
      required this.username,
      required this.password,
      super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CollectionReference notes = FirebaseFirestore.instance.collection("notes").doc(widget.id).collection("userNotes");

  void setupPushNotification() async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    log("================================");
    log(token.toString());
  }

  @override
  void initState() {
    setupPushNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("=========================================");
      log("${event.notification!.body}");
      print("=========================================");
      // Navigator.of(context).pushNamed("AddNote");
    });

    // FirebaseMessaging.onMessage.listen((event) {
    //   print("=========================================");
    //   print("${event.notification!.body}");
    //   print("=========================================");
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu, size: 30),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          }
        ),
        backgroundColor: Color(0xFF6034A6),
        foregroundColor: Colors.white,
        title: Text(widget.username, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed("AddNote"), 
            icon: Icon(Icons.add, size: 30)
          )
        ],
      ),

      drawer:Mydrawer(widget.username, widget.email, widget.password, widget.id),
      
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          color: Color(0xFF0F0F1E),
          child: StreamBuilder(
            stream: notes.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: (direction) {
                        notes.doc(snapshot.data!.docs[index]["noteId"]).delete().then((value) {
                          print("Deleted Successful");
                        }).catchError((e) {
                          print("Error = $e");
                        });
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
                        child:
                            Icon(Icons.delete, color: Colors.white, size: 35),
                      ),
                      key: Key(snapshot.data!.docs[index]["noteId"]),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [Color(0xFF4833A6), Color(0xFF6034A6)],
                              radius: 2.5,
                              focalRadius: 25
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditNote(
                                      noteId: snapshot.data!.docs[index]
                                          ["noteId"],
                                      title: snapshot.data!.docs[index]
                                          ["title"],
                                      content: snapshot.data!.docs[index]
                                          ["content"],
                                    )));
                          },
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                          leading: Icon(Icons.note,
                              color: Color(0xFF0F0F1E), size: 50),
                          title: Text("${snapshot.data!.docs[index]["title"]}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          subtitle: SizedBox(
                            width: 200,
                            child: Text(
                              "${snapshot.data!.docs[index]["content"]}",
                              style: TextStyle(
                                  color: Color(0xFFAEAEB3), fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Color(0xFF6034A6), strokeWidth: 6));
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text("Error.. Try Again Later",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)));
              }
              return Center(
                  child: Text("Write It Down Before You Forget It",
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)));
            },
          )),
    );
  }
}
