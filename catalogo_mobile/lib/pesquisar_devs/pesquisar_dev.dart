import 'package:flutter/material.dart';
import '../api/app_helper_api.dart';
import '../dev/dev.dart';
import '../model/developer.dart';
import '../widgets/butia_header.dart';
import '../widgets/pagination_bar.dart';

class PesquisarDevsPage extends StatefulWidget {
  const PesquisarDevsPage({super.key});

  @override
  State<PesquisarDevsPage> createState() => _PesquisarDevsPageState();
}

class _PesquisarDevsPageState extends State<PesquisarDevsPage> {
  final TextEditingController _buscaController = TextEditingController();
  final AppHelperApi _appApi = AppHelperApi();
  List<Developer> _todosDevs = [];
  bool _carregando = true;
  String? _erro;
  int _paginaAtual = 1;
  int _totalPaginas = 1;
  int _totalDevs = 0;

  static const int _limitePorPagina = 10;

  @override
  void initState() {
    super.initState();
    _carregarDevs();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarDevs({int? pagina}) async {
    final paginaAlvo = pagina ?? _paginaAtual;
    setState(() {
      _carregando = true;
      _erro = null;
      _paginaAtual = paginaAlvo;
    });
    try {
      final resp = await _appApi.listarDevelopers(
        page: paginaAlvo,
        limit: _limitePorPagina,
      );
      if (!mounted) return;
      setState(() {
        _todosDevs = resp.data;
        _paginaAtual = resp.page;
        _totalPaginas = resp.totalPages;
        _totalDevs = resp.total;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final termo = _buscaController.text.trim().toLowerCase();
    final devs = _todosDevs
        .where((d) => termo.isEmpty || d.name.toLowerCase().contains(termo))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      bottomNavigationBar: const ButiaBottomNav(abaAtiva: 1),
      body: SafeArea(
        child: Column(
          children: [
            const ButiaHeader(abaAtiva: 1),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF1B8A3D),
                onRefresh: _carregarDevs,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            color: Color(0xFF1A1C19),
                          ),
                          children: [
                            TextSpan(text: 'Pesquisar '),
                            TextSpan(
                              text: 'Desenvolvedores',
                              style: TextStyle(color: Color(0xFFF28C28)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SearchBar(
                        controller: _buscaController,
                        onChanged: (_) => setState(() {}),
                        hintText: 'Pesquisar desenvolvedores...',
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF1B8A3D),
                          ),
                        ),
                        trailing: [
                          if (_buscaController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 20),
                              onPressed: () {
                                _buscaController.clear();
                                setState(() {});
                              },
                            ),
                        ],
                        elevation: const WidgetStatePropertyAll(0),
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.white,
                        ),
                        side: const WidgetStatePropertyAll(
                          BorderSide(color: Color(0xFF3CE86B), width: 1.5),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '${termo.isEmpty ? _totalDevs : devs.length} desenvolvedores encontrados',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_carregando)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_erro != null)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red.shade700,
                                size: 36,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _erro!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        ...devs.map(
                          (dev) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              color: Colors.white,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DetalheDevPage(developerId: dev.id),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      RemoteIconAvatar(
                                        imageUrl: dev.icon,
                                        size: 54,
                                        borderRadius: 18,
                                        fallbackIcon: Icons.person_rounded,
                                        fallbackIconColor:
                                            const Color(0xFFF28C28),
                                        fallbackBackgroundColor:
                                            const Color(0xFFFFF3E6),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dev.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                color: Color(0xFF1A1C19),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Desenvolvedor verificado',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE5F9EB),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          '${dev.appsCount} apps',
                                          style: const TextStyle(
                                            color: Color(0xFF0A2E14),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        PaginationBar(
                          currentPage: _paginaAtual,
                          totalPages: _totalPaginas,
                          onPageChanged: (novaPagina) =>
                              _carregarDevs(pagina: novaPagina),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}