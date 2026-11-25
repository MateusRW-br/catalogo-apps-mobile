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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ButiaHeader(abaAtiva: 0),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back),
                            ),
                            Expanded(
                              child: Center(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: Colors.black87,
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
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Avaliando: ${widget.app.name}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 460),
                              child: TextField(
                                controller: _tituloController,
                                decoration: InputDecoration(
                                  hintText: 'Título da review',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (index) {
                                  final estrela = index + 1;
                                  return GestureDetector(
                                    onTap: () => setState(
                                      () => _notaSelecionada = estrela,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      child: Icon(
                                        estrela <= _notaSelecionada
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 24,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Card(
                          color: Colors.white,
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: _comentarioController,
                              maxLines: 8,
                              decoration: const InputDecoration(
                                hintText:
                                    'Digite sua avaliação sobre o aplicativo aqui.',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 150,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: _enviando ? null : _criarReview,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3CE86B),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: _enviando
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'CRIAR',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
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