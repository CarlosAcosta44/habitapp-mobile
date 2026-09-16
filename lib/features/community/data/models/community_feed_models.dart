import 'package:flutter/material.dart';

/// Modelo para los hábitos sugeridos por la comunidad
class CommunityHabitItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String participantsCount;
  final String? badgeText;
  final bool isAdded;

  const CommunityHabitItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.participantsCount,
    this.badgeText,
    this.isAdded = false,
  });

  CommunityHabitItem copyWith({bool? isAdded}) {
    return CommunityHabitItem(
      id: id,
      title: title,
      description: description,
      icon: icon,
      iconColor: iconColor,
      iconBgColor: iconBgColor,
      participantsCount: participantsCount,
      badgeText: badgeText,
      isAdded: isAdded ?? this.isAdded,
    );
  }
}

/// Modelo para los posts de Foros y Círculos de Apoyo (Feed con Infinite Scroll)
class ForumPostItem {
  final String id;
  final String authorName;
  final String authorInitials;
  final Color avatarColor;
  final String timeAgo;
  final String tag;
  final String questionTitle;
  final String content;
  final int commentsCount;
  final int likesCount;
  final bool isLikedByMe;

  const ForumPostItem({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.avatarColor,
    required this.timeAgo,
    required this.tag,
    required this.questionTitle,
    required this.content,
    required this.commentsCount,
    required this.likesCount,
    this.isLikedByMe = false,
  });

  ForumPostItem copyWith({
    int? likesCount,
    bool? isLikedByMe,
    int? commentsCount,
  }) {
    return ForumPostItem(
      id: id,
      authorName: authorName,
      authorInitials: authorInitials,
      avatarColor: avatarColor,
      timeAgo: timeAgo,
      tag: tag,
      questionTitle: questionTitle,
      content: content,
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }
}

/// Modelo para Artículos y Guías Clínicas
class ClinicalArticleItem {
  final String id;
  final String category;
  final Color categoryColor;
  final String readTime;
  final String title;
  final String description;
  final String author;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const ClinicalArticleItem({
    required this.id,
    required this.category,
    required this.categoryColor,
    required this.readTime,
    required this.title,
    required this.description,
    required this.author,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

/// Modelo para Especialistas Verificados
class VerifiedSpecialistItem {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewsCount;
  final String priceSession;
  final bool isOnline;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const VerifiedSpecialistItem({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewsCount,
    required this.priceSession,
    this.isOnline = true,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

/// Modelo para el Reto Comunitario Activo destacado
class ActiveChallengeSummary {
  final String id;
  final String badge;
  final String remainingTime;
  final String title;
  final String participantsInfo;
  final IconData icon;
  final bool isJoined;

  const ActiveChallengeSummary({
    required this.id,
    required this.badge,
    required this.remainingTime,
    required this.title,
    required this.participantsInfo,
    required this.icon,
    this.isJoined = false,
  });

  ActiveChallengeSummary copyWith({bool? isJoined}) {
    return ActiveChallengeSummary(
      id: id,
      badge: badge,
      remainingTime: remainingTime,
      title: title,
      participantsInfo: participantsInfo,
      icon: icon,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}

