import 'package:flutter/material.dart';
import '../api/app_helper_api.dart';
import '../model/app.dart';
import '../widgets/butia_header.dart';
import '../widgets/card_app.dart';

class PesquisarAppsPage extends StatefulWidget {
  const PesquisarAppsPage({super.key});

  @override
  State<PesquisarAppsPage> createState() => _PesquisarAppsPageState();
}

class _PesquisarAppsPageState extends State<PesquisarAppsPage> {
  final TextEditingController _buscaController = TextEditingController();
  final AppHelperApi _appApi = AppHelperApi();
  final Set<String> _categoriasSelecionadas = {};
  final Set<String> _precificacoesSelecionadas = {};
  bool _ordenarPorRatingDesc = true;
  bool _carregando = true;
  String? _erro;
  List<AppModel> _apps = [];

  static const List<String> _categorias = [
    'Navegador',
    'Editor de Texto',
    'IDE',
    'Emulador de Terminal',
    'Processador de Texto',
    'Planilhas',
    'Office Suite',
    'Outros',
  ];

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

  Future<void> _carregarApps() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final categoriaParam = _categoriasSelecionadas.length == 1
          ? _categoriasSelecionadas.first
          : null;
      final pricingParam = _precificacoesSelecionadas.length == 1
          ? _precificacoesSelecionadas.first
          : null;

      final resultado = await _appApi.listarApps(
        search: _buscaController.text,
        category: categoriaParam,
        pricing: pricingParam,
        order: _ordenarPorRatingDesc ? 'desc' : 'asc',
      );

      final filtrados = resultado.where((app) {
        final bateCat = _categoriasSelecionadas.isEmpty ||
            _categoriasSelecionadas.contains(app.category);
        final batePreco = _precificacoesSelecionadas.isEmpty ||
            _precificacoesSelecionadas.contains(app.pricing.toLowerCase());
        return bateCat && batePreco;
      }).toList();

      if (!mounted) return;
      setState(() {
        _apps = filtrados;
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ButiaHeader(abaAtiva: 0),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 32, color: Colors.black87),
                        children: [
                          TextSpan(text: 'Pesquisar '),
                          TextSpan(
                            text: 'Aplicativos',
                            style: TextStyle(color: Color(0xFFF28C28)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 360,
                          child: TextField(
                            controller: _buscaController,
                            onChanged: (_) => _carregarApps(),
                            decoration: InputDecoration(
                              hintText: 'Pesquisa...',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: _carregarApps,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(
                                  color: Color(0xFF3CE86B),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _ordenarPorRatingDesc = !_ordenarPorRatingDesc;
                            });
                            _carregarApps();
                          },
                          icon: Icon(
                            _ordenarPorRatingDesc
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            size: 16,
                          ),
                          label: const Text('Ordenar (Nota)'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 210,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3CE86B),
                                  foregroundColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('+ Cadastrar App'),
                              ),
                              const SizedBox(height: 16),
                              _caixaFiltro(
                                titulo: 'Categorias',
                                itens: _categorias
                                    .map((c) => MapEntry(c, c))
                                    .toList(),
                                selecionados: _categoriasSelecionadas,
                              ),
                              const SizedBox(height: 16),
                              _caixaFiltro(
                                titulo: 'Precificação',
                                itens: _precificacoesFiltro.entries.toList(),
                                selecionados: _precificacoesSelecionadas,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total encontrado: ${_apps.length} aplicativos'),
                              const SizedBox(height: 14),
                              if (_carregando)
                                const Center(child: CircularProgressIndicator())
                              else if (_erro != null)
                                Text(
                                  _erro!,
                                  style: const TextStyle(color: Colors.red),
                                )
                              else
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _apps.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    mainAxisExtent: 270,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemBuilder: (_, i) => CardApp(app: _apps[i]),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _caixaFiltro({
    required String titulo,
    required List<MapEntry<String, String>> itens,
    required Set<String> selecionados,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ...itens.map((entry) {
            final ativo = selecionados.contains(entry.value);
            return CheckboxListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              value: ativo,
              title: Text(entry.key, style: const TextStyle(fontSize: 13)),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    selecionados.add(entry.value);
                  } else {
                    selecionados.remove(entry.value);
                  }
                });
                _carregarApps();
              },
            );
          }),
        ],
      ),
    );
  }
}