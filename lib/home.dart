import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrem_pass/statuscrn.dart';
import 'gatepass.dart';
import 'homescreen.dart';
import 'qrcode.dart';
import 'status.dart';
import 'profile.dart';
import 'test.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items= const [
    Icon(Icons.home,size: 30),
    Icon(Icons.qr_code_2,size: 30 ),
    Icon(Icons.assignment,size: 30 ),
    Icon(Icons.person,size: 30),
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
        backgroundColor: Color(0XFFF5F5F5),

        animationDuration: const Duration(milliseconds: 300),
        // animationCurve: ,
      ),
      body: Container(
          color: Colors.teal,
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
        widget =LoginForm();
        break;
      case 1:
        widget =  GatePass();
        break;
      case 2 :
        widget = statuscrn();
        break;
      case 3:
        widget= ProfilePage();
            break;
      default:
        widget = ProfilePage();
        break;
    }
    return widget;
  }
}

