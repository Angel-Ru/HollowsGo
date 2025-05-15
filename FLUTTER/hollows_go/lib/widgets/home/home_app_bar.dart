import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/ui_provider.dart';

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
          title: Consumer<UserProvider>(
            builder: (context, userProvider, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254176/OTHERS/yslqndyf4eri3f7mpl6i.png',
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${userProvider.coinCount}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(userProvider.username, style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => uiProvider.selectedMenuOpt = 4,
                      child: CircleAvatar(
                        radius: 20,
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
}
