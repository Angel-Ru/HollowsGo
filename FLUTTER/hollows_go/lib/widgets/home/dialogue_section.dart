import 'package:flutter/material.dart';
import 'package:hollows_go/widgets/dialogue_widget.dart';

class DialogueSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 20),
          DialogueWidget(
            characterName: 'Ichigo Kurosaki',
            nameColor: Colors.orange,
            bubbleColor: Color.fromARGB(212, 238, 238, 238),
          ),
        ],
      ),
    );
  }
}
