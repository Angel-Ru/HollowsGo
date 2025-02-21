import 'dart:math';
import 'package:flutter/material.dart';

class CombatScreen extends StatefulWidget {
  @override
  _CombatScreenState createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  double aliatHealth = 1.0; // Salud actual de Ichigo (valor entre 0 y 1)
  double enemicHealth = 1.0; // Salud actual de Aizen (valor entre 0 y 1)

  int aliatHPMX = 1000; // Vida máxima de Ichigo
  int enemicHP = 1000; // Vida máxima de Aizen

  late String backgroundImage;

  @override
  void initState() {
    super.initState();
    _setRandomBackground();
  }

  void _setRandomBackground() {
    final random = Random();
    int randomIndex = random.nextInt(4) + 1;
    backgroundImage = 'lib/images/combat_proves/fondo_combat_$randomIndex.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/combat_proves/aizen_combat.png',
                      height: 300,
                      width: 300,
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "Dondodochakka",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                          SizedBox(width: 10),
                          _buildHealthBar(enemicHealth, enemicHP),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/combat_proves/bleach_combat.png',
                      height: 250,
                      width: 250,
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildHealthBar(aliatHealth, aliatHPMX),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  "Ichigo",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (enemicHealth > 0) {
                                  enemicHealth -= 100 / enemicHP;
                                  if (enemicHealth < 0) {
                                    enemicHealth = 0;
                                  }
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 12),
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text("LUCHAR", style: TextStyle(fontSize: 18)),
                                SizedBox(height: 4),
                                Text(
                                  "Bankai Getsuga Tensho",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBar(double health, int hp) {
    Color barColor = Colors.green;
    if (health < 0.6) barColor = Colors.orange;
    if (health < 0.2) barColor = Colors.red;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Container(
            width: 200,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: health),
              duration: Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Container(
                  width: 200 * value,
                  height: 24,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: 200,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
        ),
        Positioned(
          child: Text(
            "${(health * hp).toInt()}/$hp",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 2,
                  color: Colors.black,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
