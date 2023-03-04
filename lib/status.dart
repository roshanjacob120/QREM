import 'package:flutter/material.dart';

class RequestStatusPage extends StatefulWidget {
  final int requestStatus;

  RequestStatusPage({required this.requestStatus});

  @override
  _RequestStatusPageState createState() => _RequestStatusPageState();
}

class _RequestStatusPageState extends State<RequestStatusPage> {
  @override
  Widget build(BuildContext context) {
    String statusName = getStatusName(widget.requestStatus);

    return Scaffold(
      appBar: AppBar(
        title: Text('Request Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Request Status:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: Colors.blue,
                  activeTrackColor: Colors.blue,
                  inactiveTrackColor: Colors.blue,
                  trackHeight: 10,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayColor: Colors.blue.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28),
                  valueIndicatorColor: Colors.blue,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                child: Slider(
                  min: 0,
                  max: 3,
                  value: widget.requestStatus.toDouble(),
                  divisions: 3,
                  label: statusName,
                  onChanged: null,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              statusName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getStatusName(int status) {
    switch (status) {
      case 0:
        return 'Request Sent';
      case 1:
        return 'Request Accepted by Advisor';
      case 2:
        return 'Request Accepted by HOD';
      case 3:
        return 'QR Code Generated';
      default:
        return 'Unknown';
    }
  }
}
