import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/constants.dart';

/// Login screen — email / mobile mock login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'user@matrimony.com');
  final _passwordController = TextEditingController(text: 'password');
  bool _obscure = true;
  bool _usePhone = false;
  UserRole? _selectedRole;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final role = ModalRoute.of(context)?.settings.arguments as UserRole?;
    if (role != null && _selectedRole == null) {
      _selectedRole = role;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushNamed(
        '/otp',
        arguments: _selectedRole ?? UserRole.user,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Attractive header with collage concept
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4CAF50),
                    const Color(0xFFFF9800),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Decorative photo grid pattern (simulating couple collage)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CollagePatternPainter(),
                    ),
                  ),
                  
                  // Curved white bottom overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  
                  // Logo and branding centered
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Color(0xFFFF9800),
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'APMatrimony',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'The biggest and most trusted\nmatrimony service for AP!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Login form section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          _selectedRole != null
                              ? 'Login as ${_selectedRole!.label}'
                              : 'Sign in to continue',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Toggle email / phone
                        Row(
                          children: [
                            Expanded(
                              child: _TabButton(
                                label: 'Email',
                                isSelected: !_usePhone,
                                onTap: () => setState(() => _usePhone = false),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TabButton(
                                label: 'Mobile',
                                isSelected: _usePhone,
                                onTap: () => setState(() => _usePhone = true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: _usePhone
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: _usePhone ? 'Mobile Number' : 'Email Address',
                            prefixIcon: Icon(
                              _usePhone ? Icons.phone : Icons.email_outlined,
                            ),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'This field is required' : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter password' : null,
                        ),
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/forgot-password'),
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            child: const Text('Login', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed('/register'),
                              child: const Text('Register'),
                            ),
                          ],
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

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Custom painter to create an attractive photo collage pattern in the header
class _CollagePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a pattern of rectangles to simulate a photo collage
    final paint = Paint()..style = PaintingStyle.stroke;
    
    // Draw multiple overlapping rectangles with semi-transparent white borders
    // to create the effect of a photo collage
    final rects = [
      Rect.fromLTWH(20, 30, 80, 100),
      Rect.fromLTWH(110, 20, 90, 110),
      Rect.fromLTWH(210, 40, 85, 95),
      Rect.fromLTWH(size.width - 120, 25, 95, 105),
      Rect.fromLTWH(30, 150, 75, 90),
      Rect.fromLTWH(115, 145, 80, 95),
      Rect.fromLTWH(205, 155, 88, 85),
      Rect.fromLTWH(size.width - 110, 150, 85, 90),
    ];
    
    paint.color = Colors.white.withValues(alpha: 0.15);
    paint.strokeWidth = 2;
    
    for (final rect in rects) {
      // Draw rectangle border
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        paint,
      );
      
      // Add some inner details to simulate photos
      final innerPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.deflate(4),
          const Radius.circular(6),
        ),
        innerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
