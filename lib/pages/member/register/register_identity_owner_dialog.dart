import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tour_bus_new/color.dart';



class RegisterIdentityOwnerDialog extends StatefulWidget {

  @override
  _RegisterIdentityOwnerDialogState createState() => new _RegisterIdentityOwnerDialogState();
}

class _RegisterIdentityOwnerDialogState extends State<RegisterIdentityOwnerDialog> {

  bool isOwnerAgreementChecked = false;
  bool isWarningVisible = false;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        color: AppColor.yellow,
        child: const Text(
          '業者規範',
          style: TextStyle(color: Colors.white),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(28,30,28,10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.yellow,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),),
              child: Column(
                children: const [
                  Text('業者規範', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Text('在此上架之遊覽車業者應符合國家遊覽車業者規定，且無不法情事，如有違反經查證屬實將強制下架該遊覽車業者。使用平台服務費為出車一天\$1000元。'),
                ],
            ),),
            Row(
              children: [
              Checkbox(
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                  ),
                  value: isOwnerAgreementChecked,
                  onChanged: (bool? value){
                    setState(() {
                      isOwnerAgreementChecked = value!;
                      isWarningVisible = false;
                    });
                  }),
              const Text('我同意此業者規範'),
            ],),
            Visibility(
              visible: isWarningVisible,
                child: const Text('您尚未同意業者規範!',style: TextStyle(color: Colors.red),))
        ],),
        ),
      // backgroundColor: AppColor.yellow,
      actions: <Widget>[
        OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColor.grey)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消', style: TextStyle(color: AppColor.grey))),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColor.grey)),
              onPressed: () {
                String text = 'confirmRegister';
                if(isOwnerAgreementChecked == false){
                  setState(() {
                    isWarningVisible = true;
                  });
                } else {
                  Navigator.pop(context,text);
                  print(text);
                }
              },
              child: const Text('確定註冊', style: TextStyle(color: AppColor.grey))),
        )
      ],
    );
  }
}


