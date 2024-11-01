import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrem_pass/status.dart';
import 'latentrystatus.dart';
class statuscrn extends StatefulWidget {
  @override
  _statuscrnState createState() => _statuscrnState();
}

class _statuscrnState extends State<statuscrn> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Status',
            style: GoogleFonts.sulphurPoint(fontWeight: FontWeight.bold),),
          elevation: 0,
          backgroundColor: Colors.teal,
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
          primary: false,
          padding: EdgeInsets.only(left: 25.0, right: 20.0),
          children: [
            Padding(
                padding: EdgeInsets.only(top: 45.0),
                child: Container(
                  height: MediaQuery.of(context).size.height - 300.0,
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      ClipOval(
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GatePassRequestPage()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.key,
                                  size: 50,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'GATE EXIT PASS',
                                  style: GoogleFonts.sulphurPoint(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => latentrystatusPage()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.paste_sharp,
                                  size: 50,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'GATE ENTRY PASS',
                                  style: GoogleFonts.sulphurPoint(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wifi,
                                  size: 50,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'WIFI REQUEST',
                                  style: GoogleFonts.sulphurPoint(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.medical_services_outlined,
                                  size: 50,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'MEDICAL LEAVE',
                                  style: GoogleFonts.sulphurPoint(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.work_outline,
                                  size: 50,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'DUTY LEAVE',
                                  style: GoogleFonts.sulphurPoint(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.more_outlined,
                                  size: 50,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'OTHER',
                                  style: GoogleFonts.sulphurPoint(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        )
    );
  }
}