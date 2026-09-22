import 'package:flutter/material.dart';
import '../../data/models/community_feed_models.dart';

const _kBlue = Color(0xFF2D82FA);
const _kGreen = Color(0xFF0F8A5D);

class VerifiedSpecialistCard extends StatelessWidget {
  final VerifiedSpecialistItem specialist;
  final VoidCallback onViewProfile;
  final VoidCallback onBookSession;

  const VerifiedSpecialistCard({
    super.key,
    required this.specialist,
    required this.onViewProfile,
    required this.onBookSession,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.surfaceContainerHighest, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row: Avatar + Name + Rating + Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: specialist.avatarUrl.isEmpty ? _kBlue : null,
                backgroundImage: specialist.avatarUrl.isNotEmpty ? NetworkImage(specialist.avatarUrl) : null,
                child: specialist.avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
              ),

              const SizedBox(width: 12),

              // Specialist details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      specialist.name,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Specialty
                    Text(
                      specialist.specialty,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _kGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bottom buttons row: "Ver perfil" & "Agendar sesión"
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onViewProfile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Mensaje',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onBookSession,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: _kBlue,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: _kBlue.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Agendar sesión',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

