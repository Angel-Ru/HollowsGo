import 'dart:ui';
import '../imports.dart';

class DetailScreen extends StatefulWidget {
  final int personatgeId;

  const DetailScreen({Key? key, required this.personatgeId}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Personatge? _personatge;
  List<Skin> _skins = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersonatge();
  }

  Future<void> _loadPersonatge() async {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    final personatge = await provider.fetchPersonatgeById(widget.personatgeId);
    final skins = await provider.fetchPersonatgeSkins(widget.personatgeId);
    if (mounted) {
      setState(() {
        _skins = skins ?? [];
        _personatge = personatge;
        _isLoading = false;
      });
    }
  }

  String _formatAniversari(DateTime? aniversari) {
    if (aniversari == null) return 'Desconegut';
    return '${aniversari.day}/${aniversari.month}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Detalls del Personatge',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Fondo decorativo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/bibliotecascreen_images/biblioteca_aliats_fondo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenido
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _personatge == null
                  ? const Center(
                      child: Text('No s\'ha pogut carregar el personatge.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _personatge!.nom,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 4)
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_personatge!.descripcio != null)
                            Text(
                              _personatge!.descripcio!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          const SizedBox(height: 20),
                          Text('Estadístiques',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                          const SizedBox(height: 8),
                          _buildStatsSection(),
                          const SizedBox(height: 24),
                          SkinsListWidget(skins: _skins),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.7, // Ocupa la mitad del ancho disponible
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatItem('Classe', _personatge!.classe.toString()),
              _buildStatItem(
                  'Vida base', _personatge!.vidaBase?.toString() ?? '-'),
              _buildStatItem(
                  'Mal base', _personatge!.malBase?.toString() ?? '-'),
              _buildStatItem(
                  'Alçada',
                  _personatge!.altura != null
                      ? '${_personatge!.altura} cm'
                      : '-'),
              _buildStatItem('Pes',
                  _personatge!.pes != null ? '${_personatge!.pes} kg' : '-'),
              _buildStatRowWithIcon('Gènere', _personatge!.genere),
              _buildStatItem(
                  'Aniversari', _formatAniversari(_personatge!.aniversari)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRowWithIcon(String label, String? genere) {
    IconData? iconData;
    Color? iconColor;

    if (genere == 'M') {
      iconData = Icons.male;
      iconColor = Colors.blue;
    } else if (genere == 'F') {
      iconData = Icons.female;
      iconColor = Colors.pink;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (iconData != null)
                  Icon(iconData, color: iconColor, size: 20),
                if (iconData != null) SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
