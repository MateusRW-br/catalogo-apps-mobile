import 'package:flutter/material.dart';
import '../dev/dev.dart';
import '../model/developer.dart';
import '../widgets/butia_header.dart';

class PesquisarDevsPage extends StatefulWidget {
  const PesquisarDevsPage({super.key});

  @override
  State<PesquisarDevsPage> createState() => _PesquisarDevsPageState();
}

class _PesquisarDevsPageState extends State<PesquisarDevsPage> {
  final TextEditingController _buscaController = TextEditingController();

  static final List<Developer> _devsFicticios = [
    Developer(id: 1, name: 'Nome do Desenvolvedor', appsCount: 5),
    Developer(id: 2, name: 'Nome do Desenvolvedor', appsCount: 2),
    Developer(id: 3, name: 'Nome do Desenvolvedor', appsCount: 5),
    Developer(id: 4, name: 'Nome do Desenvolvedor', appsCount: 5),
    Developer(id: 5, name: 'Nome do Desenvolvedor', appsCount: 5),
    Developer(id: 6, name: 'Nome do Desenvolvedor', appsCount: 5),
  ];

  @override
  Widget build(BuildContext context) {
    final termo = _buscaController.text.trim().toLowerCase();
    final devs = _devsFicticios
        .where((d) => termo.isEmpty || d.name.toLowerCase().contains(termo))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ButiaHeader(abaAtiva: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 120,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 32, color: Colors.black87),
                        children: [
                          TextSpan(text: 'Pesquisar '),
                          TextSpan(
                            text: 'Desenvolvedores',
                            style: TextStyle(color: Color(0xFFF28C28)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Total encontrado: ${devs.length} desenvolvedores'),
                    ),
                    const SizedBox(height: 12),
                    ...devs.map(
                      (dev) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetalheDevPage(dev: dev),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Text(
                                      dev.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${dev.appsCount} apps',
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
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