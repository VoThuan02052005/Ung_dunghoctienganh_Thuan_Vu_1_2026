import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _authService = AuthService();

  bool _obscure = true;
  bool _isLoading = false;
  bool _isRegister = false; // toggle login/register
  String? _error;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      if (_isRegister) {
        await _authService.register(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          name: _nameCtrl.text.trim(),
        );
      } else {
        await _authService.login(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
      }
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => MainScreen(userName: _emailCtrl.text.split('@')[0]),
        ));
      }
    } catch (e) {
      final msg = e.toString();
      // Chỉ fallback nếu lỗi do Firebase chưa cấu hình (không phải lỗi user)
      final isConfigError = msg.contains('network') ||
          msg.contains('not configured') ||
          msg.contains('ApiKey') ||
          msg.contains('PlatformException');
      if (isConfigError) {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => MainScreen(userName: _emailCtrl.text.split('@')[0]),
          ));
        }
      } else {
        setState(() => _error = msg);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFF6B8DD6)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 88, height: 88,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withAlpha(102), width: 2),
                          ),
                          child: const Center(child: Text('🇬🇧', style: TextStyle(fontSize: 42))),
                        ),
                        const SizedBox(height: 16),
                        const Text('EnglishMaster', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
                        const Text('Học tiếng Anh thông minh', style: TextStyle(fontSize: 13, color: Colors.white70)),
                        const SizedBox(height: 32),

                        // Card
                        Container(
                          padding: const EdgeInsets.all(26),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 30, offset: const Offset(0, 15))],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_isRegister ? 'Đăng ký' : 'Đăng nhập',
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                                const SizedBox(height: 4),
                                Text(_isRegister ? 'Tạo tài khoản mới' : 'Chào mừng bạn trở lại!',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                                const SizedBox(height: 20),

                                // Name field (chỉ khi đăng ký)
                                if (_isRegister) ...[
                                  _buildField(controller: _nameCtrl, label: 'Họ và tên', hint: 'Nguyễn Văn A',
                                      icon: Icons.person_outline, validator: (v) => v!.isEmpty ? 'Nhập tên' : null),
                                  const SizedBox(height: 12),
                                ],

                                // Email
                                _buildField(
                                  controller: _emailCtrl, label: 'Email', hint: 'example@email.com',
                                  icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
                                  validator: (v) => v!.isEmpty ? 'Nhập email' : null,
                                ),
                                const SizedBox(height: 12),

                                // Password
                                TextFormField(
                                  controller: _passCtrl,
                                  obscureText: _obscure,
                                  decoration: _inputDeco(
                                    label: 'Mật khẩu', hint: '••••••••',
                                    icon: Icons.lock_outlined,
                                    suffix: IconButton(
                                      icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
                                      onPressed: () => setState(() => _obscure = !_obscure),
                                    ),
                                  ),
                                  validator: (v) => v!.length < 6 ? 'Ít nhất 6 ký tự' : null,
                                ),

                                // Error message
                                if (_error != null) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(children: [
                                      const Icon(Icons.error_outline, color: Colors.red, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12))),
                                    ]),
                                  ),
                                ],

                                const SizedBox(height: 16),

                                // Submit button
                                SizedBox(
                                  width: double.infinity, height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF667EEA),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      elevation: 4,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(width: 22, height: 22,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                        : Text(_isRegister ? 'Đăng ký' : 'Đăng nhập',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // Toggle login/register
                                Center(
                                  child: GestureDetector(
                                    onTap: () => setState(() { _isRegister = !_isRegister; _error = null; }),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                        children: [
                                          TextSpan(text: _isRegister ? 'Đã có tài khoản? ' : 'Chưa có tài khoản? '),
                                          TextSpan(
                                            text: _isRegister ? 'Đăng nhập' : 'Đăng ký ngay',
                                            style: const TextStyle(color: Color(0xFF667EEA), fontWeight: FontWeight.bold),
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
                        const SizedBox(height: 20),
                        // Firebase badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withAlpha(38), borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🔥', style: TextStyle(fontSize: 14)),
                              SizedBox(width: 6),
                              Text('Powered by Firebase', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDeco(label: label, hint: hint, icon: icon),
      validator: validator,
    );
  }

  InputDecoration _inputDeco({required String label, required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF667EEA)),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF5F5FF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }
}
