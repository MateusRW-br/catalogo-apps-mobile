import 'package:flutter/material.dart';
import '../login/login.dart';
import '../pesquisar_apps/pesquisar_apps.dart';
import '../pesquisar_devs/pesquisar_dev.dart';

class ButiaLogo extends StatelessWidget {
  final double size;

  const ButiaLogo({super.key, this.size = 34});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/icons/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

/// icone da internet de app ou dev + fallback
class RemoteIconAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double borderRadius;
  final IconData fallbackIcon;
  final Color fallbackIconColor;
  final Color? fallbackBackgroundColor;
  final Gradient? fallbackGradient;

  const RemoteIconAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.borderRadius,
    required this.fallbackIcon,
    required this.fallbackIconColor,
    this.fallbackBackgroundColor,
    this.fallbackGradient,
  });

  Widget _buildFallback() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fallbackGradient == null ? fallbackBackgroundColor : null,
        gradient: fallbackGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        fallbackIcon,
        size: size * 0.48,
        color: fallbackIconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return _buildFallback();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildFallback(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: fallbackBackgroundColor ?? const Color(0xFFF0F6F1),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// appbar - topo
class ButiaHeader extends StatelessWidget {
  final int abaAtiva;

  const ButiaHeader({super.key, this.abaAtiva = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ButiaLogo(size: 34),
              const SizedBox(width: 10),
              const Text(
                'Butiápps',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Color(0xFF1A1C19),
                ),
              ),
            ],
          ),
          Material(
            color: const Color(0xFF3CE86B),
            shape: const CircleBorder(),
            elevation: 0,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF0A2E14),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// navbar - em baixo
class ButiaBottomNav extends StatelessWidget {
  final int abaAtiva; // 0 = apps, 1 = devs

  const ButiaBottomNav({super.key, required this.abaAtiva});

  void _navegar(BuildContext context, int index) {
    if (index == abaAtiva) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const PesquisarAppsPage(),
          transitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const PesquisarDevsPage(),
          transitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: abaAtiva,
        onDestinationSelected: (index) => _navegar(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.apps_outlined),
            selectedIcon: Icon(Icons.apps_rounded),
            label: 'Aplicativos',
          ),
          NavigationDestination(
            icon: Icon(Icons.code_outlined),
            selectedIcon: Icon(Icons.code_rounded),
            label: 'Desenvolvedores',
          ),
        ],
      ),
    );
  }
}