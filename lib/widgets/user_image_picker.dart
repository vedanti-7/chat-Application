import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget{
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage; 

  @override
  State<StatefulWidget> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker>{
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage=await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if(pickedImage==null){
      return;
    }

    setState(() {
      _pickedImageFile=File(pickedImage.path);  //if image is picked the ui will change means the image will be uploaded in the circle avaatar so we used setState()
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color.fromARGB(255, 150, 186, 180),
          foregroundImage: _pickedImageFile!=null ?  FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(           //when this button pressed imagepicker method will ask user's camera to add an image 
          onPressed: _pickImage, 
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: const Color.fromARGB(255, 111, 186, 181)
            ),
          ),
        ),
      ],
    );
  }
}