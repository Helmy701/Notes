import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreUi extends StatefulWidget {
  const FireStoreUi({super.key});
  @override
  State<FireStoreUi> createState() => _FireStoreUiState();
}

class _FireStoreUiState extends State<FireStoreUi> {
  List listData = [];
  CollectionReference userData = FirebaseFirestore.instance.collection("users");

  showData() async{
    QuerySnapshot data = await userData.get();
    data.docs.forEach((element) {
      setState(() {
        listData.add(element.data());
      });
    });
    print(listData);
  }

  @override
  void initState() {
    showData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listData == listData.isEmpty ? CircularProgressIndicator() : ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${listData[index]["username"]}"),
            subtitle: Text("${listData[index]["email"]}"),
          );
        },
      ),
    );
  }
}