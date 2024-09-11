import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/Component/loading.dart';
import 'package:notes/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupAndLoginValidation {
  final BuildContext context;
  final String email;
  final String password;

  SignupAndLoginValidation({
    required this.context,
    required this.email,
    required this.password,
  });

  static Future<bool> saveImage(List<int> imageBytes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    return prefs.setString("avatar", base64Image);
    
  }

  signUpValidation(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      showLoading(context);
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String id = credential.user!.uid;
      CollectionReference userId = await FirebaseFirestore.instance.collection("users");
      userId.doc(id).set({
        "username" : username,
        "email" : email,
        "password" : password,
      });
      prefs.setString("id", id);
      prefs.setString("username", username);
      prefs.setString("email", email);
      prefs.setString("password", password);
      String imageName = "avatar";
      String img = "Assets/avatar.png";
      final Directory systemTempDir = Directory.systemTemp;
      final byteData = await rootBundle.load(img);
      final file = File('${systemTempDir.path}/$imageName.png');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      Reference  refStorage = FirebaseStorage.instance.ref("Assets/$id/avatarImage");
      await refStorage.putFile(file);
      String url = await refStorage.getDownloadURL();
      http.Response response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        saveImage(response.bodyBytes);
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(
        id: id,
        username: username,
        email: email,
        password: password,
      )));
      return credential;
    }
    on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      }
      else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xFF0F0F1E),
              title: Text("The account already exists for that email"),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              titlePadding: EdgeInsets.symmetric(horizontal: 10),
              icon: Icon(Icons.email, color: Colors.red, size: 60,),
              iconPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.red, width: 4, strokeAlign: BorderSide.strokeAlignInside),
                borderRadius: BorderRadius.circular(25)
              ),
              actionsPadding: EdgeInsets.fromLTRB(10, 10, 10, 20),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("Login");
                  },
                  child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                  child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
      }
    } 
    catch (e) {
      print(e);
    }
  }

  loginValidation() async{
    late String username;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      showLoading(context);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      String id = credential.user!.uid;
      CollectionReference user = await FirebaseFirestore.instance.collection("users");
      await user.doc(id).get().then((value) {
        if(value.exists){
          username = value["username"];
        }
      });
      await prefs.setString("id", id);
      await prefs.setString("username", username);
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      Reference  refStorage = FirebaseStorage.instance.ref("Assets/$id/avatarImage");
      String url = await refStorage.getDownloadURL();
      http.Response response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        saveImage(response.bodyBytes);
      }
      await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(
        id: id,
        username: username,
        email: email,
        password: password,
      )));
      return credential;
    } 
    on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xFF0F0F1E),
              title: Text("No user found for that email"),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              titlePadding: EdgeInsets.symmetric(horizontal: 15),
              icon: Icon(Icons.email, color: Colors.red, size: 60,),
              iconPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.red, width: 4, strokeAlign: BorderSide.strokeAlignInside),
                borderRadius: BorderRadius.circular(25)
              ),
              actionsPadding: EdgeInsets.fromLTRB(10, 10, 10, 20),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("SignUp");
                  },
                  child: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                  child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
      }
      else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color(0xFF0F0F1E),
              title: Text("Wrong password"),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              titlePadding: EdgeInsets.symmetric(horizontal: 30),
              icon: Icon(Icons.privacy_tip_sharp, color: Colors.red, size: 60,),
              iconPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.red, width: 4, strokeAlign: BorderSide.strokeAlignInside),
                borderRadius: BorderRadius.circular(25)
              ),
              actionsPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                            minimumSize: Size(135, 40),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60))),
                )
              ],
            );
          },
        );
      }
    }
  }
  
}