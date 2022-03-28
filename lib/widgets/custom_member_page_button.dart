import 'package:flutter/material.dart';

class CustomMemberPageButton extends StatelessWidget {
  final String title;
  final Function onPressed;


  CustomMemberPageButton({required this.title, required this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
          child: Row(
              children:[
                Expanded(flex:3,child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(title),
                )),
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 3),)
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                     onPressed();
                    },
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ),
                ),

              ]

          ),
        ),
        const Divider(
          thickness: 1,
          color: Color(0xffe5e5e5),
        ),
      ],
    );
  }
}
