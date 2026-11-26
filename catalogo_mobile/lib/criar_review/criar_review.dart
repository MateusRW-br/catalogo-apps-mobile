import 'package:flutter/material.dart';
import '../api/app_helper_api.dart';
import '../model/app.dart';
import '../widgets/butia_header.dart';

class CriarReviewPage extends StatefulWidget {
  final AppModel app;

  const CriarReviewPage({super.key, required this.app});

  @override
  State<CriarReviewPage> createState() => _CriarReviewPageState();
}

class _CriarReviewPageState extends State<CriarReviewPage> {
  final _tituloController = TextEditingController();
  final _comentarioController = TextEditingController();
  final _appApi = AppHelperApi();
  int _notaSelecionada = 5;
  bool _enviando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _criarReview() async {
    final titulo = _tituloController.text.trim();
    final comentario = _comentarioController.text.trim();

    if (titulo.isEmpty || comentario.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o título e o comentário da review.'),
        ),
      );
      return;
    }

    setState(() => _enviando = true);
    try {
      await _appApi.criarReview(
        appId: widget.app.id,
        name: titulo,
        markdownText: comentario,
        rating: _notaSelecionada.toDouble(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review enviada com sucesso!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: Color(0xFF1A1C19),
                              ),
                              children: [
                                TextSpan(text: 'Criar '),
                                TextSpan(
                                  text: 'Review',
                                  style: TextStyle(
                                    color: Color(0xFFF28C28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        'Avaliando: ${widget.app.name}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _tituloController,
                      decoration: const InputDecoration(
                        hintText: 'Título da sua avaliação',
                        prefixIcon: Icon(Icons.title_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF3CE86B),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sua nota:',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              final estrela = index + 1;
                              return GestureDetector(
                                onTap: () => setState(
                                  () => _notaSelecionada = estrela,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: Icon(
                                    estrela <= _notaSelecionada
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    color: Colors.amber,
                                    size: 28,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: const BorderSide(
                          color: Color(0xFF3CE86B),
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _comentarioController,
                          maxLines: 7,
                          decoration: const InputDecoration(
                            hintText:
                                'Digite sua avaliação sobre o aplicativo aqui...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _enviando ? null : _criarReview,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF3CE86B),
                          foregroundColor: const Color(0xFF0A2E14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        icon: _enviando
                            ? const SizedBox.shrink()
                            : const Icon(Icons.send_rounded),
                        label: _enviando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'PUBLICAR REVIEW',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
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