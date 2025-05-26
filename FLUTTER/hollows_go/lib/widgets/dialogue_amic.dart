import '../imports.dart';

class AfegirAmicDialog extends StatefulWidget {
  final Function() onAmicAfegit;

  const AfegirAmicDialog({
    Key? key,
    required this.onAmicAfegit,
  }) : super(key: key);

  @override
  _AfegirAmicDialogState createState() => _AfegirAmicDialogState();
}

class _AfegirAmicDialogState extends State<AfegirAmicDialog> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _afegirAmic() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Si us plau, introdueix un email')),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Si us plau, introdueix un email vàlid')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await Provider.of<UserProvider>(context, listen: false)
          .crearAmistat(email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );

      if (result['success']) {
        _emailController.clear();
        widget.onAmicAfegit();
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Afegir nou amic'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email del nou amic',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _emailController.clear(),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel·lar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _afegirAmic,
                  child: const Text('Afegir'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
