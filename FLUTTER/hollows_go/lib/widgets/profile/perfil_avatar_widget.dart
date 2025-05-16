import '../../../imports.dart';

class PerfilAvatar extends StatelessWidget {
  final String imagePath;
  final VoidCallback onEditPressed;

  const PerfilAvatar({
    Key? key,
    required this.imagePath,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imagePath),
        ),
      ],
    );
  }
}
