import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';

class ImageUploadButton extends StatelessWidget {
  final Function onPressed;
  final String title;

  const ImageUploadButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30,8,10,8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment:Alignment.centerLeft
              ,child: Text(title)),
          const SizedBox(height: 6,),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              child: const Icon(Icons.photo_camera_outlined,color: AppColor.grey,),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
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
          ),
        ],
      ),
    );
  }
}

