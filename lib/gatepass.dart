import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class GatePassForm extends StatefulWidget {
  @override
  _GatePassFormState createState() => _GatePassFormState();
}

class _GatePassFormState extends State<GatePassForm> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? _goingOutTime;
  String _reason = '';
  String _name = "";
  String _department = "";
  String _year = "";
  String _ktuId = "";
  String userEmail =
      FirebaseAuth.instance.currentUser?.email ?? 'No user signed in';
  final fireStore = FirebaseFirestore.instance;

  void _showSuccessPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Request Sent"),
            content: Text("Your gate pass request has been sent."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gate Pass Request Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _goingOutTime = selectedTime;
                    });
                  }
                },
                child: Text(_goingOutTime == null
                    ? 'Select going out time'
                    : 'Going out time: ${_goingOutTime!.format(context)}'),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reason for going out';
                  }
                  return null;
                },
                onSaved: (value) {
                  _reason = value!;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  getUserData(userEmail).then(
                    (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
                      if (documentSnapshot.exists) {
                        _ktuId = documentSnapshot.get('ID');
                        _name = documentSnapshot.get('Name');
                        _year = documentSnapshot.get("Year");
                        _department = documentSnapshot.get("Dept");
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          fireStore
                              .collection('Gate pass')
                              .doc('CSE')
                              .collection('Requests')
                              .doc('$userEmail')
                              .set({
                            'Dept': _department,
                            'ID': _ktuId,
                            'Name': _name,
                            "Year": _year,
                            "Reason": _reason,
                            "Time out": _goingOutTime != null
                                ? _goingOutTime!.format(context)
                                : '',
                            "Status": "false"
                          }).then((value) {
                            _showSuccessPopup();
                          });
                        }
                      } else {
                        print(
                            'No user data found for user with email user@gmail.com');
                      }
                    },
                    onError: (error) {
                      print(error);
                    },
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
