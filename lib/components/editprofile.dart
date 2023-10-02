import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class editprofile extends StatefulWidget {
  const editprofile({super.key});

  @override
  State<editprofile> createState() => _editprofileState();
}

String? selectname;
Uint8List? addimg;

class _editprofileState extends State<editprofile> {
  Future selectphoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.media, allowMultiple: false, withData: true);
      setState(() {
        selectname = result!.files.first.name;
        addimg = result!.files.first.bytes;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Column(children: [
        Container(
          child: SizedBox(height: 20),
        ),
        if (addimg == null)
          Container(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 95,
                  backgroundImage: AssetImage('lib/assets/profile.jpg'),
                ),
                Positioned(
                    bottom: 20,
                    right: 15,
                    child: IconButton(
                      onPressed: () async {
                        selectphoto();
                      },
                      icon: Icon(Icons.edit),
                    ))
              ],
            ),
          ),
        if (addimg != null)
          Container(
            child: Stack(
              children: [
                CircleAvatar(
                    radius: 95,
                    backgroundImage: MemoryImage(
                      Uint8List.fromList(addimg!),
                    )),
                Positioned(
                    bottom: 20,
                    right: 15,
                    child: IconButton(
                      onPressed: () async {
                        selectphoto();
                      },
                      icon: Icon(Icons.edit),
                    ))
              ],
            ),
          ),
        Container(
          child: SizedBox(height: 25),
        ),
        Container(
          height: 40,
          width: 200,
          child: ElevatedButton(
            child: Text(
              'Save Changes',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () async {},
            style: ElevatedButton.styleFrom(primary: Colors.blue),
          ),
        ),
        Container(
          child: SizedBox(height: 7),
        ),
        Container(
          height: 40,
          width: 200,
          child: ElevatedButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(primary: Colors.red),
          ),
        )
      ]),
    );
  }
}
