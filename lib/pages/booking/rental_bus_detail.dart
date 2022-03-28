import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tour_bus_new/color.dart';
import 'package:flutter_tour_bus_new/pages/member/login_register.dart';
import 'search_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter_tour_bus_new/models/bus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tour_bus_new/notifier_model/user_model.dart';
import 'rental_agreement.dart';



class RentalBusDetail extends StatefulWidget {

  final Bus theBusDetail;
  const RentalBusDetail({Key? key, required this.theBusDetail}) : super(key: key);


  // const RentalBusDetail({Key? key}) : super(key: key);

  @override
  _RentalBusDetailState createState() => _RentalBusDetailState();
}

class _RentalBusDetailState extends State<RentalBusDetail> {

  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];


  // List<FakeTourBus> fakeResult = [
  //   FakeTourBus(title: '10人坐遊覽車', agentName: '長興旅行社',location: '台北',busYear: '2018',seat: '10'),
  //   FakeTourBus(title: '20人坐遊覽車', agentName: '長興旅行社',location: '台中',busYear: '2018',seat: '20'),
  //   FakeTourBus(title: '30人坐遊覽車', agentName: '長興旅行社',location: '台南',busYear: '2018',seat: '30'),
  // ];

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
                Container(
                  height: 214,
                  child: CarouselSlider(
                    items: imgList.map((item) => Stack(
                          children: <Widget>[
                            Image.network(item, fit: BoxFit.cover, width: width,),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
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
                      viewportFraction: 2,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        aspectRatio: 2,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
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
                  Text(widget.theBusDetail.title,style: Theme.of(context).textTheme.subtitle2,),
                  Text('旅遊公司名待改',style: const TextStyle(color: Colors.grey),),
                  Text('地址：'+ widget.theBusDetail.city),
                  Row(children: [
                    Text('年份：年份待改'),
                    const SizedBox(width: 20,),
                    Text('座位：${widget.theBusDetail.vehicleSeats} 人'),
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
                      TextSpan(text: '台北  ', style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(text: '  目的地：'),
                      TextSpan(text: '台中', style: Theme.of(context).textTheme.subtitle2),
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
                  Text('3月1日 週二',style: Theme.of(context).textTheme.subtitle2),
                  const SizedBox(height: 10,),
                  const Text('退租'),
                  Text('3月2日 週三',style: Theme.of(context).textTheme.subtitle2),
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
                  Text('\$15000',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,decoration: TextDecoration.lineThrough,color: Colors.red),),
                  const SizedBox(height: 10,),
                  Text('APP統一價'),
                  Text('\$11000',style: Theme.of(context).textTheme.subtitle2)],
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
                      MaterialPageRoute(builder: (context) => const RentalAgreement()));
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
}
