import 'package:flutter/material.dart';

const _kBlue = Color(0xFF2D82FA);
const _kGreen = Color(0xFF0F8A5D);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);

class CommunityHeader extends StatelessWidget {
  final int selectedFilterIndex;
  final ValueChanged<int> onFilterChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const CommunityHeader({
    super.key,
    required this.selectedFilterIndex,
    required this.onFilterChanged,
    required this.onSearchChanged,
    this.onNotificationTap,
    this.onProfileTap,
  });

  static const List<String> _filters = [
    'Todo',
    'Foros de Apoyo',
    'Hábitos Compartidos',
    'Artículos',
    'Especialistas',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: App title + subtitle + actions
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Brain logo avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF5FF),
                shape: BoxShape.circle,
                border: Border.all(color: _kBlue.withValues(alpha: 0.2), width: 1.5),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.psychology_rounded,
                color: _kBlue,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            // Title and connected members
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comunidad & Bienestar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _kTextDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: _kGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '4,890 miembros conectados',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _kTextGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action button: Notifications
            GestureDetector(
              onTap: onNotificationTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: _kTextDark,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Action button: User Avatar
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8EC),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF94C84).withValues(alpha: 0.3), width: 1.5),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFFE22D6F),
                  size: 22,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Search bar
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFE0E0E6), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Buscar foros, hábitos comunitarios, artículos o...',
              hintStyle: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF9E9E9E),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Color(0xFF9E9E9E),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Filter Pills
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = selectedFilterIndex == index;
              return GestureDetector(
                onTap: () => onFilterChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _kBlue : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? _kBlue : const Color(0xFFE0E0E6),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: _kBlue.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : _kTextDark,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
