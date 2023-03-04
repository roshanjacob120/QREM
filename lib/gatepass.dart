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

  String _goingOutTime = '';
  String _reason = '';
  String _name = "";
  String _department = "";
  String _year ="";
  String _ktuId = "";
  String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No user signed in';
  final fire_store=FirebaseFirestore.instance;


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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Going out time',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the going out time';
                  }
                  return null;
                },
                onSaved: (value) {
                  _goingOutTime = value!;
                },
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
                  getUserData(userEmail).then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
                    if (documentSnapshot.exists) {
                      _ktuId= documentSnapshot.get('ID');
                      _name = documentSnapshot.get('Name');
                      _year=documentSnapshot.get("Year");
                      _department=documentSnapshot.get("Dept");
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        fire_store.collection('Gate pass')
                            .doc('CSE')
                            .collection('Requests')
                            .doc('$userEmail')
                            .set({
                          'Dept': _department,
                          'ID':_ktuId,
                          'Name':_name,
                          "Year":_year,
                          "Reason":_reason,
                          "Time out":_goingOutTime,
                          "Status":"false"
                        });
                      }
                    } else {
                      print('No user data found for user with email user@gmail.com');
                    }
                  }).catchError((error) {
                    print('Error getting user data: $error');
                  });


                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
