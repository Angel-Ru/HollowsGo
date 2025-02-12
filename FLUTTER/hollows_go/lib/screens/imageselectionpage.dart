import 'package:hollows_go/imports.dart';

class ImageSelectionPage extends StatelessWidget {
  // Lista con las rutas de las imágenes locales
  final List<String> imagePaths = [
    'lib/images/chad.png',
    'lib/images/kon.png',
    'lib/images/kenpachi.png',
    'lib/images/grimmjaw.png',
    'lib/images/komamura_goty.jpg',
  ];

  final Function(String) onImageSelected;

  ImageSelectionPage({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una imatge'),
        backgroundColor: Colors.blueGrey,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Tres columnas para distribuir las imágenes
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onImageSelected(imagePaths[index]);
              Navigator.pop(
                  context); // Cierra la página al seleccionar la imagen
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              clipBehavior: Clip
                  .antiAlias, // Hace que la imagen tenga los bordes redondeados
              child: Image.asset(
                imagePaths[index],
                fit: BoxFit.cover, // Ajusta la imagen al contenedor
              ),
            ),
          );
        },
      ),
    );
  }
}
