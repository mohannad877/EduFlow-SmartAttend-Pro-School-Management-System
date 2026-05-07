import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/services/backup_service.dart';
import 'package:school_schedule_app/core/providers/notifications_provider.dart';

class SplashScreenPage extends ConsumerStatefulWidget {
  const SplashScreenPage({super.key});

  @override
  ConsumerState<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends ConsumerState<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _navigate();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    // مدة أطول قليلاً للاستمتاع بالتأثيرات
    await Future.delayed(const Duration(milliseconds: 4200));
    if (!mounted) return;

    // Run Auto Backup check silently in background
    var didBackup = await BackupService.checkAndRunAutoBackup();
    if (didBackup) {
      final notifSettings = ref.read(notificationSettingsProvider);
      if (notifSettings.enableAll && notifSettings.backupAlerts) {
        ref.read(notificationsProvider.notifier).addNotification(
          context.l10n.backupTitle,
          context.l10n.backupComplete,
          'backup',
        );
      }
    }

    final authState = ref.read(authStateProvider);
    if (authState.isAuthenticated) {
      AppNavigator.pushAndRemoveAll(AppRoutes.home);
    } else {
      AppNavigator.pushAndRemoveAll(AppRoutes.home); // dev
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. خلفية متدرجة متحركة (Animated Gradient)
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              final value = _gradientController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      Color.lerp(AppColors.primary, AppColors.primary.withBlue(200), value)!,
                      Color.lerp(AppColors.primary.withBlue(100), AppColors.primary.withRed(120), value)!,
                      Color.lerp(AppColors.primary.withGreen(80), AppColors.primary.withOpacity(0.9), value)!,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              );
            },
          ),

          // 2. دوائر ضوئية متحركة في الخلفية (Orbs)
          ..._buildAnimatedOrbs(),

          // 3. جسيمات خلفية (Particles) متحركة
          _buildParticleSystem(),

          // 4. تأثير الشبكة الهندسية (Grid)
          _buildGeometricGrid(),

          // 5. المحتوى الرئيسي (بزجاج فاخر)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // شعار بتأثير زجاجي فاخر + وميض
                _buildLuxuryLogo()
                    .animate()
                    .scale(
                      duration: 1000.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 800.ms)
                    .shimmer(
                      delay: 1500.ms,
                      duration: 2000.ms,
                      color: Colors.white70,
                      blendMode: BlendMode.srcOver,
                    ),

                const SizedBox(height: 32),

                // اسم التطبيق مع تأثير الكتابة المتتابعة
                _buildAnimatedAppName(),

                const SizedBox(height: 16),

                // النص الوصفي مع تأثير التلاشي
                _buildSubtitle(),

                const SizedBox(height: 60),

                // مؤشر تحميل دائري فاخر
                _buildPremiumLoader(),

                const SizedBox(height: 24),

                // نص متحرك أسفل المؤشر
                _buildLoadingStatus(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 1. دوائر ضوئية متحركة (Orbs)
  // --------------------------------------------------------------------------
  List<Widget> _buildAnimatedOrbs() {
    return [
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 2 * pi),
        duration: const Duration(seconds: 20),
        builder: (context, angle, child) {
          return Positioned(
            top: 100 + sin(angle) * 40,
            left: -50 + cos(angle * 0.7) * 30,
            child: _buildDecorativeCircle(250, Colors.white.withOpacity(0.03)),
          );
        },
      ),
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 2 * pi),
        duration: const Duration(seconds: 25),
        builder: (context, angle, child) {
          return Positioned(
            bottom: 80 + sin(angle * 1.3) * 50,
            right: -30 + cos(angle) * 40,
            child: _buildDecorativeCircle(320, Colors.black.withOpacity(0.08)),
          );
        },
      ),
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 2 * pi),
        duration: const Duration(seconds: 18),
        builder: (context, angle, child) {
          return Positioned(
            top: 300 + cos(angle * 1.8) * 60,
            right: 50 + sin(angle) * 40,
            child: _buildDecorativeCircle(180, Colors.white.withOpacity(0.04)),
          );
        },
      ),
    ];
  }

  Widget _buildDecorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 2. نظام جسيمات خلفية (Particles)
  // --------------------------------------------------------------------------
  Widget _buildParticleSystem() {
    return CustomPaint(
      painter: ParticlePainter(_random),
      size: Size.infinite,
    );
  }

  // --------------------------------------------------------------------------
  // 3. شبكة هندسية متحركة (Grid)
  // --------------------------------------------------------------------------
  Widget _buildGeometricGrid() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return CustomPaint(
            painter: GridPainter(_gradientController.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 4. شعار فاخر (زجاج + إطار نيون + توهج)
  // --------------------------------------------------------------------------
  Widget _buildLuxuryLogo() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.05),
                ],
                stops: const [0.0, 1.0],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2.5,
              ),
            ),
            child: const Icon(
              Icons.school_rounded,
              size: 100,
              color: Colors.white,
            ).animate().shimmer(duration: 2500.ms, color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 5. اسم التطبيق بحركة كتابة متتابعة
  // --------------------------------------------------------------------------
  Widget _buildAnimatedAppName() {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 600), delay: Duration(milliseconds: 400)),
        SlideEffect(begin: Offset(0, 0.3), end: Offset.zero, duration: Duration(milliseconds: 800), curve: Curves.easeOutQuad),
      ],
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.white, Colors.white70],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ).createShader(bounds),
        child: Text(
          context.l10n.appName,
          style: AppTextStyles.headline2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            shadows: [
              Shadow(blurRadius: 12, color: Colors.black26, offset: const Offset(2, 2)),
            ],
          ),
        maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
    );
  }

  // --------------------------------------------------------------------------
  // 6. النص الفرعي مع تأثير التلاشي
  // --------------------------------------------------------------------------
  Widget _buildSubtitle() {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 800), delay: Duration(milliseconds: 900)),
        ScaleEffect(begin: Offset(0.9, 0.9), end: Offset(1.0, 1.0), duration: Duration(milliseconds: 600)),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Text(
          context.l10n.studentDeleted,
          style: AppTextStyles.body1.copyWith(
            color: Colors.white.withOpacity(0.9),
            letterSpacing: 1.2,
          ),
        maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 7. مؤشر تحميل دائري فاخر (Premium Loader)
  // --------------------------------------------------------------------------
  Widget _buildPremiumLoader() {
    return Animate(
      effects: const [FadeEffect(duration: Duration(milliseconds: 500), delay: Duration(milliseconds: 1200))],
      child: SizedBox(
        width: 80,
        height: 80,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 2 * pi),
          duration: const Duration(seconds: 2),
          builder: (context, angle, child) {
            return Transform.rotate(
              angle: angle,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 8. نص الحالة المتحرك
  // --------------------------------------------------------------------------
  Widget _buildLoadingStatus() {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 800), delay: Duration(milliseconds: 1500)),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_empty, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            context.l10n.selectGradeStudent,
            style: AppTextStyles.caption.copyWith(color: Colors.white70),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// CustomPainter للجسيمات (Particles)
// --------------------------------------------------------------------------
class ParticlePainter extends CustomPainter {
  final Random random;
  late List<_Particle> particles;

  ParticlePainter(this.random) {
    particles = List.generate(40, (index) {
      return _Particle(
        position: Offset(random.nextDouble() * 500, random.nextDouble() * 1000),
        velocity: Offset(random.nextDouble() * 0.5 - 0.25, random.nextDouble() * 0.5 - 0.25),
        radius: random.nextDouble() * 2 + 1,
        color: Colors.white.withOpacity(random.nextDouble() * 0.2),
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()..color = p.color;
      canvas.drawCircle(p.position, p.radius, paint);
      // تحريك الجسيمات
      p.position += p.velocity;
      if (p.position.dx < 0 || p.position.dx > size.width) p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
      if (p.position.dy < 0 || p.position.dy > size.height) p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  Offset position;
  Offset velocity;
  double radius;
  Color color;
  _Particle({required this.position, required this.velocity, required this.radius, required this.color});
}

// --------------------------------------------------------------------------
// CustomPainter للشبكة الهندسية
// --------------------------------------------------------------------------
class GridPainter extends CustomPainter {
  final double animationValue;
  GridPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03 + animationValue * 0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
