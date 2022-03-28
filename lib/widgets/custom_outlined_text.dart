import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';

class CustomOutlinedText extends StatelessWidget {

  final String title;
  final Color color;

  const CustomOutlinedText({Key? key, required this.title, required this.color }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: Text(title,style: TextStyle(color: color),),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: color,
          width: 1,),
      ),
    );
  }

}