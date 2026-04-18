import 'package:flutter/material.dart';

class AuthWebSidebar extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;
  final Widget child;

  const AuthWebSidebar({
    super.key,
    required this.isVisible,
    required this.onClose,
    required this.child,
  });

  @override
  State<AuthWebSidebar> createState() => _AuthWebSidebarState();
}

class _AuthWebSidebarState extends State<AuthWebSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AuthWebSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.isVisible) {
          _showOverlay();
        } else {
          _hideOverlay();
        }
      });
    }
  }

  void _showOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => _buildOverlay(),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
    _animationController.forward();
  }

  void _hideOverlay() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  Widget _buildOverlay() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            if (_animationController.value > 0)
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black
                      .withOpacity(0.5 * _animationController.value),
                ),
              ),
            Positioned(
              top: 0,
              right: 0,
              width: 500,
              height: MediaQuery.of(context).size.height,
              child: SlideTransition(
                position: _slideAnimation,
                child: Material(
                  elevation: 8,
                  color: Colors.white,
                  child: SizedBox.expand(child: widget.child),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This widget doesn't render anything itself - it uses overlays
    return const SizedBox.shrink();
  }
}
