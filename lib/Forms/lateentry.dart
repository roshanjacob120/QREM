import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database.dart';
class lateRequestForm extends StatefulWidget {
  @override
  _lateRequestFormState createState() => _lateRequestFormState();
}

class _lateRequestFormState extends State<lateRequestForm> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _otherController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No user signed in';
  final fireStore = FirebaseFirestore.instance;
  String? _selectedadvisors;
  List<String> _advisorOptions = [];
  Map<String, String> advisorEmails = {};
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _reason = "";
  String _name = "";
  String _department = "";
  String _year = "";
  String _ktuId = "";
  Future<void> fetchUserData(String userEmail) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await getUserData(userEmail);

      if (documentSnapshot.exists) {
        _ktuId = documentSnapshot.get('ID');
        _name = documentSnapshot.get('Name');
        _year = documentSnapshot.get('Year');
        _department = documentSnapshot.get('Dept');
        print(_department);
      } else {
        print('No user data found for user with email $userEmail');
      }
    } catch (error) {
      print(error);
    }
  }
  void _showSuccessPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Request Sent"),
            content: Text("Your Late entry request has been sent."),
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
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.teal, // Change this to your desired color
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dateController.text =
        "${_selectedDate.toLocal()}".split(' ')[0];
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.teal, // Change this to your desired color
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
  }

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    await fetchUserData(userEmail);
    _fetchAdvisorOptions();
    print(userEmail);
  }

  Future<void> _fetchAdvisorOptions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Semwiseteachers')
        .doc('$_department')
        .collection("$_year")
        .get();
    final advisors = snapshot.docs.map((doc) => doc.id).toList();
    final emails = Map<String, String>.fromIterable(
        snapshot.docs,
        key: (doc) => doc.id,
        value: (doc) => doc.data()['Email']
    );
    setState(() {
      _advisorOptions = advisors;
      advisorEmails = emails;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Request Form",
          style: GoogleFonts.sulphurPoint(
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _descriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Enter description",
                  labelText: "Reason",
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  border: OutlineInputBorder(),

                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _otherController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Enter names",
                  labelText: "Other people,if any",
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: "Select Date",
                        labelText: "Date",
                        suffixIcon
                            : GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: null,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 15.0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        hintText: "Select Time",
                        labelText: "Time",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: IconButton(
                            icon: Icon(Icons.access_time),
                            onPressed: null,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 15.0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedadvisors,
                items: _advisorOptions.map((department) {
                  return DropdownMenuItem(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedadvisors = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Advisor',
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {

                    fireStore
                        .collection('Staff')
                        .doc('${advisorEmails[_selectedadvisors]}')
                        .collection('lateentry')
                        .doc('$userEmail')
                        .set({
                      'Dept': _department,
                      'ID': _ktuId,
                      'Name': _name,
                      "Year": _year,
                      "Reason": _descriptionController.text +"\nAttached People:"+ _otherController.text,
                      "Time in":  _selectedTime!.format(context),
                      "Date": _selectedDate.toString(),
                      "Status": "false"
                    }).then((value) {
                      _showSuccessPopup();
                    });
                    fireStore.collection("lateentrytrack").doc("$userEmail").set({
                      "Advisor":"False",
                      "HOD":"False"
                    });

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Text('Send',
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