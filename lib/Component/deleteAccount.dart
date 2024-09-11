import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'loading.dart';

delAccount(context, String id, String email, String password) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Color(0xFF0F0F1E),
        title: Text("Are you sure you want to Delete Account ?"),
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
              CollectionReference delAccountData = FirebaseFirestore.instance.collection("users");
              await delAccountData.doc(id).delete().then((value) {
                print("Delete users Info Successfully");
              }).catchError((e){
                Navigator.of(context).pop();
                print("Error = $e");
              });
              CollectionReference delAccountNotes = FirebaseFirestore.instance.collection("notes");
              await delAccountNotes.doc(id).delete().then((value) {
                print("Delete Notes Successfully");
              }).catchError((e){
                Navigator.of(context).pop();
                print("Error = $e");
              });
              ListResult delImage = await FirebaseStorage.instance.ref("Assets/$id").list();
              delImage.items.forEach((element) {
                element.delete().then((value) {
                  print("Delete Image Successfully");
                }).catchError((e){
                  Navigator.of(context).pop();
                  print("Error = $e");
                });
              });
              User? delAccount = FirebaseAuth.instance.currentUser;
              AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
              await delAccount!.reauthenticateWithCredential(credential).then((value) {
                value.user!.delete().then((value) {
                  print("Delete Account Successfully");
                }).catchError((e){
                  Navigator.of(context).pop();
                  print("Error = $e");
                });
              },);
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
    }
  );
}

