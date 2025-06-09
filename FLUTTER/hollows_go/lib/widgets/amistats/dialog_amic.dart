import 'package:hollows_go/widgets/custom_loading_indicator.dart';

import '../../imports.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.75),
              Colors.orange.shade900.withOpacity(0.7),
            ],
            stops: [0.75, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orangeAccent.shade100, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Afegir nou amic',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent.shade100,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email del nou amic',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.orangeAccent.shade100),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () => _emailController.clear(),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CustomLoadingIndicator())
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel·lar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _afegirAmic,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Afegir',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
