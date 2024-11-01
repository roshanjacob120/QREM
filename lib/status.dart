import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GatePassRequestPage extends StatefulWidget {
  @override
  _GatePassRequestPageState createState() => _GatePassRequestPageState();
}

class _GatePassRequestPageState extends State<GatePassRequestPage> {
  int _currentStep = 0;
  bool _advisorApproved = false;
  bool _hodApproved = false;
  String userEmail =
      FirebaseAuth.instance.currentUser?.email ?? 'No user signed in';

  bool _showQRCode = false;

  @override
  void initState() {
    super.initState();
  }

  void _showQRCodePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Code'),
          content: Container(
            height: 200,
            width: 200,
            child: Center(
              child: QrImage(
                data: 'git ',
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gate Pass Request Status',
          style: GoogleFonts.sulphurPoint(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('gatepasstrack')
                  .doc(userEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data == null || !snapshot.data!.exists) {
                  return Center(
                    child: Text(
                      'No request found to track',
                      style: GoogleFonts.sulphurPoint(
                          fontSize: 18.0, fontWeight: FontWeight.w700),
                    ),
                  );
                }

                Map<String, dynamic>? data =
                snapshot.data?.data() as Map<String, dynamic>?;
                if (data != null) {
                  if (data['Advisor'] == 'true') {
                    _advisorApproved = true;
                    _currentStep = 1;
                  }
                  if (data['HOD'] == 'true') {
                    _hodApproved = true;
                    _currentStep = 3;
                  }
                }

                List<Step> _steps = [
                  Step(
                    title: Text(
                      'Request Sent',
                      style: GoogleFonts.sulphurPoint(
                          fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    content: Text(
                      'Your gate pass request has been sent.',
                      style: GoogleFonts.sulphurPoint(fontSize: 18),
                    ),
                    isActive: true,
                  ),
                  Step(
                    title: Text(
                      'Advisor Approval',
                      style: GoogleFonts.sulphurPoint(
                          fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    content: Text(
                      'Your advisor has approved your request.',
                      style: GoogleFonts.sulphurPoint(fontSize: 18),
                    ),
                    isActive: _advisorApproved,
                  ),
                  Step(
                    title: Text(
                      'HOD Approval',
                      style: GoogleFonts.sulphurPoint(
                          fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    content: Text(
                      'Your Head of Department has approved your request.',
                      style: GoogleFonts.sulphurPoint(fontSize: 18),
                    ),
                    isActive: _hodApproved,
                  ),
                  Step(
                    title: Text(
                      'QR Code Generated',
                      style: GoogleFonts.sulphurPoint(
                          fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    content: Text(
                      'Your gate pass has been approved and QR code has been generated.',
                      style: GoogleFonts.sulphurPoint(fontSize: 18),
                    ),
                    isActive: _currentStep == 3,
                  ),
                ];

                return Expanded(
                  child: Stepper(
                    currentStep: _currentStep,
                    steps: _steps,
                    controlsBuilder: (context, controller) {
                      return const SizedBox.shrink();
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36.5, horizontal: 50),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(_hodApproved==false)
                        {
                          _showQRCode=false;
                        }
                      else {
                        _showQRCode = true;
                      }
                    });
                    if (_showQRCode) {
                      _showQRCodePopup();
  }
},
                  child: Text('Show QR Code'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
