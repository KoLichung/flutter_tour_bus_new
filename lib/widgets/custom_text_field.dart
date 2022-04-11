import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';

class CustomTextField extends StatelessWidget {

  IconData icon;
  String hintText;
  TextEditingController controller;
  bool isObscureText;
  bool isNumblerOnly;

  CustomTextField({required this.icon, required this.hintText,required this.controller,this.isObscureText = false, this.isNumblerOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: ListTile(
          leading: Icon(
            icon,
            size: 26.0,
            color: AppColor.grey,
          ),
          title:
          (isNumblerOnly)?
          TextField(
            controller: controller,
            obscureText: isObscureText,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hintText,
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey,)
              ),
            ),
          )
              :
          TextField(
            controller: controller,
            obscureText: isObscureText,
            decoration: InputDecoration(
              hintText: hintText,
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey,)
              ),
            ),
          )
      ),
    );

  }

}

