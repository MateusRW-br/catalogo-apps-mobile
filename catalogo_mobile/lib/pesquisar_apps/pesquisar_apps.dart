import 'package:flutter/material.dart';
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
  final Set<String> _categoriasSelecionadas = {};
  final Set<String> _precificacoesSelecionadas = {};
  bool _ordenarPorRatingDesc = true;

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

  static final List<AppModel> _appsFicticios = [
    AppModel(
      id: 1,
      name: 'Nome do Aplicativo',
      icon: null,
      link: 'https://exemplo.com',
      smallDescription: 'Descrição curta sobre o aplicativo',
      markdownDescription:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam rhoncus, quam sit amet mollis bibendum, nibh nunc vehicula massa, vel molestie ante risus nec nulla.\n\nFusce quis dui ac purus tincidunt fermentum. Sed fringilla finibus erat non placerat.',
      rating: 4.5,
      category: 'Navegador',
      pricing: 'free',
      developerId: 1,
      developerName: 'Desenvolvedor',
      reviewsCount: 25,
    ),
    AppModel(
      id: 2,
      name: 'Nome do Aplicativo 6',
      icon: null,
      link: 'https://exemplo.com',
      smallDescription: 'Descrição curta sobre o aplicativo',
      markdownDescription:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam rhoncus, quam sit amet mollis bibendum, nibh nunc vehicula massa.',
      rating: 4.5,
      category: 'IDE',
      pricing: 'paid',
      developerId: 2,
      developerName: 'Desenvolvedor',
      reviewsCount: 14,
    ),
    AppModel(
      id: 3,
      name: 'Nome do Aplicativo 11',
      icon: null,
      link: 'https://exemplo.com',
      smallDescription: 'Descrição curta sobre o aplicativo',
      markdownDescription:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam rhoncus, quam sit amet mollis bibendum, nibh nunc vehicula massa.',
      rating: 4.5,
      category: 'Editor de Texto',
      pricing: 'freemium',
      developerId: 3,
      developerName: 'Desenvolvedor',
      reviewsCount: 9,
    ),
  ];

  List<AppModel> get _appsFiltrados {
    final termo = _buscaController.text.trim().toLowerCase();
    final lista = _appsFicticios.where((app) {
      final bateBusca = termo.isEmpty ||
          app.name.toLowerCase().contains(termo) ||
          app.developerName.toLowerCase().contains(termo);
      final bateCategoria = _categoriasSelecionadas.isEmpty ||
          _categoriasSelecionadas.contains(app.category);
      final batePreco = _precificacoesSelecionadas.isEmpty ||
          _precificacoesSelecionadas.contains(app.pricing.toLowerCase());
      return bateBusca && bateCategoria && batePreco;
    }).toList();

    lista.sort((a, b) => _ordenarPorRatingDesc
        ? b.rating.compareTo(a.rating)
        : a.rating.compareTo(b.rating));
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    final apps = _appsFiltrados;

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
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Pesquisa...',
                              suffixIcon: const Icon(Icons.arrow_forward),
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
                          onPressed: () => setState(
                            () => _ordenarPorRatingDesc = !_ordenarPorRatingDesc,
                          ),
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
                              Text('Total encontrado: ${apps.length} aplicativos'),
                              const SizedBox(height: 14),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: apps.length,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300,
                                  mainAxisExtent: 270,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemBuilder: (_, i) => CardApp(app: apps[i]),
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
              },
            );
          }),
        ],
      ),
    );
  }
}