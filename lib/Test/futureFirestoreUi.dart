import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FutureFirestore extends StatefulWidget {
  const FutureFirestore({super.key});
  @override
  State<FutureFirestore> createState() => _FutureFirestoreState();
}

class _FutureFirestoreState extends State<FutureFirestore> {
  CollectionReference userData = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: userData.get(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Text("username = ${snapshot.data!.docs[index]["username"]}");
                },
              );
            }
            if(snapshot.hasError) {
              return Text("error");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}