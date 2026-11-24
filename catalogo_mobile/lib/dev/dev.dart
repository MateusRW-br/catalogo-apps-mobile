import 'package:flutter/material.dart';
import '../model/app.dart';
import '../model/developer.dart';
import '../widgets/butia_header.dart';
import '../widgets/card_app.dart';

class DetalheDevPage extends StatelessWidget {
  final Developer dev;

  const DetalheDevPage({super.key, required this.dev});

  static final List<AppModel> _appsFicticios = [
    AppModel(
      id: 1,
      name: 'Nome do Aplicativo',
      icon: null,
      link: 'https://exemplo.com',
      smallDescription: 'Descrição curta sobre o aplicativo em questão',
      markdownDescription: 'Descrição completa do aplicativo.',
      rating: 4.5,
      category: 'Navegador',
      pricing: 'free',
      developerId: 1,
      developerName: 'Dev Name',
      reviewsCount: 25,
    ),
    AppModel(
      id: 2,
      name: 'Nome do Aplicativo',
      icon: null,
      link: 'https://exemplo.com',
      smallDescription: 'Descrição curta sobre o aplicativo em questão',
      markdownDescription: 'Descrição completa do aplicativo.',
      rating: 4.5,
      category: 'IDE',
      pricing: 'free',
      developerId: 1,
      developerName: 'Dev Name',
      reviewsCount: 10,
    ),
    AppModel(
      id: 3,
      name: 'Nome do Aplicativo',
      icon: null,
      link: 'https://exemplo.com',
      smallDescription: 'Descrição curta sobre o aplicativo em questão',
      markdownDescription: 'Descrição completa do aplicativo.',
      rating: 4.5,
      category: 'Editor de Texto',
      pricing: 'free',
      developerId: 1,
      developerName: 'Dev Name',
      reviewsCount: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appsDoDev =
        _appsFicticios.where((app) => app.developerId == dev.id).toList();
    final listaExibicao = appsDoDev.isNotEmpty ? appsDoDev : _appsFicticios;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ButiaHeader(abaAtiva: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          dev.name,
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
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF28C28),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Apps',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listaExibicao.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisExtent: 270,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (_, i) => CardApp(app: listaExibicao[i]),
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