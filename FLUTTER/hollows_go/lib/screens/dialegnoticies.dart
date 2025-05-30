import 'package:flutter/material.dart';

class DialegNoticies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Novetats',
            style: TextStyle(
              color: Colors.amberAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                'Aquí anirà el text i imatges de novetats...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tancar',
                style: TextStyle(color: Colors.amberAccent),
              ),
            ),
          )
        ],
      ),
    );
  }
}
