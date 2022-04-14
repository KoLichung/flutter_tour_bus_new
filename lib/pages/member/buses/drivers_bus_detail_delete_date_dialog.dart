import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'drivers_bus_detail.dart';



class DriversBusDetailDeleteDateDialog extends StatefulWidget {

  final AvailableDate availableDate;
  const DriversBusDetailDeleteDateDialog({Key? key, required this.availableDate});

  @override
  _DriversBusDetailDeleteDateDialogState createState() => new _DriversBusDetailDeleteDateDialogState();
}

class _DriversBusDetailDeleteDateDialogState extends State<DriversBusDetailDeleteDateDialog> {

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
          '確定要刪除嗎？',
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
          children: [
            const Text('您要刪除的日期為：'),
            const SizedBox(height: 10,),
            Text('${widget.availableDate.startDate} ~ ${widget.availableDate.endDate}'),
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


