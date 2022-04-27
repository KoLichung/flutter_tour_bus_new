


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../color.dart';
import '../../models/order.dart';

class AtmInfoDialog extends StatefulWidget {

  final Order theOrder;
  const AtmInfoDialog({Key? key, required this.theOrder});

  @override
  _AtmInfoDialogState createState() => _AtmInfoDialogState();
}

class _AtmInfoDialogState extends State<AtmInfoDialog> {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        color: AppColor.yellow,
        child: const Text(
          'ATM 繳款訊息',
          style: TextStyle(color: Colors.white),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('您的 ATM 繳款訊息如下：'),
            const SizedBox(height: 10,),
            Text('繳款銀行代碼:\n${widget.theOrder.aTMInfoBankCode!}'),
            Text('繳款帳號:\n${widget.theOrder.aTMInfovAccount!}'),
            Text('截止日期:\n${widget.theOrder.aTMInfoExpireDate!.substring(0, 19)}\n'),
            const Text('p.s 繳款後請耐心等待狀態改變'),
          ],
        ),
      ),
      backgroundColor: AppColor.yellow,
      actions: <Widget>[
        OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            child: const Text('確認', style: TextStyle(color: Colors.white)))
      ],
    );
  }
}