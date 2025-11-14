import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_1/providers/auth_provider.dart';
import 'package:proyecto_1/l10n/app_localizations.dart';

class UserGreeting extends ConsumerStatefulWidget {
  const UserGreeting({super.key});

  @override
  ConsumerState<UserGreeting> createState() => _UserGreetingState();
}

class _UserGreetingState extends ConsumerState<UserGreeting> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    // El greeting desaparece después de 4 segundos
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    if (!authState.isAuthenticated || !_isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.surface,
              child: Text(
                authState.userName?.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    loc.hello(authState.userName ?? loc.user),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (authState.userEmail != null)
                    Text(
                      authState.userEmail!,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.8,
                        ),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Icon(
              Icons.verified_user,
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
