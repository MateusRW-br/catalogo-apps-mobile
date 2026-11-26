import 'package:flutter/material.dart';
import '../api/app_helper_api.dart';
import '../model/app.dart';
import '../widgets/butia_header.dart';
import '../widgets/card_app.dart';
import '../widgets/pagination_bar.dart';

class PesquisarAppsPage extends StatefulWidget {
  const PesquisarAppsPage({super.key});

  @override
  State<PesquisarAppsPage> createState() => _PesquisarAppsPageState();
}

class _PesquisarAppsPageState extends State<PesquisarAppsPage> {
  final TextEditingController _buscaController = TextEditingController();
  final AppHelperApi _appApi = AppHelperApi();
  String? _precificacaoSelecionada; // Uma só ou nenhuma (null)
  bool _ordenarPorNome = false; // false = Nota (padrão), true = Nome (alphabetical)
  bool _carregando = true;
  String? _erro;
  List<AppModel> _apps = [];
  int _paginaAtual = 1;
  int _totalPaginas = 1;
  int _totalApps = 0;

  static const int _limitePorPagina = 10;

  static const Map<String, String> _precificacoesFiltro = {
    'Grátis': 'free',
    'Pago': 'paid',
    'Freemium': 'freemium',
    'FOSS': 'foss',
  };

  @override
  void initState() {
    super.initState();
    _carregarApps();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarApps({int? pagina}) async {
    final paginaAlvo = pagina ?? _paginaAtual;
    setState(() {
      _carregando = true;
      _erro = null;
      _paginaAtual = paginaAlvo;
    });

    try {
      final resposta = await _appApi.listarApps(
        search: _buscaController.text,
        pricing: _precificacaoSelecionada,
        sortBy: _ordenarPorNome ? 'alphabetical' : null,
        page: paginaAlvo,
        limit: _limitePorPagina,
      );

      if (!mounted) return;
      setState(() {
        _apps = resposta.data;
        _paginaAtual = resposta.page;
        _totalPaginas = resposta.totalPages;
        _totalApps = resposta.total;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      bottomNavigationBar: const ButiaBottomNav(abaAtiva: 0),
      body: SafeArea(
        child: Column(
          children: [
            const ButiaHeader(abaAtiva: 0),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF1B8A3D),
                onRefresh: () => _carregarApps(pagina: _paginaAtual),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                        textAlign: TextAlign.left,
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
                              text: 'Aplicativos',
                              style: TextStyle(color: Color(0xFFF28C28)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Barra de pesquisa no topo adaptada para telas menores
                      SearchBar(
                        controller: _buscaController,
                        onChanged: (_) => _carregarApps(pagina: 1),
                        onSubmitted: (_) => _carregarApps(pagina: 1),
                        hintText: 'Pesquisar aplicativos...',
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
                                _carregarApps(pagina: 1);
                              },
                            ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF1B8A3D),
                            ),
                            onPressed: () => _carregarApps(pagina: 1),
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
                      const SizedBox(height: 12),
                      // Embaixo da barra: botão de ordenação e dropdown de precificação (uma só ou nenhuma)
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: () {
                                setState(() {
                                  _ordenarPorNome = !_ordenarPorNome;
                                });
                                _carregarApps(pagina: 1);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFE5F9EB),
                                foregroundColor: const Color(0xFF0A2E14),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: Color(0xFF3CE86B),
                                  ),
                                ),
                              ),
                              icon: Icon(
                                _ordenarPorNome
                                    ? Icons.sort_by_alpha_rounded
                                    : Icons.star_rounded,
                                size: 18,
                              ),
                              label: Text(
                                _ordenarPorNome
                                    ? 'Ordenar (Nome)'
                                    : 'Ordenar (Nota)',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _precificacaoSelecionada != null
                                    ? const Color(0xFFFFF3E6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _precificacaoSelecionada != null
                                      ? const Color(0xFFF28C28)
                                      : Colors.grey.shade300,
                                  width: 1.2,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String?>(
                                  value: _precificacaoSelecionada,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFFF28C28),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  dropdownColor: Colors.white,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1C19),
                                  ),
                                  hint: const Text(
                                    'Precificação',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1C19),
                                    ),
                                  ),
                                  items: [
                                    const DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text(
                                        'Precificação (Todas)',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    ..._precificacoesFiltro.entries.map(
                                      (entry) => DropdownMenuItem<String?>(
                                        value: entry.value,
                                        child: Text(
                                          entry.key,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (valor) {
                                    setState(() {
                                      _precificacaoSelecionada = valor;
                                    });
                                    _carregarApps(pagina: 1);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$_totalApps aplicativos encontrados',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          if (_precificacaoSelecionada != null)
                            GestureDetector(
                              onTap: () {
                                setState(() => _precificacaoSelecionada = null);
                                _carregarApps(pagina: 1);
                              },
                              child: const Text(
                                'Limpar filtro',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFF28C28),
                                ),
                              ),
                            ),
                        ],
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
                              const SizedBox(height: 12),
                              FilledButton.tonal(
                                onPressed: () =>
                                    _carregarApps(pagina: _paginaAtual),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        )
                      else if (_apps.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 48,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Nenhum aplicativo encontrado',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
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
                          onPageChanged: (novaPagina) =>
                              _carregarApps(pagina: novaPagina),
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