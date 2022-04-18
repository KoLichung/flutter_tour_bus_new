import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';


class AddNewBusDeletePhotoDialog extends StatefulWidget {

  @override
  _AddNewBusDeletePhotoDialogState createState() => new _AddNewBusDeletePhotoDialogState();
}

class _AddNewBusDeletePhotoDialogState extends State<AddNewBusDeletePhotoDialog> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        color: AppColor.yellow,
        child: const Text(
          '刪除',
          style: TextStyle(color: Colors.white),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('確定要刪除這張照片嗎？'),
            SizedBox(height: 10,),
          ],
        ),
      ),
      backgroundColor: AppColor.yellow,
      actions: <Widget>[
        OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
            onPressed: () {
              String text = 'confirmDelete';
              Navigator.pop(context,text);
            },
            child:const  Text('刪除', style: TextStyle(color: Colors.white),
            )),
        OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            child: const Text('取消', style: TextStyle(color: Colors.white)))
      ],
    );
  }
}


