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
  final fire_store = FirebaseFirestore.instance;
  String _name = "";
  String _email = "";
  String _department = "CSE";
  int _year = 1;
  String _ktuId = "";
  String _password = "";
  String _confirmPassword = "";
  final auth = FirebaseAuth.instance;
  String userEmail =
      FirebaseAuth.instance.currentUser?.email ?? 'No user signed in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
            Flexible(
            child: TextFormField(
              decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your name';
              }
              return null;
            },
            onChanged: (value) => _name = value ?? '',
          ),
        ),
        SizedBox(height: 20.0),
        Flexible(
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your email';
              } else if (value != null && !value.endsWith('@mbcet.ac.in')) {
                return 'Please enter a valid mbcet email';
              }
              return null;
            },
            onChanged: (value) => _email = value ?? '',
          ),
        ),
        SizedBox(height: 20.0),
        Flexible(
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a password';
              }
              return null;
            },
            onChanged: (value) => _password = value ?? '',
          ),
        ),
        SizedBox(height: 20.0),
        Flexible(
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please confirm your password';
              } else if (value != _password) {
                return 'Passwords do not match';
              } else {
                return null;
              }
            },
            onChanged: (value) => _confirmPassword = value ?? '',
          ),
        ),
        SizedBox(height: 20.0),
        Flexible(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Department',
              labelStyle: TextStyle(color: Colors.blueGrey[800]),
              border: OutlineInputBorder(),
            ),
            value: _department,
            onChanged: (value) {
                  setState(() {
                    _department = value ?? '';
                  });
                },
                items:
                    <String>['CSE', 'ECE', 'EEE', 'ME', 'CE'].map((department) {
                  return DropdownMenuItem(
                    value: department,
                    child: Text(
                      department,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  );
                }).toList(),
              ),
    ),
              SizedBox(height: 8.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Year',
                  labelStyle: TextStyle(color: Colors.blueGrey[800]),
                  border: OutlineInputBorder(),
                ),
                value: _year,
                onChanged: (value) => _year = value ?? 1,
                items:
                    <int>[1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'KTU ID',
                  labelStyle: TextStyle(color: Colors.blueGrey[800]),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your KTU ID';
                  }
                  return null;
                },
                onChanged: (value) => _ktuId = value ?? '',
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                child: Text('Register', style: TextStyle(fontSize: 16.0)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blueGrey[800]),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true) {
                    _formKey.currentState?.save();
                    try {
                      final newuser = auth.createUserWithEmailAndPassword(
                          email: _email, password: _password);
                      if (newuser != null) {
                        print(_email);
                        print(_department);
                        print(_ktuId);
                        print(_name);
                        print(_year);
                        await fire_store
                            .collection('students')
                            .doc('All')
                            .collection('Data')
                            .doc(_email)
                            .set({
                          'Dept': _department,
                          'ID': _ktuId,
                          'Name': _name,
                          "Year": _year.toString()
                        });
                      }
                    } catch (e) {
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
    ),);
  }
}
