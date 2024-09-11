import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class FFStorage extends StatefulWidget {
  const FFStorage({super.key});

  @override
  State<FFStorage> createState() => _FFStorageState();
}

class _FFStorageState extends State<FFStorage> {
  
 
  void img () async{
    String imageName = "avatar";
    String img = "Assets/avatar.png";
    final Directory systemTempDir = Directory.systemTemp;
    final byteData = await rootBundle.load(img);
    final file = File('${systemTempDir.path}/$imageName.png');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    Reference  refStorage = FirebaseStorage.instance.ref("Assets/id/Avatar");
    await refStorage.putFile(file);
    String url = await refStorage.getDownloadURL();
    print("url = $url");
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  ImagePicker imgpicker = ImagePicker();

  uploadImage() async{
    XFile? img = await imgpicker.pickImage(source: ImageSource.camera);
    if(img != null){
      File file = File(img.path);
      String imgName = basename(img.path);
      Reference  refStorage = FirebaseStorage.instance.ref("Assets/$imgName");
      await refStorage.putFile(file);
      String url = await refStorage.getDownloadURL();
      print("url = $url");
    }
    else{
      print("there is no image");
    }
  }

  uploadImage2() async{
    File f = await getImageFileFromAssets('Assets/avatar.png');
    Reference  refStorage = FirebaseStorage.instance.ref("Assets/image/avatar");
    await refStorage.putFile(f);
    String url = await refStorage.getDownloadURL();
    print("url = $url");
  }


  getImage() async{
    var refStorage = await FirebaseStorage.instance.ref("Assets").list(ListOptions(maxResults: 3));
    var refFoldersStorage = await FirebaseStorage.instance.ref().list();

    refStorage.items.forEach((element) {
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      print(element.name);
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    });

    refFoldersStorage.prefixes.forEach((element) {
      print("=========================================");
      print(element.name);
      print("=========================================");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.black54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            ElevatedButton(
              onPressed: ()=> img(),
              child: Text("Upload Image")
            ),
            // ElevatedButton(
            //   onPressed: ()=> getImage(),
            //   child: Text("Get Image")
            // )
          ],
        ),
      ),
    );
  }
}