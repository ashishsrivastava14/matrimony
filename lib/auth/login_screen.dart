import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../providers/language_provider.dart';

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

  void _showLanguageBottomSheet(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLocale = languageProvider.locale.languageCode;
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.selectLanguage,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...LanguageProvider.getSupportedLanguages().map((lang) {
                final isSelected = currentLocale == lang['code'];
                return InkWell(
                  onTap: () {
                    languageProvider.changeLanguage(lang['code']!);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00897B).withValues(alpha: 0.1) : null,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? const Color(0xFF00897B) : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang['nativeName']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: isSelected ? const Color(0xFF00897B) : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                lang['name']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF00897B),
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isCompact = screenHeight < 700;
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Attractive header with modern gradient
                      Container(
                        height: isCompact ? 160 : 180,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF00897B),
                              Color(0xFF26A69A),
                              Color(0xFF00796B),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Decorative pattern
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
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5F7FA),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Logo and branding
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: isCompact ? 16 : 20),
                                  Container(
                                    width: isCompact ? 70 : 80,
                                    height: isCompact ? 70 : 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 16,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: const Color(0xFF00897B),
                                      size: isCompact ? 36 : 40,
                                    ),
                                  ),
                                  SizedBox(height: isCompact ? 10 : 12),
                                  Text(
                                    l10n.appTitle,
                                    style: TextStyle(
                                      fontSize: isCompact ? 28 : 32,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome,
                                        size: 11,
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        l10n.poweredBy,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white.withValues(alpha: 0.9),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Login form section with card design
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 420),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(isCompact ? 20 : 24),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Welcome text
                                      Text(
                                        _selectedRole != null
                                            ? l10n.loginAs(_selectedRole!.getLabel(context))
                                            : l10n.welcomeBack,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: isCompact ? 20 : 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.signInToContinue,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: isCompact ? 16 : 20),

                                      // Language selector
                                      InkWell(
                                        onTap: () => _showLanguageBottomSheet(context),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8F9FA),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.language,
                                                color: Color(0xFF00897B),
                                                size: 22,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  LanguageProvider.getLanguageName(languageProvider.locale.languageCode),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey.shade600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: isCompact ? 16 : 20),

                                      // Toggle email / phone with modern design
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F7FA),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(3),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: _TabButton(
                                                label: l10n.email,
                                                isSelected: !_usePhone,
                                                onTap: () => setState(() => _usePhone = false),
                                              ),
                                            ),
                                            Expanded(
                                              child: _TabButton(
                                                label: l10n.mobile,
                                                isSelected: _usePhone,
                                                onTap: () => setState(() => _usePhone = true),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: isCompact ? 16 : 20),

                                      // Input field
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType: _usePhone
                                            ? TextInputType.phone
                                            : TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: _usePhone ? l10n.mobileNumber : l10n.emailAddress,
                                          hintText: _usePhone ? l10n.enterMobile : l10n.enterEmail,
                                          prefixIcon: Icon(
                                            _usePhone ? Icons.phone_android_rounded : Icons.email_outlined,
                                            color: const Color(0xFF00897B),
                                            size: 22,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: isCompact ? 14 : 16,
                                            horizontal: 16,
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFF8F9FA),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF00897B),
                                              width: 2,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        validator: (v) =>
                                            v == null || v.isEmpty ? l10n.required : null,
                                      ),
                                      SizedBox(height: isCompact ? 14 : 16),

                                      // Password field
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscure,
                                        decoration: InputDecoration(
                                          labelText: l10n.password,
                                          hintText: l10n.enterPassword,
                                          prefixIcon: const Icon(
                                            Icons.lock_outline_rounded,
                                            color: Color(0xFF00897B),
                                            size: 22,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                              color: AppColors.textSecondary,
                                              size: 20,
                                            ),
                                            onPressed: () => setState(() => _obscure = !_obscure),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: isCompact ? 14 : 16,
                                            horizontal: 16,
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFF8F9FA),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF00897B),
                                              width: 2,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        validator: (v) =>
                                            v == null || v.isEmpty ? l10n.required : null,
                                      ),

                                      // Forgot password
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pushNamed('/forgot-password'),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            l10n.forgotPassword,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: isCompact ? 16 : 20),

                                      // Login button with gradient
                                      SizedBox(
                                        height: isCompact ? 50 : 54,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF00897B),
                                                Color(0xFF26A69A),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF00897B).withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: _handleLogin,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              foregroundColor: Colors.white,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              l10n.login,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: isCompact ? 16 : 20),

                                      // Divider
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: Colors.grey.shade300,
                                              thickness: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            child: Text(
                                              l10n.or,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: Colors.grey.shade300,
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: isCompact ? 12 : 16),

                                      // Register link
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.dontHaveAccount,
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 13,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pushNamed('/register'),
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            child: Text(
                                              l10n.register,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
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
    // Create a modern pattern with circles and rectangles
    final paint = Paint()..style = PaintingStyle.stroke;
    
    // Draw hearts and circles pattern
    paint.color = Colors.white.withValues(alpha: 0.12);
    paint.strokeWidth = 2.5;
    
    // Scattered hearts
    final heartPositions = [
      Offset(size.width * 0.15, 40),
      Offset(size.width * 0.85, 50),
      Offset(size.width * 0.25, 140),
      Offset(size.width * 0.75, 130),
    ];
    
    for (final pos in heartPositions) {
      _drawHeart(canvas, pos, 20, paint);
    }
    
    // Decorative circles
    final circlePositions = [
      (Offset(size.width * 0.1, 80), 25.0),
      (Offset(size.width * 0.9, 90), 30.0),
      (Offset(size.width * 0.2, 170), 20.0),
      (Offset(size.width * 0.8, 165), 25.0),
    ];
    
    paint.color = Colors.white.withValues(alpha: 0.1);
    paint.strokeWidth = 2;
    
    for (final (pos, radius) in circlePositions) {
      canvas.drawCircle(pos, radius, paint);
    }
    
    // Filled decorative elements
    final fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    
    // Small filled circles
    canvas.drawCircle(Offset(size.width * 0.12, 120), 8, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.88, 110), 6, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.18, 60), 7, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.82, 70), 9, fillPaint);
  }
  
  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    
    path.moveTo(center.dx, center.dy + size * 0.3);
    
    path.cubicTo(
      center.dx - size * 0.6, center.dy - size * 0.2,
      center.dx - size * 0.6, center.dy - size * 0.8,
      center.dx, center.dy - size * 0.4,
    );
    
    path.cubicTo(
      center.dx + size * 0.6, center.dy - size * 0.8,
      center.dx + size * 0.6, center.dy - size * 0.2,
      center.dx, center.dy + size * 0.3,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
