import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class gatentryScreen extends StatefulWidget {
  final String teacherEmail;

  const gatentryScreen({required this.teacherEmail});
  @override
  _gatentryScreenState createState() => _gatentryScreenState();
}

class _gatentryScreenState extends State<gatentryScreen> {
  String teacherDept = "";
  String teacherRole = "";
  String hod = "";
  String tname="";


  @override
  void initState() {
    super.initState();
    getTeacherDetails();
  }

  Future<void> getTeacherDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference staffCollection =
    FirebaseFirestore.instance.collection('Staff');
    DocumentSnapshot staffDoc =
    await staffCollection.doc(widget.teacherEmail).get();
    if (staffDoc.exists) {
      print(widget.teacherEmail);
      Map<String, dynamic> data = staffDoc.data() as Map<String, dynamic>;
      String dept = data['Dept'];
      String role = data['Role'];
      String name=data['Name'];
      print(role);
      setState(() {
        teacherDept = dept;
        teacherRole = role;
        tname=name;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
              await SharedPreferences.getInstance();
              prefs.setBool("is_logged_in", false);
              prefs.setBool("teacher_logged_in", false);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Staff')
            .doc(widget.teacherEmail)
            .collection('lateentry')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> requestDocs = snapshot.data?.docs ?? [];

          if (requestDocs.isEmpty) {
            return Center(
              child: Text('No requests found.'),
            );
          }
          return ListView.builder(
            itemCount: requestDocs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> requestData =
              Map<String, dynamic>.from(requestDocs[index].data() as Map);
              String name = requestData['Name'];
              String reason = requestData['Reason'];
              String timeIn = requestData['Time in'];
              String date=requestData['Date'];
              String dept = requestData['Dept'];
              String year = requestData['Year'];
              String id = requestDocs[index].id;
              String status = requestData['Status'];
              String? advisor = requestData["Accepted by"]?.toString();
              print(advisor);
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.sulphurPoint(
                            fontSize: 20.0, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reason: $reason',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Time In: $timeIn',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dept: $dept',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Year of Study: $year',
                            style: GoogleFonts.sulphurPoint(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check),
                            color: status == 'Approved'
                                ? Colors.green
                                : Colors.grey,
                            onPressed: status != 'Approved'
                                ? () async {
                              print(teacherRole);
                              print(teacherDept);
                              print(reason);
                              print(timeIn);
                              print(id);
                              if (teacherRole == 'advisor') {
                                hod = await FirebaseFirestore.instance
                                    .collection('HOD')
                                    .doc('MBCET')
                                    .get()
                                    .then((doc) => doc.get(teacherDept));
                                await FirebaseFirestore.instance
                                    .collection('Staff')
                                    .doc(hod)
                                    .collection('lateentry')
                                    .doc(id)
                                    .set({
                                  'Dept': dept,
                                  'ID': id,
                                  'Name': name,
                                  "Year": year,
                                  "Reason": reason,
                                  "Time in": timeIn,
                                  "Date":date,
                                  "Status": "false",
                                  "Accepted by": tname
                                });
                                await FirebaseFirestore.instance
                                    .collection('Staff')
                                    .doc(widget.teacherEmail)
                                    .collection('history')
                                    .doc(id)
                                    .set({
                                  'Dept': dept,
                                  'ID': id,
                                  'Name': name,
                                  "Year": year,
                                  "Reason": reason,
                                  "Time": timeIn,
                                  "Date":date,
                                  "Status": "Accepted",
                                  "Category":"Late Entry"
                                });
                                await FirebaseFirestore.instance
                                    .collection('lateentrytrack')
                                    .doc(id)
                                    .set({
                                  "Advisor": "true",
                                  "HOD": "false"
                                });
                                await FirebaseFirestore.instance
                                    .collection('Staff')
                                    .doc(widget.teacherEmail)
                                    .collection('lateentry')
                                    .doc(id)
                                    .delete();
                              } else if (teacherRole == "HOD") {
                                await FirebaseFirestore.instance
                                    .collection('Accepted Gate entry')
                                    .doc(id)
                                    .set({
                                  'Dept': dept,
                                  'ID': id,
                                  'Name': name,
                                  "Year": year,
                                  "Reason": reason,
                                  "Time in": timeIn,
                                  "Date":date,
                                  "Status": "false",
                                  "Accepted by Advisor": advisor,
                                  "Accepted by HOD": tname
                                });
                                await FirebaseFirestore.instance
                                    .collection('lateentrytrack')
                                    .doc(id)
                                    .set({
                                  "Advisor": "true",
                                  "HOD": "true"
                                });
                                await FirebaseFirestore.instance
                                    .collection('Staff')
                                    .doc(widget.teacherEmail)
                                    .collection('lateentry')
                                    .doc(id)
                                    .delete();
                              }
                            }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            color:
                            status == 'Rejected' ? Colors.red : Colors.grey,
                            onPressed:
                            status != 'Rejected' ? () async {
                              await FirebaseFirestore.instance
                                  .collection('Staff')
                                  .doc(widget.teacherEmail)
                                  .collection('history')
                                  .doc(id)
                                  .set({
                                'Dept': dept,
                                'ID': id,
                                'Name': name,
                                "Year": year,
                                "Reason": reason,
                                "Time": timeIn,
                                "Date":date,
                                "Status": "Rejected",
                                "Category":"Late Entry"
                              });
                            } : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.rate_review),
                            color: status == 'Reviewed'
                                ? Colors.blue
                                : Colors.grey,
                            onPressed:
                            status != 'Reviewed' ? () async {
                              await FirebaseFirestore.instance
                                  .collection('Staff')
                                  .doc(widget.teacherEmail)
                                  .collection('history')
                                  .doc(id)
                                  .set({
                                'Dept': dept,
                                'ID': id,
                                'Name': name,
                                "Year": year,
                                "Reason": reason,
                                "Time in": timeIn,
                                "Date":date,
                                "Status": "Reviewed",
                                "Category":"Late Entry"
                              });
                            } : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
