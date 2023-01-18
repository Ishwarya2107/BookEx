import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Addpage extends StatefulWidget {
  const Addpage({Key? key}) : super(key: key);

  @override
  State<Addpage> createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('my-book-exchange');
  CollectionReference _ref = FirebaseFirestore.instance.collection('exchange');
  String imageUrl = '';
  late String title;
  late String place;
  late String note;
  User? loggedInUser;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final FirstUser = ModalRoute.of(context)?.settings.arguments as Map;
    return Expanded(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Add"),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            SizedBox(
              height: h / 20,
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: 'Title'),
              onChanged: (value) {
                title = value;
              },
            ),
            SizedBox(
              height: h / 20,
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: 'Place'),
              onChanged: (value) {
                place = value;
              },
            ),
            SizedBox(
              height: h / 20,
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: 'Include a note'),
              maxLines: 5,
              onChanged: (value) {
                note = value;
              },
            ),
            SizedBox(
              height: h / 20,
            ),
            IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(child: CircularProgressIndicator());
                    });
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                    await imagePicker.pickImage(source: ImageSource.camera);

                if (file == null) return;
                String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();
                print(uniqueFileName);

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('images');

                Reference referenceImageToUpload =
                    referenceDirImages.child(uniqueFileName);

                try {
                  await referenceImageToUpload.putFile(File(file.path));
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                  print(imageUrl);
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(Icons.camera_alt_rounded),
            ),
            SizedBox(
              height: h / 20,
            ),
            FlatButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(child: CircularProgressIndicator());
                    });
                Map<String, String?> dataToSend = {
                  'image': imageUrl,
                  'title': title,
                  'place': place,
                  'note': note,
                  'email': loggedInUser?.email
                };

                _reference.add(dataToSend);
                if (FirstUser['first_register'] == true) {
                  final first_book = <String, dynamic>{
                    'book_id': {title: []},
                  };

                  _ref.doc(FirstUser['email']).set(first_book);
                }
                if (FirstUser['first_register'] == false) {
                  _ref.doc(loggedInUser?.email).update(
                    {'book_id.${title}': FieldValue.arrayUnion([])},
                  );
                }
                Fluttertoast.showToast(
                    msg: "Your book is added successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.pop(context);

              },
              child: Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black87,
            )
          ],
        ),
      ),
    );
  }
}

Widget button() {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      margin: const EdgeInsets.only(
        left: 20,
        bottom: 20,
      ),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            offset: Offset(2, 2),
            blurRadius: 10,
          )
        ],
      ),
      child: Center(
        child: Icon(
          Icons.camera_alt_rounded,
        ),
      ),
    ),
  );
}
