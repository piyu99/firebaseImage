import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firestor;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class User1 extends StatefulWidget {
  @override
  _User1State createState() => _User1State();
}

String report=" ";
var image;
String imageurl;


class _User1State extends State<User1> {

  Future pickImage() async{
    var _image= await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState((){
      image=_image ;
    });
  }
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('User Screen')
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
        decoration: InputDecoration(
        fillColor: Colors.white,
          filled: true,

          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50)),
          hintText: 'YOUR PASSWORD',),

            onChanged: (value){
              report=value;
            },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: (){
                pickImage();
              },
            ),
//            Container(
//              child: (image==null)?Text('Select an Image'):Image.file(image)
//            ),
            // ignore: deprecated_member_use
            RaisedButton(
              child: Text('Submit'),
              color: Colors.blue,
              onPressed: (){
                UploadPic().then((value) {
                  imageurl=value;
                });
                Submit(imageurl);
                
              },
            )
          ],
        ),
      ),
    );
  }



  Submit(String imageurl){
    var doc = FirebaseFirestore.instance
        .collection("users")
        .doc("user1");

    doc.set({
      "compaint": report,
      "image": imageurl,
      "status": false,
    });

  }

  Future<String> UploadPic() async{
    File selected=File(image.path);
    String FileName=basename(image.path);
    firestor.Reference firestoreref=firestor.FirebaseStorage.instance.ref().child(FileName);
    firestor.UploadTask uploadTask=firestoreref.putFile(selected);
    firestor.TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => null);

    setState(() {
      print('uploaded');
    });

    Future<String> downloadurl= firestoreref.getDownloadURL();

    return downloadurl;
  }
}


