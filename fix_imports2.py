import os

files_to_fix = {
    "lib/features/reports/data/reports_repository.dart": [
        ("import '../models/habit_stats.dart';", "import 'models/habit_stats.dart';")
    ],
    "lib/features/reports/providers/reports_provider.dart": [
        ("import '../models/habit_stats.dart';", "import '../data/models/habit_stats.dart';"),
        ("import '../domain/habit_stats.dart';", "import '../data/models/habit_stats.dart';")
    ],
    "lib/features/profile/presentation/screens/profile_screen.dart": [
        ("import '../../../../core/widgets/location_card.dart';", "import '../../../location/presentation/widgets/location_card.dart';")
    ],
    "lib/features/location/providers/location_provider.dart": [
        ("import '../services/location_service.dart';", "import '../data/services/location_service.dart';"),
        ("import '../../services/location_service.dart';", "import '../data/services/location_service.dart';")
    ]
}

for path, replacements in files_to_fix.items():
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            content = f.read()
        for old, new in replacements:
            content = content.replace(old, new)
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Fixed {path}")
