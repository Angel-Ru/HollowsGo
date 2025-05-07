import '../imports.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 61, 61, 61),
        /*boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],*/
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.map, 'Mapa', 1),
          _buildNavItem(context, Icons.storefront, 'Tienda', 2),
          _buildHomeButton(context),
          _buildNavItem(context, Icons.apps, 'Biblioteca', 3),
          _buildNavItem(context, Icons.person, 'Perfil', 4),
        ],
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(0); // HomeScreen es el índice 0
        _handleDialogueChange(context, 0);
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.home_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        onTap(index);
        _handleDialogueChange(context, index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.orange : Colors.grey,
            size: isSelected ? 28 : 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.orange : Colors.grey,
              fontSize: isSelected ? 12 : 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _handleDialogueChange(BuildContext context, int index) {
    final dialogueProvider =
        Provider.of<DialogueProvider>(context, listen: false);

    switch (index) {
      case 0: // Home
        dialogueProvider.loadDialogueFromJson("ichigo");
        break;
      case 2: // Tienda
        dialogueProvider.loadDialogueFromJson("urahara");
        break;
      case 3: // Biblioteca
        dialogueProvider.loadDialogueFromJson("mayuri");
        break;
      // Perfil (4) no necesita diálogo específico
    }
  }
}
