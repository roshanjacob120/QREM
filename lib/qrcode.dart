import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GatePass extends StatefulWidget {
  @override
  _GatePassState createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> {
  String acceptedByhod = '';
  String acceptedbyadv='';
  String reason = '';
  String timeout = '';
  String date="";

  @override
  void initState() {
    super.initState();
    getGatePassData();
  }

  void getGatePassData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? '';

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Accepted Gate pass')
        .doc(email)
        .get();

    setState(() {
      acceptedByhod = snapshot['Accepted by HOD'];
      acceptedbyadv= snapshot['Accepted by Advisor'];
      reason = snapshot['Reason'];
      timeout = snapshot['Time out'];
      date=snapshot['Date'];
      print(reason);
      print(timeout);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImage(
              data: 'Accepted By HOD:$acceptedByhod\n Accepted by advisor:$acceptedbyadv\nReason:$reason\nTimeout:$timeout\nDate:$date',
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Accepted By HOD:$acceptedByhod\n Accepted by advisor:$acceptedbyadv\nReason:$reason\nTimeout:$timeout\nDate:$date',
              textAlign: TextAlign.center,
              style: GoogleFonts.sulphurPoint(
                  fontSize: 18.0, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
