import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _yearController = TextEditingController();
  final _passwordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _ktuIdController =
      TextEditingController(); // New controller for KTU ID field

  String _name = '';
  String _email = '';
  String _year = "1";
  List<String> _yearOptions = ['1', '2', '3', '4'];
  String _password = '';
  String _oldPassword = '';
  String _ktuId = ''; // New variable to store KTU ID

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('students')
        .doc('All')
        .collection('Data')
        .doc(user!.email)
        .get();
    setState(() {
      _name = userData['Name'];
      _email = user.email!;
      _year = userData['Year'];
      _ktuId = userData['ID']; // Retrieve KTU ID from Firebase
      _nameController.text = _name;
      _emailController.text = _email;
      _yearController.text = _year;
      _ktuIdController.text = _ktuId; // Set KTU ID to the controller
    });
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = {
      'Year': _year,
    };
    await FirebaseFirestore.instance
        .collection('students')
        .doc('All')
        .collection('Data')
        .doc(user!.email)
        .update(userData);
    if (_password.isNotEmpty) {
      await user.updatePassword(_password);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  enabled: false,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabled: false,
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField(
                  value: _year,
                  items: _yearOptions.map((year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Year',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your year of study.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _year = value as String;
                    });
                  },
                  onSaved: (value) {
                    _year = value as String;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _ktuIdController,
                  decoration: InputDecoration(
                    labelText: 'KTU ID',
                  ),
                  enabled:
                      false, // Set enabled to false to make it non-editable
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Old password',
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your old password.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _oldPassword = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New password',
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _validateAndUpdateProfile();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _validateAndUpdateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: _oldPassword,
    );
    try {
      await user.reauthenticateWithCredential(credential);
      _updateProfile();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid old password.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }
}
