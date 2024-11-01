import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'qrcode.dart';
import 'history.dart';
import 'teacherscreen.dart';
class teacherHome extends StatefulWidget {
  const teacherHome({Key? key}) : super(key: key);

  @override
  _teacherHomeState createState() => _teacherHomeState();
}

class _teacherHomeState extends State<teacherHome> {
  final items= const [
    Icon(Icons.home,size: 30),
    Icon(Icons.history,size: 30 ),

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
        widget =teacherscr();
        break;
      case 1:
        widget =  history(teacherEmail: 'asha.s@mbcet.ac.in');
        break;
      default:
        widget = teacherscr();
        break;
    }
    return widget;
  }
}

