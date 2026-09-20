import os

replacements = {
    "import '../../core/services/location_service.dart';": "import '../../location/data/services/location_service.dart';",
    "import '../../../core/services/location_service.dart';": "import '../../../location/data/services/location_service.dart';",
    "import '../../core/providers/location_provider.dart';": "import '../../location/providers/location_provider.dart';",
    "import '../../../core/providers/location_provider.dart';": "import '../../../location/providers/location_provider.dart';",
    "import '../../../core/widgets/location_card.dart';": "import '../../../location/presentation/widgets/location_card.dart';",
    "import '../domain/post.dart';": "import '../models/post.dart';",
    "import '../../domain/post.dart';": "import '../../data/models/post.dart';",
    "import '../domain/challenge.dart';": "import '../models/challenge.dart';",
    "import '../../domain/challenge.dart';": "import '../../data/models/challenge.dart';",
    "import '../domain/habit_stats.dart';": "import '../models/habit_stats.dart';",
    "import '../../domain/habit_stats.dart';": "import '../../data/models/habit_stats.dart';",
    "import '../../services/pdf_report_service.dart';": "import '../../data/services/pdf_report_service.dart';",
    "import '../services/pdf_report_service.dart';": "import '../data/services/pdf_report_service.dart';",
    "import 'features/notifications/services/notification_service.dart';": "import 'features/notifications/data/services/notification_service.dart';",
    "import '../domain/post.dart'": "import '../data/models/post.dart'",
    "import '../domain/challenge.dart'": "import '../data/models/challenge.dart'",
    "import '../domain/habit_stats.dart'": "import '../data/models/habit_stats.dart'",
}

for root, _, files in os.walk("lib"):
    for file in files:
        if file.endswith(".dart"):
            path = os.path.join(root, file)
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
            
            new_content = content
            for old, new in replacements.items():
                new_content = new_content.replace(old, new)
            
            if new_content != content:
                with open(path, "w", encoding="utf-8") as f:
                    f.write(new_content)
                print(f"Fixed {path}")

