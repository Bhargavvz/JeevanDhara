import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import '../utils/app_theme.dart';

// Enhanced button with micro-interactions and accessibility
class EnhancedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final double? height;
  final String? semanticsLabel;
  final String? tooltip;
  final bool showFeedback;

  const EnhancedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.height,
    this.semanticsLabel,
    this.tooltip,
    this.showFeedback = true,
  });

  @override
  State<EnhancedButton> createState() => _EnhancedButtonState();
}

class _EnhancedButtonState extends State<EnhancedButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      _scaleController.forward();
      if (widget.showFeedback) {
        _rippleController.forward();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  void _handleTap() {
    if (widget.isEnabled && !widget.isLoading && widget.onPressed != null) {
      // Haptic feedback
      HapticFeedback.selectionClick();
      
      // Accessibility announcement
      if (widget.semanticsLabel != null) {
        SemanticsService.announce(
          '${widget.semanticsLabel} activated',
          TextDirection.ltr,
        );
      }
      
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height ?? 48,
            decoration: BoxDecoration(
              borderRadius: AppTheme.buttonBorderRadius,
              boxShadow: widget.isEnabled
                  ? [
                      BoxShadow(
                        color: _getButtonColor().withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: _getButtonColor(),
              borderRadius: AppTheme.buttonBorderRadius,
              child: InkWell(
                onTap: _handleTap,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                borderRadius: AppTheme.buttonBorderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppTheme.buttonBorderRadius,
                    border: widget.type == ButtonType.secondary
                        ? Border.all(color: AppTheme.primaryGreen, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: _buildButtonContent(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return Semantics(
      label: widget.semanticsLabel ?? widget.text,
      hint: widget.tooltip,
      button: true,
      enabled: widget.isEnabled && !widget.isLoading,
      child: button,
    );
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.type == ButtonType.primary ? Colors.white : AppTheme.primaryGreen,
          ),
        ),
      );
    }

    List<Widget> children = [];
    
    if (widget.icon != null) {
      children.add(
        Icon(
          widget.icon,
          size: 20,
          color: widget.type == ButtonType.primary ? Colors.white : AppTheme.primaryGreen,
        ),
      );
      children.add(const SizedBox(width: 8));
    }
    
    children.add(
      Text(
        widget.text,
        style: TextStyle(
          color: widget.type == ButtonType.primary ? Colors.white : AppTheme.primaryGreen,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Color _getButtonColor() {
    if (!widget.isEnabled) {
      return AppTheme.neutralGray.withValues(alpha: 0.3);
    }
    
    switch (widget.type) {
      case ButtonType.primary:
        return AppTheme.primaryGreen;
      case ButtonType.secondary:
        return Colors.transparent;
      case ButtonType.text:
        return Colors.transparent;
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }
}

enum ButtonType { primary, secondary, text }

// Enhanced card with hover effects and accessibility
class EnhancedCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;
  final bool showShadow;
  final String? semanticsLabel;
  final bool isInteractive;

  const EnhancedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.elevation,
    this.showShadow = true,
    this.semanticsLabel,
    this.isInteractive = false,
  });

  @override
  State<EnhancedCard> createState() => _EnhancedCardState();
}

class _EnhancedCardState extends State<EnhancedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? 4,
      end: (widget.elevation ?? 4) + 4,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered && widget.isInteractive) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  void _handleTap() {
    if (widget.onTap != null) {
      HapticFeedback.selectionClick();
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin,
            decoration: BoxDecoration(
              color: widget.color ?? Colors.white,
              borderRadius: AppTheme.cardBorderRadius,
              boxShadow: widget.showShadow
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: _elevationAnimation.value,
                        offset: Offset(0, _elevationAnimation.value / 2),
                      ),
                    ]
                  : null,
            ),
            child: Semantics(
              label: widget.semanticsLabel,
              button: widget.onTap != null,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap != null ? _handleTap : null,
                  onHover: _handleHover,
                  borderRadius: AppTheme.cardBorderRadius,
                  child: Padding(
                    padding: widget.padding ?? const EdgeInsets.all(AppTheme.spacingM),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }
}

// Animated loading indicator
class AnimatedLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final String? text;

  const AnimatedLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
    this.text,
  });

  @override
  State<AnimatedLoadingIndicator> createState() => _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationController.value * 2 * 3.14159,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            widget.color ?? AppTheme.primaryGreen,
                            (widget.color ?? AppTheme.primaryGreen).withValues(alpha: 0.3),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        if (widget.text != null) ...[
          const SizedBox(height: AppTheme.spacingM),
          Text(
            widget.text!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

// Accessible form field with enhanced validation
class AccessibleFormField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final String? semanticsLabel;

  const AccessibleFormField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.semanticsLabel,
  });

  @override
  State<AccessibleFormField> createState() => _AccessibleFormFieldState();
}

class _AccessibleFormFieldState extends State<AccessibleFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  late Animation<Color?> _borderColorAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _initAnimations() {
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: AppTheme.neutralGray.withValues(alpha: 0.3),
      end: AppTheme.primaryGreen,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabel ?? widget.label,
      hint: widget.hint,
      textField: true,
      enabled: widget.enabled,
      child: AnimatedBuilder(
        animation: _borderColorAnimation,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                validator: widget.validator,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  helperText: widget.helperText,
                  errorText: widget.errorText,
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(widget.prefixIcon)
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? GestureDetector(
                          onTap: widget.onSuffixTap,
                          child: Icon(widget.suffixIcon),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: AppTheme.inputBorderRadius,
                    borderSide: BorderSide(
                      color: _borderColorAnimation.value!,
                      width: _isFocused ? 2 : 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppTheme.inputBorderRadius,
                    borderSide: BorderSide(
                      color: AppTheme.neutralGray.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppTheme.inputBorderRadius,
                    borderSide: const BorderSide(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: AppTheme.inputBorderRadius,
                    borderSide: const BorderSide(
                      color: AppTheme.errorRed,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _focusController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

// Animated status indicator
class AnimatedStatusIndicator extends StatefulWidget {
  final String status;
  final String text;
  final IconData icon;

  const AnimatedStatusIndicator({
    super.key,
    required this.status,
    required this.text,
    required this.icon,
  });

  @override
  State<AnimatedStatusIndicator> createState() => _AnimatedStatusIndicatorState();
}

class _AnimatedStatusIndicatorState extends State<AnimatedStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    if (_shouldPulse()) {
      _pulseController.repeat(reverse: true);
    }
  }

  bool _shouldPulse() {
    return ['pending', 'in_progress', 'syncing'].contains(widget.status.toLowerCase());
  }

  Color _getStatusColor() {
    switch (widget.status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'synced':
        return AppTheme.successGreen;
      case 'error':
      case 'failed':
        return AppTheme.errorRed;
      case 'warning':
      case 'pending':
        return AppTheme.warningOrange;
      case 'info':
      case 'in_progress':
      case 'syncing':
        return AppTheme.infoBlue;
      default:
        return AppTheme.neutralGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _shouldPulse() ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: color, size: 16),
                const SizedBox(width: 8),
                Text(
                  widget.text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}

// Accessibility helper functions
class AccessibilityHelper {
  static void announceMessage(String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  static void announceSuccess(String message) {
    SemanticsService.announce('Success: $message', TextDirection.ltr);
  }

  static void announceError(String message) {
    SemanticsService.announce('Error: $message', TextDirection.ltr);
  }

  static void announceLoading(String message) {
    SemanticsService.announce('Loading: $message', TextDirection.ltr);
  }

  static Widget buildSemanticWrapper({
    required Widget child,
    String? label,
    String? hint,
    bool button = false,
    bool textField = false,
    bool enabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: button,
      textField: textField,
      enabled: enabled,
      child: child,
    );
  }
}