import 'package:flutter/material.dart';


class CustomElevatedButton extends StatelessWidget {

  final Function onPressed;
  final String title;
  final Color color;

  const CustomElevatedButton({Key? key, required this.onPressed,required this.title, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child:ElevatedButton(
          onPressed: () {
            onPressed();
            },
            style: ElevatedButton.styleFrom(
                primary: color,
                elevation: 0
              ),
          child: SizedBox(
            height: 46,
            child: Align(
              child: Text(title,),
              alignment: Alignment.center,
                ),
              )
          )
      );
  }

}