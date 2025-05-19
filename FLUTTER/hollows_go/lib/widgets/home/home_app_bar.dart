import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/ui_provider.dart';
import '../../providers/vials_provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String imagePath;

  const HomeAppBar({required this.imagePath});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 61, 61, 61),
          elevation: 0,
          title: Consumer2<UserProvider, VialsProvider>(
            builder: (context, userProvider, vialsProvider, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Moneda i Vials (compactats)
                Row(
                  children: [
                    _iconWithText(
                      imageUrl:
                          'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254176/OTHERS/yslqndyf4eri3f7mpl6i.png',
                      value: userProvider.coinCount,
                    ),
                    SizedBox(width: 12),
                    _iconWithText(
                      imageUrl:
                          'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/VIAL/w9h0t4ugeq8pn84kc1pd',
                      value: vialsProvider.vials,
                    ),
                  ],
                ),

                // Usuari
                Row(
                  children: [
                    Text(
                      userProvider.username,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => uiProvider.selectedMenuOpt = 4,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(imagePath),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Widget reutilitzable per icona + número
  Widget _iconWithText({required String imageUrl, required int value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 6),
          Text(
            '$value',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
