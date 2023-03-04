import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrem_pass/qrcode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'gatepass.dart';
class homescreen extends StatelessWidget {
  const homescreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("is_logged_in", false);
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GatePassForm()),
              );
            },
            child: Text('Gate Pass Request'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement late entry request functionality
            },
            child: Text('Late Entry Request'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement wifi request functionality
            },
            child: Text('Wifi Request'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement medical leave request functionality
            },
            child: Text('Medical Leave Request'),
          ),
          SizedBox(height: 16),

        ],
      ),
    ),

    );
  }
}
