import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/models/bus_rent_day.dart';
import 'package:flutter_tour_bus_new/pages/member/login_register.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/tour_bus_image.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/models/bus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'rental_agreement.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_tour_bus_new/constant.dart';
import 'package:intl/intl.dart';

class RentalBusDetail extends StatefulWidget {

  final Bus theBus;
  final String fromCity;
  final String toCity;
  final DateTime startDate;
  final DateTime endDate;

  const RentalBusDetail({Key? key, required this.theBus, required this.fromCity, required this.toCity, required this.startDate, required this.endDate}) : super(key: key);

  @override
  _RentalBusDetailState createState() => _RentalBusDetailState();
}

class _RentalBusDetailState extends State<RentalBusDetail> {

  int _current = 0;
  final CarouselController _controller = CarouselController();

  List<TourBusImage> imgList = [];

  @override
  void initState() {
    super.initState();
    _fetchBusImages(widget.theBus.id!);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('包遊覽車'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider(
                  items: imgList.map((item) => Stack(
                        children: <Widget>[
                          Image.network(item.image!, fit: BoxFit.cover, width: width),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],)).toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                      viewportFraction: 1,
                      autoPlay: true,
                      enlargeCenterPage: false,
                      aspectRatio: 1.5,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4)
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
              child: Column(/**/
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.theBus.title!,style: Theme.of(context).textTheme.subtitle2,),
                  // Text('旅遊公司名待改',style: const TextStyle(color: Colors.grey),),
                  Text('地址：'+ widget.theBus.city!),
                  Row(children: [
                    Text('年份：${widget.theBus.vehicalYearOfManufacture!}'),
                    const SizedBox(width: 20,),
                    Text('車上座位：${widget.theBus.vehicalSeats} 人'),
                  ],),
                ],
              ),
            ),
            const Divider(
              color: AppColor.superLightGrey,
              thickness: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: '出發地：',
                    style: Theme.of(context).textTheme.bodyText2,
                    children: <TextSpan>[
                      TextSpan(text: '${widget.fromCity}  ', style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(text: '  目的地：'),
                      TextSpan(text: '${widget.toCity}', style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              color: AppColor.superLightGrey,
              thickness: 8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(alignment: Alignment.centerLeft,child: Text('起租')),
                  Text(DateFormat('MM / dd EEE').format(widget.startDate),style: Theme.of(context).textTheme.subtitle2),
                  const SizedBox(height: 10,),
                  const Text('退租'),
                  Text(DateFormat('MM / dd EEE').format(widget.endDate),style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ),
            const Divider(
              color: AppColor.superLightGrey,
              thickness: 8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(alignment: Alignment.centerLeft,child: Text('原價')),
                  Text('\$${_getDaysInterval()*15000}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,decoration: TextDecoration.lineThrough,color: Colors.red),),
                  const SizedBox(height: 10),
                  Text('APP統一價'),
                  Text('\$${_getDaysInterval()*11000}',style: Theme.of(context).textTheme.subtitle2),
                  const SizedBox(height: 10),
                  Text('訂金'),
                  Text('\$${_getDaysInterval()*2500}',style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ),
            CustomElevatedButton(
              color: AppColor.yellow,
              title: '立即租車',
              onPressed: (){
                var userModel = context.read<UserModel>();
                if(userModel.isLogin()){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RentalAgreement(
                        theBus: widget.theBus,
                        fromCity: widget.fromCity,
                        toCity: widget.toCity,
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                      )));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginRegister(),
                      ));
                }

              },),
            const SizedBox(height: 20,)
          ],
        ),
      )
    );
  }

  int _getDaysInterval(){
    return -widget.startDate.difference(widget.endDate).inDays;
  }

  Future _fetchBusImages(int busId) async {

    String path = Service.TOUR_BUS_IMAGES;
    try {

      final queryParameters = {
        // "bus_id" : busId.toString(),
        "bus_id" : "15",
      };

      final response = await http.get(Service.standard(path: path, queryParameters: queryParameters));

      if (response.statusCode == 200) {
        // print(response.body);
        List body = json.decode(utf8.decode(response.body.runes.toList()));
        imgList = body.map((value) => TourBusImage.fromJson(value)).toList();

        setState(() {});

      }
    } catch (e) {
      print(e);
    }
  }


}
