import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'routing/app_router.dart';

void main() {
  runApp(ProviderScope(child: TravelJournalApp(router: createAppRouter())));
}
