import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StreamFiretore extends StatefulWidget {
  const StreamFiretore({super.key});
  @override
  State<StreamFiretore> createState() => _StreamFiretoreState();
}

class _StreamFiretoreState extends State<StreamFiretore> {

  CollectionReference users = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
        child: StreamBuilder(
          stream: users.snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Text("${snapshot.data!.docs[index]["username"]}", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold));
                },
              );
            }
            if(snapshot.hasError){
              return Text("User Not Found", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
// Text("data", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))