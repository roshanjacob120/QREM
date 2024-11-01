import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
class register extends StatefulWidget {
  final String email;

  const register({Key? key, required this.email}) : super(key: key);
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
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
  void initState() {
    super.initState();
    _email = widget.email; // set the initial value of the email controller
  }


  // Department dropdown value and options
  String? _selectedDepartment;
  final List<String> _departmentOptions = ['CSE','CE','ECE','ME','EEE'];
  String? _selectedYear;
  final List<String> _yearOptions = ['1st','2nd','3rd','4th'];
  String? _selectedbatch;
  final List<String> _batchOptions = ['2023','2024','2025','2026','2027'];

  // Whether to obscure the password fields or not
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',
          style: GoogleFonts.sulphurPoint(),),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
            children:[ Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name text field
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    }

                ),
                SizedBox(height: 16.0),

                // Email text field
                DropdownButtonFormField<String>(
                  value: _selectedYear,
                  items: _yearOptions.map((year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Year',
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedbatch,
                  items: _batchOptions.map((batch) {
                    return DropdownMenuItem(
                      value: batch,
                      child: Text(batch),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedbatch = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Batch',
                  ),
                ),
                SizedBox(height: 16.0),

                // Password text field with obscure toggle
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Confirm password text field with obscure toggle
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Department dropdown
                DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  items: _departmentOptions.map((department) {
                    return DropdownMenuItem(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartment = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Department',
                  ),
                ),
                SizedBox(height: 16.0),

                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'KTU ID',
                  ),onChanged: (value) {
                  setState(() {
                    _ktuId = value;
                  });
                }
                ),
                SizedBox(height: 16.0),
                // Create account button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
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
                            "Year": _year.toString(),
                            "Batch":_selectedbatch
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Text('Create Account',

                        style: GoogleFonts.sulphurPoint(
                            fontSize: 20.0
                        )),
                  ),
                ),
              ],

            ),
            ]
        ),
      ),
    );
  }
}