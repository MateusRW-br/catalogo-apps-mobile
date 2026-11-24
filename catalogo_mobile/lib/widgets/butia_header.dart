import 'package:flutter/material.dart';
import '../login/login.dart';
import '../pesquisar_apps/pesquisar_apps.dart';
import '../pesquisar_devs/pesquisar_dev.dart';

class ButiaHeader extends StatelessWidget {
  final int abaAtiva; // 0 = Aplicativos, 1 = Desenvolvedores

  const ButiaHeader({super.key, required this.abaAtiva});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFDCE043),
              ),
              const SizedBox(width: 8),
              const Text(
                'Butiáapps',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (abaAtiva != 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PesquisarAppsPage(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: abaAtiva == 0
                          ? const Color(0xFF3CE86B)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text('Aplicativos'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (abaAtiva != 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PesquisarDevsPage(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: abaAtiva == 1
                          ? const Color(0xFF3CE86B)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text('Desenvolvedores'),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF3CE86B),
              child: Icon(Icons.person_outline, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}