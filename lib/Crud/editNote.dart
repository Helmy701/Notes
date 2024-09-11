import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNote extends StatefulWidget{
  final String noteId;
  final String title;
  final String content;

  const EditNote({
    required this.noteId,
    required this.title,
    required this.content,
    super.key
  });
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote>{
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  late TextEditingController titleController = new TextEditingController(text: widget.title);
  late TextEditingController contentController = new TextEditingController(text: widget.content);
  late String id;
  late String username;
  late String email;  

  getUserID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id")??"";
    username = prefs.getString("username")??"";
    email = prefs.getString("email")??"";
  }

  @override
  void initState() {
    getUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6034A6),
          foregroundColor: Colors.white,
          leadingWidth: 150,
          leading: InkWell(
            onTap: () async{
              if(titleController.text != "" || contentController.text != ""){
                CollectionReference noteUpdate = await FirebaseFirestore.instance.collection("notes").doc(id).collection("userNotes");
                noteUpdate.doc(widget.noteId).update({
                  "title" : titleController.text,
                  "content" : contentController.text,
                }).then((value) {
                  print("Updated Successfully");
                }).catchError((e){
                  print("Error = $e");
                });
                Navigator.of(context).pop();
              }
              else if(titleController.text == "" && contentController.text == ""){
                CollectionReference noteUpdate = await FirebaseFirestore.instance.collection("notes").doc(id).collection("userNotes");
                noteUpdate.doc(widget.noteId).delete().then((value) {
                  print("Deleted Successfully");
                }).catchError((e){
                  print("Error = $e");
                });
                Navigator.of(context).pop();
              }
              else{
                Navigator.of(context).pop();
              }
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 25),
                ),
                Text("Notes", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
          ),
          actions: [
            MediaQuery.of(context).viewInsets.bottom != 0 ?
            Container(alignment: Alignment.center,
            padding: EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: ()=> FocusScope.of(context).unfocus(),
                child: Text("Done", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white))
              ),
            ):
            SizedBox()
          ],
        ),
        body: 
          Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            color: Color(0xFF0F0F1E),
            child:SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formState,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.multiline,
                      maxLength: 65,
                      maxLines: null,
                      cursorColor: Color(0xFF6034A6),
                      style: TextStyle(color: Colors.white ,fontSize: 30, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        fillColor: Colors.white,
                        focusColor: Color(0xFF6034A6),
                        hintText: "title",
                        counterText: "",
                        hintStyle: TextStyle(color: Colors.white30 ,fontSize: 26) ,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none
                        )
                      ),
                    ),
                    TextFormField(
                      controller: contentController,
                      keyboardType: TextInputType.multiline,
                      minLines: 18,
                      maxLines: null,
                      cursorColor: Color(0xFF6034A6),
                      style: TextStyle(color: Colors.white ,fontSize: 18),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        fillColor: Colors.white,
                        focusColor: Color(0xFF6034A6),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none
                        )
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}