import '../../imports.dart';

class SlashClipper extends CustomClipper<Path> {
  final double progress;

  SlashClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    final cutX = size.width * progress;
    final cutY = size.height * progress;

    path.moveTo(0, 0);
    path.lineTo(cutX, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, cutY);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(SlashClipper oldClipper) => oldClipper.progress != progress;
}