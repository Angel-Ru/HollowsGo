import 'dart:ui';
import 'package:hollows_go/models/habilitat_llegendaria.dart';
import 'package:hollows_go/providers/habilitat_provider.dart';
import 'package:hollows_go/widgets/custom_loading_indicator.dart';
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
  HabilitatLlegendaria? _habilitat;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final personatgeProvider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    final habilitatProvider =
        Provider.of<HabilitatProvider>(context, listen: false);

    // Ejecuta todas las futuras en paralelo
    final results = await Future.wait([
      personatgeProvider.fetchPersonatgeById(widget.personatgeId),
      personatgeProvider.fetchPersonatgeSkins(widget.personatgeId),
      habilitatProvider.loadHabilitatPerPersonatgeId(widget.personatgeId),
    ]);

    if (!mounted) return;

    setState(() {
      _personatge = results[0] as Personatge?;
      _skins = results[1] as List<Skin>? ?? [];
      _habilitat = habilitatProvider.habilitat;
      _isLoading = false;
    });
  }

  String _formatAniversari(DateTime? aniversari) => aniversari == null
      ? 'Desconegut'
      : '${aniversari.day}/${aniversari.month}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Detalls del Personatge',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/detailsscreen/fondo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CustomLoadingIndicator())
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
                            style: const TextStyle(
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
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70),
                            ),
                          const SizedBox(height: 20),
                          const Text('Estadístiques',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(height: 8),
                          _buildStatsSection(),
                          if (_habilitat != null) ...[
                            const SizedBox(height: 4),
                            _buildHabilitatSection(),
                          ],
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
    return _buildContainer(
      children: [
        _buildStatItem('Classe', _personatge!.classe.toString()),
        _buildStatItem('Vida base', _personatge!.vidaBase?.toString() ?? '-'),
        _buildStatItem('Mal base', _personatge!.malBase?.toString() ?? '-'),
        _buildStatItem('Alçada',
            _personatge!.altura != null ? '${_personatge!.altura} cm' : '-'),
        _buildStatItem(
            'Pes', _personatge!.pes != null ? '${_personatge!.pes} kg' : '-'),
        _buildStatRowWithIcon('Gènere', _personatge!.genere),
        _buildStatItem(
            'Aniversari', _formatAniversari(_personatge!.aniversari)),
      ],
    );
  }

  Widget _buildHabilitatSection() {
    return _buildContainer(
      borderColor: Colors.yellow.withOpacity(0.5),
      children: [
        _buildStatItem('Habilitat', _habilitat!.nom),
        _buildStatItem('Descripció habilitat', _habilitat!.descripcio),
        _buildStatItem('Efecte habilitat', _habilitat!.efecte),
      ],
    );
  }

  Widget _buildContainer({required List<Widget> children, Color? borderColor}) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
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
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
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
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
          Expanded(
            child: Row(
              children: [
                if (iconData != null)
                  Icon(iconData, color: iconColor, size: 20),
                if (iconData != null) const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
