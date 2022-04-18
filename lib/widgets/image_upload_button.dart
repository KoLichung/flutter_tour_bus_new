import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';

class ImageUploadButton extends StatelessWidget {
  final Function onPressed;

  const ImageUploadButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.fromLTRB(30,6,10,6),
      child: OutlinedButton(
        child: const Icon(Icons.photo_camera_outlined,color: AppColor.grey,),
        style: OutlinedButton.styleFrom(
          // padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          side: const BorderSide(
            color: AppColor.grey,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        onPressed: () async{
          onPressed();
          // final picker = ImagePicker();
          // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
          // if(pickedFile == null) return;
        },
      ),
    );
  }
}

