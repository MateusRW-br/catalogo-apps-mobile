import 'package:flutter/material.dart';
import '../api/app_helper_api.dart';
import '../criar_review/criar_review.dart';
import '../model/app.dart';
import '../model/review.dart';
import '../widgets/butia_header.dart';

class DetalheAppPage extends StatefulWidget {
  final int appId;

  const DetalheAppPage({super.key, required this.appId});

  @override
  State<DetalheAppPage> createState() => _DetalheAppPageState();
}

class _DetalheAppPageState extends State<DetalheAppPage> {
  final AppHelperApi _appApi = AppHelperApi();
  AppModel? _app;
  List<Review> _reviews = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarDetalhes();
  }

  Future<void> _carregarDetalhes() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final detalhe = await _appApi.buscarAppPorId(widget.appId);
      final reviews = await _appApi.listarReviewsDoApp(widget.appId);
      if (!mounted) return;
      setState(() {
        _app = detalhe;
        _reviews = reviews;
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
    final appAtual = _app;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ButiaHeader(abaAtiva: 0),
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _erro != null || appAtual == null
                      ? Center(
                          child: Text(
                            _erro ?? 'Aplicativo não encontrado.',
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back),
                                  ),
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              appAtual.name,
                                              style: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const CircleAvatar(
                                              radius: 14,
                                              backgroundColor: Color(0xFFEEEEEE),
                                              child: Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          appAtual.developerName,
                                          style: const TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(appAtual.smallDescription),
                                        const SizedBox(height: 12),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFC9DF3B),
                                            foregroundColor: Colors.black87,
                                          ),
                                          child: const Text('Ir para o Website'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        appAtual.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${_reviews.length} avaliações',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade700,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          appAtual.pricing.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.shade200),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(appAtual.markdownDescription),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF28C28),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text(
                                      'Reviews',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CriarReviewPage(app: appAtual),
                                        ),
                                      );
                                      _carregarDetalhes();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3CE86B),
                                      foregroundColor: Colors.black87,
                                    ),
                                    child: const Text('+ Avaliar aplicativo'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              ..._reviews.map(
                                (rev) => Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              rev.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              rev.authorName,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(rev.markdownText),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: List.generate(5, (i) {
                                            return Icon(
                                              i < rev.rating.round()
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 16,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
}