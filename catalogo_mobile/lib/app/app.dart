import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/app_helper_api.dart';
import '../criar_review/criar_review.dart';
import '../dev/dev.dart';
import '../model/app.dart';
import '../model/review.dart';
import '../widgets/butia_header.dart';
import '../widgets/pagination_bar.dart';

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
  bool _carregandoReviews = false;
  String? _erro;
  int _paginaReviews = 1;
  int _totalPaginasReviews = 1;
  int _totalReviews = 0;

  static const int _limiteReviewsPorPagina = 10;

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
      final reviewsResp = await _appApi.listarReviewsDoApp(
        widget.appId,
        page: 1,
        limit: _limiteReviewsPorPagina,
      );
      if (!mounted) return;
      setState(() {
        _app = detalhe;
        _reviews = reviewsResp.data;
        _paginaReviews = reviewsResp.page;
        _totalPaginasReviews = reviewsResp.totalPages;
        _totalReviews = reviewsResp.total;
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

  Future<void> _carregarPaginaReviews(int novaPagina) async {
    setState(() {
      _carregandoReviews = true;
      _paginaReviews = novaPagina;
    });
    try {
      final reviewsResp = await _appApi.listarReviewsDoApp(
        widget.appId,
        page: novaPagina,
        limit: _limiteReviewsPorPagina,
      );
      if (!mounted) return;
      setState(() {
        _reviews = reviewsResp.data;
        _paginaReviews = reviewsResp.page;
        _totalPaginasReviews = reviewsResp.totalPages;
        _totalReviews = reviewsResp.total;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _carregandoReviews = false);
    }
  }

  Future<void> _abrirWebsite(String? link) async {
    final raw = link?.trim();
    if (raw == null || raw.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este aplicativo não possui um website cadastrado.'),
        ),
      );
      return;
    }

    final normalized =
        raw.startsWith('http://') || raw.startsWith('https://')
            ? raw
            : 'https://$raw';
    final uri = Uri.tryParse(normalized);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o link.'),
        ),
      );
    }
  }

  Color _corBadge(String pricing) {
    switch (pricing.toLowerCase()) {
      case 'paid':
        return Colors.red.shade600;
      case 'freemium':
        return const Color(0xFFF28C28);
      case 'foss':
        return Colors.teal.shade700;
      default:
        return const Color(0xFF1B8A3D);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appAtual = _app;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      bottomNavigationBar: const ButiaBottomNav(abaAtiva: 0),
      body: SafeArea(
        child: Column(
          children: [
            const ButiaHeader(abaAtiva: 0),
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _erro != null || appAtual == null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _erro ?? 'Aplicativo não encontrado.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RemoteIconAvatar(
                                            imageUrl: appAtual.icon,
                                            size: 80,
                                            borderRadius: 24,
                                            fallbackIcon: Icons.widgets_rounded,
                                            fallbackIconColor:
                                                const Color(0xFF1B8A3D),
                                            fallbackGradient: LinearGradient(
                                              colors: [
                                                const Color(0xFF3CE86B)
                                                    .withValues(alpha: 0.25),
                                                const Color(0xFFDCE043)
                                                    .withValues(alpha: 0.35),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  appAtual.name,
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: -0.4,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  onTap: appAtual.developerId > 0
                                                      ? () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  DetalheDevPage(
                                                                developerId:
                                                                    appAtual
                                                                        .developerId,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      : null,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 2,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            appAtual
                                                                .developerName,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                0xFF1B8A3D,
                                                              ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              decorationColor:
                                                                  Color(
                                                                0xFF1B8A3D,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .chevron_right_rounded,
                                                          size: 18,
                                                          color:
                                                              Color(0xFF1B8A3D),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _corBadge(
                                                      appAtual.pricing,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      12,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    appAtual.pricing
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        appAtual.smallDescription,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7FBF8),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  appAtual.rating
                                                      .toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: List.generate(
                                                        5,
                                                        (i) => Icon(
                                                          i <
                                                                  appAtual
                                                                      .rating
                                                                      .round()
                                                              ? Icons
                                                                  .star_rounded
                                                              : Icons
                                                                  .star_outline_rounded,
                                                          color: Colors.amber,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$_totalReviews avaliações',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            FilledButton.tonalIcon(
                                              onPressed: () =>
                                                  _abrirWebsite(appAtual.link),
                                              style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFFDCE043),
                                                foregroundColor:
                                                    const Color(0xFF1A1C19),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                              ),
                                              icon: const Icon(
                                                Icons.open_in_new_rounded,
                                                size: 16,
                                              ),
                                              label: const Text(
                                                'Website',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(color: Colors.grey.shade200),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Sobre o aplicativo',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        appAtual.markdownDescription,
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF28C28),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Reviews',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  FilledButton.icon(
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
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFF3CE86B),
                                      foregroundColor: const Color(0xFF0A2E14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text(
                                      'Avaliar app',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              if (_carregandoReviews)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (_reviews.isEmpty)
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    'Nenhuma avaliação encontrada.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              else ...[
                                ..._reviews.map(
                                  (rev) => Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      side: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
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
                                              Expanded(
                                                child: Text(
                                                  rev.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                rev.authorName,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            rev.markdownText,
                                            style: TextStyle(
                                              color: Colors.grey.shade800,
                                              height: 1.4,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: List.generate(5, (i) {
                                              return Icon(
                                                i < rev.rating.round()
                                                    ? Icons.star_rounded
                                                    : Icons.star_outline_rounded,
                                                color: Colors.amber,
                                                size: 18,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                PaginationBar(
                                  currentPage: _paginaReviews,
                                  totalPages: _totalPaginasReviews,
                                  onPageChanged: _carregarPaginaReviews,
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