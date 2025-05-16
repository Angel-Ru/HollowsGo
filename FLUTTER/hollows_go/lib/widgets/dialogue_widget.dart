import 'package:animated_text_kit/animated_text_kit.dart';
import '../imports.dart';

class DialogueWidget extends StatefulWidget {
  final String characterName;
  final Color nameColor;
  final Color bubbleColor;

  const DialogueWidget({
    Key? key,
    required this.characterName,
    this.nameColor = Colors.green,
    this.bubbleColor = const Color.fromARGB(212, 238, 238, 238),
  }) : super(key: key);

  @override
  State<DialogueWidget> createState() => _DialogueWidgetState();
}

class _DialogueWidgetState extends State<DialogueWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isAnimatingFade = false;
  bool _showAnimatedText = true;
  String _currentDialogue = '';

  @override
  void initState() {
    super.initState();

    final dialogueProvider =
        Provider.of<DialogueProvider>(context, listen: false);
    _currentDialogue = dialogueProvider.currentDialogue;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          final dialogueProvider =
              Provider.of<DialogueProvider>(context, listen: false);
          dialogueProvider.nextDialogue();

          setState(() {
            _currentDialogue = dialogueProvider.currentDialogue;
            _showAnimatedText = true;
          });
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          setState(() {
            _isAnimatingFade = false;
          });
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dialogueProvider = Provider.of<DialogueProvider>(context);
    if (dialogueProvider.currentDialogue != _currentDialogue) {
      setState(() {
        _currentDialogue = dialogueProvider.currentDialogue;
        _showAnimatedText = false;
      });

      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            _showAnimatedText = true;
          });
        }
      });
    }
  }

  void _onTap() {
    if (_isAnimatingFade) return;

    setState(() {
      _isAnimatingFade = true;
      _showAnimatedText = false;
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBubblePointer() {
    return Container(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _TrianglePainter(
          color: widget.nameColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogueProvider = Provider.of<DialogueProvider>(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: _onTap,
          child: Container(
            width: 150,
            height: 250,
            child: FadeTransition(
              opacity: _animation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  dialogueProvider.currentImage,
                  key: ValueKey(dialogueProvider.currentImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: widget.nameColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        widget.characterName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          bottomLeft: Radius.circular(4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: widget.nameColor.withOpacity(0.6), 
                          width: 1.5,
                        ),
                      ),
                      child: FadeTransition(
                        opacity: _animation,
                        child: _showAnimatedText
                            ? AnimatedTextKit(
                                isRepeatingAnimation: false,
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    _currentDialogue,
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                      height: 1.3,
                                    ),
                                    speed: Duration(milliseconds: 30),
                                  ),
                                ],
                              )
                            : Text(
                                _currentDialogue,
                                key: ValueKey(_currentDialogue),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.left,
                              ),
                      ),
                    ),

                    Positioned(
                      left: -16,
                      top: 20,
                      child: _buildBubblePointer(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        color,
        Colors.black87,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
