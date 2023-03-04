import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'gatepass.dart';
import 'homescreen.dart';
import 'qrcode.dart';
import 'status.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items= const [
    Icon(Icons.home,size: 30,),
    Icon(Icons.qr_code_2,size: 30,),
    Icon(Icons.assignment,size: 30,),
    Icon(Icons.person,size: 30,),
  ];
  int index=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        onTap: (selectedIndex){
          setState(() {
            index = selectedIndex;
          });
        },
        height: 70,
        backgroundColor: Colors.grey,
        animationDuration: const Duration(milliseconds: 300),
        // animationCurve: ,
      ),
      body: Container(
          color: Colors.blue,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: getSelectedWidget(index: index)
      ),
    );
  }

  Widget getSelectedWidget({required int index}){
    Widget widget;
    switch(index){
      case 0:
        widget =homescreen();
        break;
      case 1:
        widget =  GatePass();
        break;
      case 2 :
        widget = RequestStatusPage(requestStatus: 1);
        break;
      default:
        widget = homescreen();
        break;
    }
    return widget;
  }
}

