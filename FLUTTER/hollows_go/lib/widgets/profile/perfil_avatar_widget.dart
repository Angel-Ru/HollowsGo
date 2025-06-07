import '../../imports.dart';

class PerfilAvatar extends StatelessWidget {
  final String imagePath;
  final int nivell;
  final int expEmmagatzemada;
  final int expMaxima;

  const PerfilAvatar({
    Key? key,
    required this.imagePath,
    required this.nivell,
    this.expEmmagatzemada = 0,
    this.expMaxima = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = expMaxima > 0 ? expEmmagatzemada / expMaxima : 0.0;

    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Barra de progreso circular (fondo)
          SizedBox(
            width: 130,
            height: 130,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 6,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.1)),
            ),
          ),

          // Barra de progreso circular (relleno)
          SizedBox(
            width: 130,
            height: 130,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),

          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Indicador de nivel
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                nivell.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
