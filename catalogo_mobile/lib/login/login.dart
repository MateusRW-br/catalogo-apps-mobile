import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/auth_helper_api.dart';
import '../widgets/butia_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authApi = AuthHelperApi();
  bool _ocultarSenha = true;
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _abrirCadastro() async {
    final uri = Uri.parse('http://localhost:3001/register');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir a página de cadastro.'),
        ),
      );
    }
  }

  Future<void> _entrar() async {
    if (_emailController.text.trim().isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe e-mail e senha.')),
      );
      return;
    }

    setState(() => _carregando = true);
    try {
      await _authApi.login(
        email: _emailController.text,
        password: _senhaController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Entrar na Conta',
          style: TextStyle(
            color: Color(0xFF1A1C19),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButiaLogo(size: 42),
                        SizedBox(width: 12),
                        Text(
                          'Butiápps',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'E-mail',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'nome@exemplo.com',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Senha',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _senhaController,
                      obscureText: _ocultarSenha,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _ocultarSenha
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                          ),
                          onPressed: () =>
                              setState(() => _ocultarSenha = !_ocultarSenha),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                        children: [
                          TextSpan(text: 'Ao confirmar você concordará com os '),
                          TextSpan(
                            text: 'Termos de Uso',
                            style: TextStyle(
                              color: Color(0xFFF28C28),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: ' e '),
                          TextSpan(
                            text: 'Política de Privacidade',
                            style: TextStyle(
                              color: Color(0xFFF28C28),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _carregando ? null : _entrar,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF3CE86B),
                          foregroundColor: const Color(0xFF0A2E14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: _carregando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não tem uma conta? '),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: _abrirCadastro,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Text(
                              'Cadastre-se',
                              style: TextStyle(
                                color: Color(0xFFF28C28),
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFF28C28),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}