import 'package:flutter/material.dart';

class GatePassRequestPage extends StatefulWidget {
  @override
  _GatePassRequestPageState createState() => _GatePassRequestPageState();
}

class _GatePassRequestPageState extends State<GatePassRequestPage> {
  int _currentStep = 0;

  List<Step> _steps = [
    Step(
      title: Text('Request Sent'),
      content: Text('Your gate pass request has been sent.'),
      isActive: true,
    ),
    Step(
      title: Text('Advisor Approval'),
      content: Text('Your advisor has approved your request.'),
      isActive: false,
    ),
    Step(
      title: Text('HOD Approval'),
      content: Text('Your Head of Department has approved your request.'),
      isActive: false,
    ),
    Step(
      title: Text('QR Code Generated'),
      content: Text('Your gate pass has been approved and QR code has been generated.'),
      isActive: false,
    ),
  ];

  void _goToNextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _goToPreviousStep() {
    setState(() {
      _currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gate Pass Request Status'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                steps: _steps,
                onStepContinue: _currentStep < _steps.length - 1 ? _goToNextStep : null,
                onStepCancel: _currentStep > 0 ? _goToPreviousStep : null,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
