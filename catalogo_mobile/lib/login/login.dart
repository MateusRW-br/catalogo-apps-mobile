import 'package:flutter/material.dart';
import '../api/auth_helper_api.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFDCE043),
                        ),
                        SizedBox(width: 10),
                        Text('Butiáapps', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('E-mail:'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'nome@exemplo.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('Senha:'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _senhaController,
                      obscureText: _ocultarSenha,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _ocultarSenha
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () =>
                              setState(() => _ocultarSenha = !_ocultarSenha),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                        children: [
                          TextSpan(text: 'Ao confirmar você concordará com os '),
                          TextSpan(
                            text: 'Termos de Uso',
                            style: TextStyle(color: Color(0xFFF28C28)),
                          ),
                          TextSpan(text: ' e '),
                          TextSpan(
                            text: 'Política de Privacidade',
                            style: TextStyle(color: Color(0xFFF28C28)),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _entrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3CE86B),
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: _carregando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Não tem uma conta? '),
                        Text(
                          'Cadastrar-se',
                          style: TextStyle(color: Color(0xFFF28C28)),
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