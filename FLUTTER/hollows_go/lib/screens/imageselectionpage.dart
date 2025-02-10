import 'package:hollows_go/imports.dart';

class ImageSelectionPage extends StatelessWidget {
  // Llista amb les rutes de les imatges locals, cal dir que també han d'estar especificades al pub
  final List<String> imagePaths = [
    'lib/images/chad.png',
    'lib/images/kon.png',
    'lib/images/kenpachi.png',
    'lib/images/grimmjaw.png',
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
          crossAxisCount: 3, // Tres columnes per distribuir les imatges
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onImageSelected(imagePaths[index]);
              Navigator.pop(context); // Tanca la pàgina al seleccionar l'imatge
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              clipBehavior: Clip
                  .antiAlias, // Això el que fa es fer que l'imatge tengui els cantons redons
              child: Image.asset(
                imagePaths[index],
                fit: BoxFit
                    .cover, // M'ajusta l'imatge al contenidor ja que sinò les imatges eren de diferents mides i no me quedaven igual
              ),
            ),
          );
        },
      ),
    );
  }
}
