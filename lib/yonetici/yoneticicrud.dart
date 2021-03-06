import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; //for date format

File image;
String fileName;

class CommonThings {
  static Size size;
}

class YoneticiCrud extends StatefulWidget {
  @override
  _YoneticiCrudState createState() => _YoneticiCrudState();
}

class _YoneticiCrudState extends State<YoneticiCrud> {
  TextEditingController recipeInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;
  TextEditingController fiyatTextiKumandasi = TextEditingController();

  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String recipe;
  int fiyat;
  bool shop = false;
  bool siparis = false;
  bool kurye = false;

  pickerCam() async {
    // ignore: deprecated_member_use
    File img = await ImagePicker.pickImage(source: ImageSource.camera);

    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    // ignore: deprecated_member_use
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  void createData() async {
    DateTime now = DateTime.now();
    String atilmaZaman = DateFormat("kk:mm:ss:MMMMd").format(now);
    var fullImageName = "atilma-$atilmaZaman" + ".jpg";
    var fullImageName2 = "atilma-$atilmaZaman" + ".jpg";

    final Reference ref = FirebaseStorage.instance.ref().child(fullImageName);
    final UploadTask task = ref.putFile(image);

    var part1 =
        "https://firebasestorage.googleapis.com/v0/b/mobileproject-dc69b.appspot.com/o/";

    var fullPathImage = part1 + fullImageName2;
    print(fullPathImage);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection("yayınlanan").add({
        "name": "$name",
        "recipe": "$recipe",
        "image": "$fullPathImage",
        "fiyat": fiyat,
        "shop": shop,
        "siparis": siparis,
        "kurye": kurye,
      });
      setState(() {
        // ignore: deprecated_member_use
        id = ref.documentID;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ekleme Sayfası"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    new Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.blueAccent),
                      ),
                      padding: new EdgeInsets.all(5.0),
                      child: image == null
                          ? Text("Yükleme Yapın")
                          : Image.file(image),
                    ),
                    Divider(),
                    new IconButton(
                      icon: new Icon(Icons.camera_alt),
                      onPressed: pickerCam,
                    ),
                    Divider(),
                    new IconButton(
                      icon: new Icon(Icons.image),
                      onPressed: pickerGallery,
                    )
                  ],
                ),
                new Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name",
                      fillColor: Colors.grey,
                      filled: true,
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Lütfen aynı texti bir daha girin";
                      }
                    },
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    controller: fiyatTextiKumandasi,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Fiyat",
                      fillColor: Colors.grey,
                      filled: true,
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Lütfen aynı texti bir daha girin";
                      }
                    },
                    onSaved: (value) {
                      fiyat = int.parse(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    maxLines: 7,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Açıklama",
                      fillColor: Colors.grey,
                      filled: true,
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Lütfen aynı texti bir daha girin";
                      }
                    },
                    onSaved: (value) {
                      recipe = value;
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: createData,
                child: Text(
                  "Create",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
              )
            ],
          )
        ],
      ),
    );
  }
}
