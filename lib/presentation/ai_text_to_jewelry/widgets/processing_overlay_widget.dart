import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProcessingOverlayWidget extends StatefulWidget {
  final bool isVisible;

  const ProcessingOverlayWidget({
    Key? key,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<ProcessingOverlayWidget> createState() =>
      _ProcessingOverlayWidgetState();
}

class _ProcessingOverlayWidgetState extends State<ProcessingOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentStepIndex = 0;

  final List<Map<String, dynamic>> _processingSteps = [
    {
      'text': 'Analizando descripción...',
      'icon': 'search',
      'duration': 2000,
    },
    {
      'text': 'Generando diseño...',
      'icon': 'auto_fix_high',
      'duration': 3000,
    },
    {
      'text': 'Optimizando para impresión...',
      'icon': 'print',
      'duration': 2000,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _startProcessingAnimation();
    }
  }

  @override
  void didUpdateWidget(ProcessingOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startProcessingAnimation();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.reverse();
    }
  }

  void _startProcessingAnimation() {
    _animationController.forward();
    _currentStepIndex = 0;
    _cycleSteps();
  }

  void _cycleSteps() {
    if (!widget.isVisible) return;

    if (_currentStepIndex < _processingSteps.length - 1) {
      Future.delayed(
        Duration(milliseconds: _processingSteps[_currentStepIndex]['duration']),
        () {
          if (mounted && widget.isVisible) {
            setState(() {
              _currentStepIndex++;
            });
            _cycleSteps();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated jewelry icons
              Container(
                width: 20.w,
                height: 20.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating background circle
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.linear,
                        ),
                      ),
                      child: Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    // Center jewelry icon
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'diamond',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 8.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Processing step indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _processingSteps[_currentStepIndex]['icon'],
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      _processingSteps[_currentStepIndex]['text'],
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Progress indicator
              Container(
                width: 60.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      (_currentStepIndex + 1) / _processingSteps.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                '${_currentStepIndex + 1} de ${_processingSteps.length}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
