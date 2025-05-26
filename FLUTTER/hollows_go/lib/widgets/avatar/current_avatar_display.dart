import 'package:flutter/material.dart';

class CurrentAvatarDisplay extends StatelessWidget {
  final Future<String> avatarFuture;

  const CurrentAvatarDisplay({super.key, required this.avatarFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: avatarFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No s\'ha pogut carregar l\'avatar actual.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              const Text(
                'Avatar actual:',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(snapshot.data!),
              ),
            ],
          ),
        );
      },
    );
  }
}
