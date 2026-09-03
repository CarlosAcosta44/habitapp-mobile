import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final double progress;
  final bool isCompleted;
  final String? categoryName;
  final Color? categoryColor;
  final VoidCallback onToggle;

  const HabitCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.progress,
    this.isCompleted = false,
    this.categoryName,
    this.categoryColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = categoryColor ?? Colors.blue;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: isCompleted ? 1.0 : progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? Colors.green : effectiveColor,
                  ),
                  strokeWidth: 3,
                ),
                Icon(
                  isCompleted ? Icons.check : icon,
                  color: isCompleted ? Colors.green : effectiveColor,
                  size: 20,
                ),
              ],
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              if (categoryName != null && categoryName!.isNotEmpty) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: effectiveColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: effectiveColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: effectiveColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        categoryName!,
                        style: TextStyle(
                          color: effectiveColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mock friends avatars
              if (!isCompleted)
                SizedBox(
                  width: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 20,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red.shade100,
                          child: const Icon(Icons.person, size: 12),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(Icons.person, size: 12),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue.shade100,
                          child: const Text(
                            '+3',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isCompleted) const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isCompleted ? Colors.green : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isCompleted ? Colors.green : Colors.transparent,
                ),
                child: IconButton(
                  icon: Icon(
                    isCompleted ? Icons.check : Icons.add,
                    color: isCompleted ? Colors.white : Colors.black,
                  ),
                  onPressed: onToggle,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
