import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class image extends StatefulWidget {
  const image({Key? key}) : super(key: key);

  @override
  State<image> createState() => _imageState();
}

class _imageState extends State<image> {
  String img = "";
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              img = image!.path;
                            });
                          },
                          child: Text("Gallery")),
                      ElevatedButton(
                          onPressed: () async {
                            final XFile? photo = await picker.pickImage(
                                source: ImageSource.camera);
                            setState(() {
                              img = photo!.path;
                            });
                          },
                          child: Text("camera")),
                    ],
                  );
                },
              );
            },
            child: Container(
              child: CircleAvatar(maxRadius: 60,backgroundImage: FileImage(File(img))),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                final storageRef = FirebaseStorage.instance.ref();
                String imagename = "ImageImage${Random().nextInt(1000)}.jpg";
                final spaceRef = storageRef.child("KRIns/$imagename");
                await spaceRef.putFile(File(img));
                spaceRef.getDownloadURL().then((value) {
                  print("====${value}");
                });
              },
              child: Text("Add Image To Firebase"))
        ],
      ),
    ));
  }
}
