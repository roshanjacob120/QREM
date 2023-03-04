import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final fire_store=FirebaseFirestore.instance;
  String _name = "";
  String _email = "";
  String _department = "CSE";
  int _year = 1;
  String _ktuId = "";
  String _password = "";
  String _confirmPassword = "";
  final auth=FirebaseAuth.instance;
  String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No user signed in';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) => _name = value ?? '',
              ),
              SizedBox(height: 8.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  } else if (value != null && !value.endsWith('@mbcet.ac.in')) {
                    return 'Please enter a valid mbcet email';
                  }
                  return null;
                },
                onChanged: (value) => _email = value ?? '',
              ),  TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onChanged: (value) => _password = value ?? '',
              ),
              SizedBox(height: 8.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please confirm your password';
                  } else if (value != _password) {

                    return 'Passwords do not match';
                  }
                  else {
                    return null;
                  }
                },
                onChanged: (value) => _confirmPassword = value ?? '',
              ),
              SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Department'),
                value: _department,
                items: <String>['CSE', 'ME', 'CE', 'EEE', 'ECE']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _department = value;
                    });
                  }
                },
              ),
              SizedBox(height: 8.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Year'),
                value: _year,
                items: List.generate(4, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  );
                }),
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      _year = value;
                    });
                  }
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'KTU ID'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your KTU ID';
                  }
                  return null;
                },
                onChanged: (value) => _ktuId = value ?? '',
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () async{
                  if (_formKey.currentState?.validate() == true) {
                    _formKey.currentState?.save();
                    try{
                      final newuser=auth.createUserWithEmailAndPassword(email: _email, password: _password);
                      if(newuser!=null)
                      {
                       print(_email);
                       print(_department);
                       print(_ktuId);
                       print(_name);
                       print(_year);
                        await fire_store.collection('students')
                            .doc('All')
                            .collection('Data')
                            .doc(_email)
                            .set({
                          'Dept': _department,
                          'ID':_ktuId,
                          'Name':_name,
                          "Year":_year.toString()
                        });
                        if(_department=='CSE') {
                          fire_store.collection('students')
                              .doc('CSE')
                              .collection('Data')
                              .doc('$_email')
                              .set({
                            'Dept': _department,
                            'ID':_ktuId,
                            'Name':_name,
                            "Year":_year
                          });
                        }
                        else if(_department=='ME') {
                          fire_store.collection('students')
                              .doc('ME')
                              .collection('Data')
                              .doc('$_email')
                              .set({
                            'Dept': _department,
                            'ID':_ktuId,
                            'Name':_name,
                            "Year":_year
                          });
                        }
                        else if(_department=='CE') {
                          fire_store.collection('students')
                              .doc('CE')
                              .collection('Data')
                              .doc('$_email')
                              .set({
                            'Dept': _department,
                            'ID':_ktuId,
                            'Name':_name,
                            "Year":_year
                          });
                        }
                        else if(_department=='ECE') {
                          fire_store.collection('students')
                              .doc('ECE')
                              .collection('Data')
                              .doc('$_email')
                              .set({
                            'Dept': _department,
                            'ID':_ktuId,
                            'Name':_name,
                            "Year":_year
                          });
                        }
                        else if(_department=='EEE') {
                          fire_store.collection('students')
                              .doc('EEE')
                              .collection('Data')
                              .doc('$_email')
                              .set({
                            'Dept': _department,
                            'ID':_ktuId,
                            'Name':_name,
                            "Year":_year
                          });
                        }

                      }
                    }
                    catch(e){
                      print(e);
                    }
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

