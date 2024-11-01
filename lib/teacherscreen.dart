import 'package:flutter/material.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'teacher.dart';
import 'gatentryscreen.dart';
class teacherscr extends StatefulWidget {
  @override
  _teacherscrState createState() => _teacherscrState();
}

class _teacherscrState extends State<teacherscr> {
  var selectedCard = 'WEIGHT';
  String teacherEmail="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {},
                ),
                Container(
                    width: 125.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.logout),
                          color: Colors.white,
                          onPressed: () async {
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool("is_logged_in", false);
                            prefs.setBool("teacher_logged_in", false);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                        )
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: [
                Text('My',
                    style: GoogleFonts.sulphurPoint(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0)),
                SizedBox(width: 10.0),
                Text('Dashboard',
                    style: GoogleFonts.sulphurPoint(
                        color: Colors.white, fontSize: 30.0))
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 300.0,
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.symmetric(vertical:20,horizontal: 30),
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                teacherEmail = prefs.getString("teacher_email") ?? '';
                                print(teacherEmail);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeacherRequestsScreen(teacherEmail: teacherEmail,)),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.key,size:75,color: Colors.black),
                                  SizedBox(height: 10,),
                                  Text('GATE EXIT PASS',
                                    style: GoogleFonts.sulphurPoint(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            child: InkWell(
                              onTap:  ()async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                teacherEmail = prefs.getString("teacher_email") ?? "";
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => gatentryScreen(teacherEmail: teacherEmail,)),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.paste_sharp,size:75,color: Colors.black,),
                                  SizedBox(height: 10,),
                                  Text('GATE ENTRY PASS',
                                    style: GoogleFonts.sulphurPoint(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.wifi,size:75,color: Colors.black,),
                                  SizedBox(height: 10,),
                                  Text('WIFI REQUEST',
                                    style: GoogleFonts.sulphurPoint(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),
                          Material(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.medical_services_outlined,size:75,color: Colors.black,),
                                  SizedBox(height: 10,),
                                  Text('MEDICAL LEAVE',
                                    style: GoogleFonts.sulphurPoint(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),
                          Material(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.work_outline,size:75,color: Colors.black,),
                                  SizedBox(height: 10,),
                                  Text('DUTY LEAVE',
                                    style: GoogleFonts.sulphurPoint(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),
                          Material(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.more_outlined,size:75,color: Colors.black,),
                                  SizedBox(height: 10,),
                                  Text('OTHER',
                                    style: GoogleFonts.sulphurPoint(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),
                        ],
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
