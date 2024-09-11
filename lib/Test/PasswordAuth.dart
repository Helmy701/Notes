import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/main.dart';

class passwordAuth extends StatefulWidget {
  const passwordAuth({super.key});

  @override
  State<passwordAuth> createState() => _passwordAuthState();
}

class _passwordAuthState extends State<passwordAuth> {


  DocumentReference mamaUser = FirebaseFirestore.instance.collection("users").doc("123456789");
  DocumentReference saraUser = FirebaseFirestore.instance.collection("users").doc("T7Zy2BKPFblf3dluniTf");


  // getData() async{
  //   CollectionReference collections = FirebaseFirestore.instance.collection("users");
  //   QuerySnapshot querySnapShot = await collections.get();
  //   List<QueryDocumentSnapshot> dataList = querySnapShot.docs;
  //   dataList.forEach((element) {
  //     print(element.data());
  //     print("============================");
  //   });
  // }

  // getData() async{
  //   CollectionReference collections = await FirebaseFirestore.instance.collection("users");
  //   collections.get().then((value){
  //     value.docs.forEach((element) {
  //       print(element.data());
  //       print("#######################################");
  //     });
  //   });
  // }
  

  // getData() async{
  //   DocumentReference collections = await FirebaseFirestore.instance.collection("users").doc("zMqFjUb9ztSEomv8PigQ");
  //   await collections.get().then((value) {
  //     if(value.exists == true){
  //       // print(value.data());
  //       print("PASSWORD = ${value["password"]}");
  //       print("******************************************************");
  //     }
  //     else{
  //       print("wrong Document");
  //       print("******************************************************");
  //     }
  //   });
  // }

  // getData() async{
  //   CollectionReference collections = await FirebaseFirestore.instance.collection("users");
  //   await collections.where("age", isEqualTo: 24).get().then((value) {
  //     value.docs.forEach(
  //       (element) {
  //         print(element.data());
  //         print(element["username"]);
  //       }
  //     );
  //   });
  // }
  
  // getData() async{
  //   CollectionReference collections = await FirebaseFirestore.instance.collection("users");
  //   await collections.orderBy("age", descending: true).get().then((value) {
  //     value.docs.forEach(
  //       (element) {
  //         print(element["username"]);
  //       }
  //     );
  //   });
  // }

  getData() async{
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      event.docs.forEach((element) { 
        print(element.data());
        print("=====================================================");
      });
    });
  }

  addData() async{
    CollectionReference createUser = await FirebaseFirestore.instance.collection("users");
    
    // createUser.add(
    //   {
    //     "usernam" : "Hanaa",
    //     "email" : "hanaamohammed512@gmail.com",
    //     "password" : "Hanaa?512613#",
    //     "age" : "45"
    //   }
    // );
    
    createUser.doc("123456789").set(
      {
        "usernam" : "Hanaa",
        "email" : "hanaamohammed512@gmail.com",
        "password" : "Hanaa?512613#",
        "age" : "45"
      }
    );
  }

  updateDataWithUpdate () async{
    CollectionReference updateUserData = await FirebaseFirestore.instance.collection("users");
    updateUserData.doc("123456789").update(
      {
        "username" : "MaMa"
      }
    );
  }
  
  updateDataWithSet () async{
    CollectionReference updateUserData = await FirebaseFirestore.instance.collection("users");
    updateUserData.doc("123456789").set(
      {
        "password" : "MaMa110010100?#"
      },
      SetOptions(merge: true)
    );
  }

  deleteUser() async {
    CollectionReference updateUserData = await FirebaseFirestore.instance.collection("users");
    updateUserData.doc("123456789").delete().then((value) {
      print("Deleted Successful");
    }).catchError((e){
      print("Error = $e");
    });
  }

  deleteUAccount() async {
    CollectionReference delAccountData = await FirebaseFirestore.instance.collection("users");
    await delAccountData.doc("$id").delete().then((value) {
      print("Delete users Info Successfully");
    }).catchError((e){
      print("Error = $e");
    });
    
    CollectionReference delAccountNotes = await FirebaseFirestore.instance.collection("notes");
    await delAccountNotes.doc("$id").delete().then((value) {
      print("Delete Notes Successfully");
    }).catchError((e){
      print("Error = $e");
    });

    Reference delImage = FirebaseStorage.instance.ref("Assets/$id");
    await delImage.delete().then((value) {
      print("Delete Image Successfully");
    }).catchError((e){
      print("Error = $e");
    });

    var delAccount = FirebaseAuth.instance.currentUser;
    await delAccount!.delete().then((value) {
      print("Delete Account Successfully");
    }).catchError((e){
      print("Error = $e");
    });

    Navigator.of(context).pushReplacementNamed("SplashScreen");
  }

  trans() async{
    FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot docSnap = await transaction.get(mamaUser);
      if(docSnap.exists){
        transaction.update(mamaUser, {
          "age" : "22"
        });
      }
      else{
        print("user not found");
      }
    });
  }

  batchWrite() async{
    WriteBatch changeUserData= await FirebaseFirestore.instance.batch();
    changeUserData.update(saraUser, {
      "username" : "Soka"
    });
    changeUserData.delete(mamaUser);
    changeUserData.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: "abdelomonemranea2000@gmail.com",
                  password: "1234567Cr7",
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }
            },
            child: Text("Password Auth")
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final credential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                  email: "abdelomonemranea2000@gmail.com",
                  password: "1234567Cr7",
                );
                print(credential.user?.email);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }
            },
            child: Text("Signin")
          ),
          ElevatedButton(
            onPressed: () => getData(),
            child: Text("Get Data")
          ),
          ElevatedButton(
            onPressed: () => addData(),
            child: Text("Add User")
          ),
          ElevatedButton(
            onPressed: () => updateDataWithUpdate(),
            child: Text("Update Data With Update")
          ),
          ElevatedButton(
            onPressed: () => updateDataWithSet(),
            child: Text("Update Data With Set")
          ),
          ElevatedButton(
            onPressed: () => deleteUser(),
            child: Text("Delete User")
          ),
          ElevatedButton(
            onPressed: () => trans(),
            child: Text("Transaction")
          ),
          ElevatedButton(
            onPressed: () => batchWrite(),
            child: Text("Batch")
          ),
        ],
      ),
    );
  }
}
