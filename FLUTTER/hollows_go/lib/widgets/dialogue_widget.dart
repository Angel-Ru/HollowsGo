import '../imports.dart';

class DialogueWidget extends StatelessWidget {
  final String characterName;
  final Color nameColor;
  final Color bubbleColor;
  final Color backgroundColor;

  const DialogueWidget({
    Key? key,
    required this.characterName,
    this.nameColor = Colors.green,
    this.bubbleColor = const Color.fromARGB(212, 238, 238, 238),
    this.backgroundColor = const Color.fromARGB(255, 151, 250, 173),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dialogueProvider = Provider.of<DialogueProvider>(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: dialogueProvider.nextDialogue,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(dialogueProvider.currentImage),
            backgroundColor: backgroundColor,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: dialogueProvider.nextDialogue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(243, 194, 194, 194),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    characterName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: nameColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    dialogueProvider.currentDialogue,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
