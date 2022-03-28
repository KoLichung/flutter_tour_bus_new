import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';

class CustomBigOutlinedButton extends StatelessWidget {

  final Function onPressed;
  final String title;


  const CustomBigOutlinedButton({Key? key, required this.onPressed,required this.title, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child:OutlinedButton(
              onPressed: () {onPressed();},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 1.0, color: AppColor.yellow),
              ),
              child: SizedBox(
                height: 46,
                child: Align(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16,color: AppColor.yellow),),
                  alignment: Alignment.center,
                ),
              )
          )
      );
  }

}