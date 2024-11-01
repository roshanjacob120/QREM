import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
class RegisterNewUserPage extends StatefulWidget {
  const RegisterNewUserPage({Key? key}) : super(key: key);

  @override
  _RegisterNewUserPageState createState() => _RegisterNewUserPageState();
}

class _RegisterNewUserPageState extends State<RegisterNewUserPage> {
  final TextEditingController _emailController = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  EmailOTP myauth = EmailOTP();
  String otp="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register New User',
          style: GoogleFonts.sulphurPoint(),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Email',
              style: GoogleFonts.sulphurPoint(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () async {
                  if (_emailController.text.endsWith('@mbcet.ac.in')) {
                    myauth.setConfig(
                      appEmail: "me@rohitchouhan.com",
                      appName: "Email OTP",
                      userEmail: _emailController.text,
                      otpLength: 6,
                      otpType: OTPType.digitsOnly,
                    );
                    if (await myauth.sendOTP() == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('OTP has been sent'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Oops, OTP send failed'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid email. Only emails ending with @mbcet.ac.in are accepted'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Send OTP',
                  style: GoogleFonts.sulphurPoint(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'OTP',
              style: GoogleFonts.sulphurPoint(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            OTPTextField(
                controller: otpController,
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 45,
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 15,
                style: TextStyle(fontSize: 17),
                onChanged: (pin) {
                  otp=pin;
                },
                onCompleted: (pin) {
                  otp=pin;
                }),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black),
                onPressed: () async {
                  if (await myauth.verifyOTP(otp: otp) ==
                      true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('OTP is verified'),
                      ),
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>register(email: _emailController.text)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid OTP'),
                      ),
                    );
                  }
                },
                child: Text('Verify',
                  style: GoogleFonts.sulphurPoint(),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
