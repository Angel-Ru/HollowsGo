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
        if (skins != null) {
          _skins = skins;
        }
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
      appBar: AppBar(
        title: Text(_personatge?.nom ?? ''),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _personatge == null
              ? const Center(
                  child: Text('No s\'ha pogut carregar el personatge.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _personatge!.nom,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (_personatge!.descripcio != null)
                        Text(
                          _personatge!.descripcio!,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      const SizedBox(height: 20),
                      Text('Estadístiques',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _buildStatRow('Classe', _personatge!.classe.toString()),
                      _buildStatRow(
                          'Vida base', _personatge!.vidaBase?.toString()),
                      _buildStatRow(
                          'Mal base', _personatge!.malBase?.toString()),
                      _buildStatRow(
                          'Alçada',
                          _personatge!.altura != null
                              ? '${_personatge!.altura} cm'
                              : null),
                      _buildStatRow(
                          'Pes',
                          _personatge!.pes != null
                              ? '${_personatge!.pes} kg'
                              : null),
                      _buildStatRowWithIcon('Gènere', _personatge!.genere),
                      _buildStatRow('Aniversari',
                          _formatAniversari(_personatge!.aniversari)),
                      const SizedBox(height: 24),
                      SkinsListWidget(skins: _skins),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? 'Desconegut'),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
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
