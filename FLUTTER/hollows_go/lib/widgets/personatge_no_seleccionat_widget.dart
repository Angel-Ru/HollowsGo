import '../imports.dart';

class PersonatgeNoSeleccionatDialog {
  static Future<void> mostrar(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.infoReverse,
      animType: AnimType.scale,
      borderSide: BorderSide(color: Colors.orange, width: 2),
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      descTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      title: 'Skin no seleccionada',
      desc: 'Has de seleccionar una skin (personatge) per poder jugar.',
      btnOkText: 'Anar a la biblioteca',
      btnOkOnPress: () {
        Provider.of<UIProvider>(context, listen: false).selectedMenuOpt = 3;
      },
      btnOkColor: Colors.orange,
      dialogBackgroundColor: Colors.black.withOpacity(0.85),
    ).show();
  }
}
