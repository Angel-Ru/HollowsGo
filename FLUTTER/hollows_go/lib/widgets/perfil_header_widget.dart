import '../imports.dart';

class PerfilHeader extends StatelessWidget {
  final String username;

  const PerfilHeader({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          username,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TITOL USUARI',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Edición de título de usuario
              },
              child: Icon(
                Icons.edit,
                size: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
