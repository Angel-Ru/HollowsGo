import '../../imports.dart';

class InkWritePainter extends CustomPainter {
  final String text;
  final double progress;
  final bool isShinji;
  final TextStyle textStyle;

  InkWritePainter({
    required this.text,
    required this.progress,
    required this.isShinji,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final characters = text.characters.toList();

    // Amplada màxima del fons negre on pintem
    final maxWidth = size.width * 0.9;

    // Dividim el text en línies automàticament segons el maxWidth
    List<String> lines = _splitTextIntoLines(text, textStyle, maxWidth);

    // Altura de cada línia (màxima de la font)
    final textPainterForLineHeight = TextPainter(
      text: TextSpan(text: 'M', style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainterForLineHeight.layout();
    final lineHeight = textPainterForLineHeight.height;

    // Altura total del text
    final totalHeight = lineHeight * lines.length;

    // Punt y per començar a pintar centrant verticalment
    double startY = (size.height - totalHeight) / 2;

    int charIndex = 0; // index global de lletra pel progrés

    for (final line in lines) {
      // Layout de la línia sencera per calcular amplada i poder centrar-la
      final linePainter = TextPainter(
        text: TextSpan(text: line, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      linePainter.layout(maxWidth: maxWidth);

      // X inicial per centrar la línia
      double startX = (size.width - linePainter.width) / 2;

      double currentX = startX;

      // Pintem lletra a lletra la línia amb rotació suau individual
      for (int i = 0; i < line.length; i++) {
        double charProgress = (progress * text.length) - charIndex;
        charProgress = charProgress.clamp(0.0, 1.0);

        if (charProgress == 0) {
          // Si la lletra encara no toca mostrar, acabem línia i canvas
          break;
        }

        final char = line[i];

        final charPainter = TextPainter(
          text: TextSpan(text: char, style: textStyle),
          textDirection: TextDirection.ltr,
        );
        charPainter.layout();

        canvas.save();

        // Traduïm al centre de la lletra per rotar-la
        canvas.translate(currentX + charPainter.width / 2, startY + lineHeight / 2);

        if (isShinji) {
          // Rotació suau i més lenta, però fins a 180 graus
          final easedProgress = pow(charProgress, 0.5).toDouble();
          final angle = easedProgress * pi;
          canvas.rotate(angle);
        }

        // Pintem la lletra centrada al seu punt de rotació
        charPainter.paint(canvas, Offset(-charPainter.width / 2, -charPainter.height / 2));

        canvas.restore();

        // Avancem currentX sumant amplada lletra + marge per rotació
        currentX += charPainter.width + 4;

        charIndex++;
      }

      startY += lineHeight; // avançar y per següent línia
    }
  }

  // Funció per tallar text en línies segons l'amplada maxWidth i estil
  List<String> _splitTextIntoLines(String text, TextStyle style, double maxWidth) {
    final words = text.split(' ');
    List<String> lines = [];
    String currentLine = '';

    for (final word in words) {
      final testLine = currentLine.isEmpty ? word : '$currentLine $word';

      final painter = TextPainter(
        text: TextSpan(text: testLine, style: style),
        textDirection: TextDirection.ltr,
      );
      painter.layout();

      if (painter.width > maxWidth) {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
          currentLine = word;
        } else {
          // paraula sola molt llarga, afegim igual
          lines.add(word);
          currentLine = '';
        }
      } else {
        currentLine = testLine;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines;
  }

  @override
  bool shouldRepaint(covariant InkWritePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.text != text ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.isShinji != isShinji;
  }
}

