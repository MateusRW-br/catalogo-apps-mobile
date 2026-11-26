import 'package:flutter/material.dart';
import '../login/login.dart';
import '../pesquisar_apps/pesquisar_apps.dart';
import '../pesquisar_devs/pesquisar_dev.dart';
import '../token/token_storage.dart';

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
class ButiaHeader extends StatefulWidget {
  final int abaAtiva;

  const ButiaHeader({super.key, this.abaAtiva = 0});

  @override
  State<ButiaHeader> createState() => _ButiaHeaderState();
}

class _ButiaHeaderState extends State<ButiaHeader> {
  final TokenStorage _tokenStorage = TokenStorage();
  UserSession? _sessao;

  @override
  void initState() {
    super.initState();
    _carregarSessao();
    TokenStorage.sessionVersion.addListener(_carregarSessao);
  }

  @override
  void dispose() {
    TokenStorage.sessionVersion.removeListener(_carregarSessao);
    super.dispose();
  }

  Future<void> _carregarSessao() async {
    final sessao = await _tokenStorage.lerSessao();
    if (!mounted) return;
    setState(() => _sessao = sessao);
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();
    return '$dia/$mes/$ano';
  }

  Widget _buildAvatar(UserSession sessao) {
    final avatarUrl = sessao.avatarUrl?.trim();
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF3CE86B), width: 2),
        ),
        child: ClipOval(
          child: Image.network(
            avatarUrl,
            width: 42,
            height: 42,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildFallbackAvatar(sessao),
          ),
        ),
      );
    }
    return _buildFallbackAvatar(sessao);
  }

  Widget _buildFallbackAvatar(UserSession sessao) {
    final nome = (sessao.fullName ?? sessao.name ?? '').trim();
    final inicial = nome.isNotEmpty ? nome[0].toUpperCase() : null;
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Color(0xFF3CE86B),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: inicial != null
          ? Text(
              inicial,
              style: const TextStyle(
                color: Color(0xFF0A2E14),
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            )
          : const Icon(
              Icons.person_rounded,
              color: Color(0xFF0A2E14),
              size: 22,
            ),
    );
  }

  Widget _buildPerfilDropdown(UserSession sessao) {
    final nomeExibicao =
        (sessao.fullName != null && sessao.fullName!.isNotEmpty)
            ? sessao.fullName!
            : (sessao.name ?? 'Usuário');

    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      elevation: 6,
      tooltip: 'Perfil',
      onSelected: (valor) async {
        if (valor == 'logout') {
          await _tokenStorage.limparSessao();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout realizado com sucesso.')),
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 210, maxWidth: 260),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAvatar(sessao),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeExibicao,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: Color(0xFF1A1C19),
                            ),
                          ),
                          if (sessao.name != null &&
                              sessao.name!.isNotEmpty &&
                              sessao.name != nomeExibicao)
                            Text(
                              '@${sessao.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (sessao.email != null && sessao.email!.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.mail_outline_rounded,
                        size: 15,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          sessao.email!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (sessao.birthDate != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.cake_outlined,
                        size: 15,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Nascimento: ${_formatarData(sessao.birthDate!)}',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.red, size: 20),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
      child: _buildAvatar(sessao),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessao = _sessao;

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
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButiaLogo(size: 34),
              SizedBox(width: 10),
              Text(
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
          if (sessao != null)
            _buildPerfilDropdown(sessao)
          else
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