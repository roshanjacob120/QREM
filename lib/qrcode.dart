import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GatePass extends StatefulWidget {
  @override
  _GatePassState createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> {
  String acceptedBy = '';
  String reason = '';
  String timeout = '';

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
      acceptedBy = snapshot['Acceptedby'];
      reason = snapshot['Reason'];
      timeout = snapshot['Time out'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gate Pass'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImage(
              data: 'Accepted By:$acceptedBy\nReason:$reason\nTimeout:$timeout',
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Accepted By: $acceptedBy\nReason: $reason\nTime Out: $timeout',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
