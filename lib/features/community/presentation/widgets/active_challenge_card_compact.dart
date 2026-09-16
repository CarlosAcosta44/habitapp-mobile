import 'package:flutter/material.dart';
import '../../data/models/community_feed_models.dart';

const _kBlue = Color(0xFF2D82FA);
const _kGreen = Color(0xFF0F8A5D);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);

class ActiveChallengeCardCompact extends StatelessWidget {
  final ActiveChallengeSummary challenge;
  final VoidCallback onJoin;
  final VoidCallback onSeeAll;

  const ActiveChallengeCardCompact({
    super.key,
    required this.challenge,
    required this.onJoin,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFF2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Group badge + remaining days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  challenge.badge,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: _kGreen,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: _kTextGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    challenge.remainingTime,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _kTextGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Main body: Icon + Title/Participants + Join Button
          Row(
            children: [
              // Challenge Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBF2),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(
                  challenge.icon,
                  color: const Color(0xFFE22D6F),
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              // Title and Participants
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: _kTextDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      challenge.participantsInfo,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Action button: Unirme
              GestureDetector(
                onTap: onJoin,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: challenge.isJoined ? const Color(0xFFE6F4EE) : _kBlue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: challenge.isJoined
                        ? []
                        : [
                            BoxShadow(
                              color: _kBlue.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Text(
                    challenge.isJoined ? 'Unido' : 'Unirme',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: challenge.isJoined ? _kGreen : Colors.white,
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

