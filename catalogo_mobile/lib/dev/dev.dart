import 'package:flutter/material.dart';
import '../api/app_helper_api.dart';
import '../model/app.dart';
import '../model/developer.dart';
import '../widgets/butia_header.dart';
import '../widgets/card_app.dart';
import '../widgets/pagination_bar.dart';

class DetalheDevPage extends StatefulWidget {
  final int developerId;

  const DetalheDevPage({super.key, required this.developerId});

  @override
  State<DetalheDevPage> createState() => _DetalheDevPageState();
}

class _DetalheDevPageState extends State<DetalheDevPage> {
  final AppHelperApi _appApi = AppHelperApi();
  Developer? _developer;
  List<AppModel> _apps = [];
  bool _carregando = true;
  bool _carregandoApps = false;
  String? _erro;
  int _paginaAtual = 1;
  int _totalPaginas = 1;
  int _totalApps = 0;

  static const int _limitePorPagina = 10;

  @override
  void initState() {
    super.initState();
    _carregarDev();
  }

  Future<void> _carregarDev() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final dev = await _appApi.buscarDeveloperPorId(widget.developerId);
      final appsResp = await _appApi.listarApps(
        developerId: widget.developerId,
        page: 1,
        limit: _limitePorPagina,
      );
      if (!mounted) return;
      setState(() {
        _developer = dev;
        _apps = appsResp.data;
        _paginaAtual = appsResp.page;
        _totalPaginas = appsResp.totalPages;
        _totalApps = appsResp.total;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _carregarPaginaApps(int novaPagina) async {
    setState(() {
      _carregandoApps = true;
      _paginaAtual = novaPagina;
    });
    try {
      final appsResp = await _appApi.listarApps(
        developerId: widget.developerId,
        page: novaPagina,
        limit: _limitePorPagina,
      );
      if (!mounted) return;
      setState(() {
        _apps = appsResp.data;
        _paginaAtual = appsResp.page;
        _totalPaginas = appsResp.totalPages;
        _totalApps = appsResp.total;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _carregandoApps = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final devAtual = _developer;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      bottomNavigationBar: const ButiaBottomNav(abaAtiva: 1),
      body: SafeArea(
        child: Column(
          children: [
            const ButiaHeader(abaAtiva: 1),
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _erro != null || devAtual == null
                      ? Center(
                          child: Text(
                            _erro ?? 'Desenvolvedor não encontrado.',
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  label: const Text('Voltar'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF1A1C19),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  side: BorderSide(color: Colors.grey.shade200),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      RemoteIconAvatar(
                                        imageUrl: devAtual.icon,
                                        size: 68,
                                        borderRadius: 22,
                                        fallbackIcon: Icons.person_rounded,
                                        fallbackIconColor:
                                            const Color(0xFFF28C28),
                                        fallbackBackgroundColor:
                                            const Color(0xFFFFF3E6),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              devAtual.name,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: -0.4,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '$_totalApps aplicativos publicados',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF28C28),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Aplicativos do Desenvolvedor',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (_carregandoApps)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else ...[
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _apps.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 210,
                                    mainAxisExtent: 235,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemBuilder: (_, i) => CardApp(app: _apps[i]),
                                ),
                                PaginationBar(
                                  currentPage: _paginaAtual,
                                  totalPages: _totalPaginas,
                                  onPageChanged: _carregarPaginaApps,
                                ),
                              ],
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}