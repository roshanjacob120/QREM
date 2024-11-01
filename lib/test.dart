import 'package:flutter/material.dart';
import 'package:qrem_pass/Forms/form.dart';
import 'package:qrem_pass/Forms/lateentry.dart';
import 'package:qrem_pass/Forms/medical.dart';
import 'package:qrem_pass/Forms/other.dart';
import 'package:qrem_pass/Forms/wifi.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gatepass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Forms/duty.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var selectedCard = 'WEIGHT';

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
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool("is_logged_in", false);
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
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
                      child: ListView(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        children: [
                          SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RequestForm()),
                                );
                              },
                              child: Wrap(
                                children: [
                                  Icon(
                                    Icons.vpn_key,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    'Gate pass Request   +',
                                    style: GoogleFonts.sulphurPoint(
                                      fontSize: 23,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => lateRequestForm()),
                                );
                              },
                              child:Wrap(
                                children: [
                                  Icon(
                                    Icons.access_time_filled_sharp,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    'Late entry Request   +',
                                    style: GoogleFonts.sulphurPoint(
                                      fontSize: 23,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => wifiRequestForm()),
                                );
                              },
                              child:Wrap(
                                children: [
                                  Icon(
                                    Icons.wifi_sharp,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    'Wifi Request         +',
                                    style: GoogleFonts.sulphurPoint(
                                      fontSize: 23,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => medRequestForm()),
                                );
                              },
                              child:Wrap(
                                children: [
                                  Icon(
                                    Icons.medical_services,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    'Medical request     +',
                                    style: GoogleFonts.sulphurPoint(
                                      fontSize: 23,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => dutyRequestForm()),
                                );
                              },
                                child:Wrap(
                                  children: [
                                    Icon(
                                      Icons.work_history,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      'Duty leave request  +',
                                      style: GoogleFonts.sulphurPoint(
                                        fontSize: 23,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => othRequestForm()),
                                );
                              },
                              child:Wrap(
                                children: [
                                  Icon(
                                    Icons.cookie,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    'Other               +',
                                    style: GoogleFonts.sulphurPoint(
                                      fontSize: 23,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
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
