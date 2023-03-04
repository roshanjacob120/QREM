import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherRequestsScreen extends StatefulWidget {
  @override
  _TeacherRequestsScreenState createState() => _TeacherRequestsScreenState();
}

class _TeacherRequestsScreenState extends State<TeacherRequestsScreen> {
  String teacherEmail = '';

  @override
  void initState() {
    super.initState();
    getTeacherEmail();
  }

  Future<void> getTeacherEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      teacherEmail = prefs.getString("teacher_email") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Gate pass')
            .doc('CSE')
            .collection('Requests')
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
              String timeOut = requestData['Time out'];
              String dept = requestData['Dept'];
              String year = requestData['Year'];
              String id = requestDocs[index].id;
              String status = requestData['Status'];



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
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reason: $reason',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Time Out: $timeOut',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dept: $dept',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Year of Study: $year',
                            style: TextStyle(fontSize: 16.0),
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
                                    print(teacherEmail);
                                    print(reason);
                                    print(timeOut);
                                    print(id);
                                    await FirebaseFirestore.instance
                                        .collection('Accepted Gate pass')
                                        .doc(id)
                                        .set({
                                      "Acceptedby": teacherEmail,
                                      "Reason": reason,
                                      "Time out": timeOut
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('Gate pass')
                                        .doc('CSE')
                                        .collection('Requests')
                                        .doc(id)
                                        .update({
                                      'Status': 'Approved',
                                    });
                                  }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            color:
                                status == 'Rejected' ? Colors.red : Colors.grey,
                            onPressed: status != 'Rejected'
                                ? () {
                                    FirebaseFirestore.instance
                                        .collection('Gate pass')
                                        .doc('CSE')
                                        .collection('Requests')
                                        .doc(id)
                                        .update({
                                      'Status': 'Rejected',
                                    });
                                  }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.rate_review),
                            color: status == 'Reviewed'
                                ? Colors.blue
                                : Colors.grey,
                            onPressed: status != 'Reviewed'
                                ? () {
                                    FirebaseFirestore.instance
                                        .collection('Gate pass')
                                        .doc('CSE')
                                        .collection('Requests')
                                        .doc(id)
                                        .update({
                                      'Status': 'Reviewed',
                                    });
                                  }
                                : null,
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
