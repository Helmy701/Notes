import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ShowAvatar extends StatelessWidget {
  static Future<Image> getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? img = prefs.getString("avatar");
    Uint8List bytes = base64Decode(img!);
    return Image.memory(bytes);
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          barrierColor: Colors.black.withOpacity(0.75),
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Color(0xFF0F0F1E),
              insetPadding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                child: FutureBuilder(
                  future: getImage(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Image(image: snapshot.data!.image, fit: BoxFit.cover);
                    }
                    else{
                      return Center(child: CircularProgressIndicator(color: Color(0xFF6034A6), strokeWidth: 6,));
                    }
                  },
                )
              ),
            );
          },
        );
      },
      child: CircleAvatar(
        backgroundColor: Color(0xFF6034A6),
        radius: 40,
        child: Container(
          width: 75,
          height: 75,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Color(0xFF0F0F1E),
            borderRadius: BorderRadius.circular(360)
          ),
          child: FutureBuilder(
            future: getImage(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Image(image: snapshot.data!.image, fit: BoxFit.cover,);
              }
              else{
                return CircularProgressIndicator();
              }
            },
          )
        ),
      ),
    );
  }
}





