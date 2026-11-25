import 'package:flutter/material.dart';
import '../api/app_helper_api.dart';
import '../model/app.dart';
import '../model/developer.dart';
import '../widgets/butia_header.dart';
import '../widgets/card_app.dart';

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
  String? _erro;

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
      final appsDev = await _appApi.listarApps(
        developerId: widget.developerId,
        page: 1,
        limit: 50,
      );
      if (!mounted) return;
      setState(() {
        _developer = dev;
        _apps = appsDev;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final devAtual = _developer;

    return Scaffold(
      backgroundColor: Colors.white,
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
                                    devAtual.name,
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
            ),
          ],
        ),
      ),
    );
  }
}