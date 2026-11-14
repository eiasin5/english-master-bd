import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const EnglishMasterApp());
}

// ---------------------------------------------------------------------------
// Language support (Bangla + English)
// ---------------------------------------------------------------------------

/// Holds the current app language. Default is Bangla.
final ValueNotifier<Locale> appLocale = ValueNotifier<Locale>(const Locale('bn'));

const Map<String, Map<String, String>> _strings = {
  'bn': {
    'appName': 'English Master Sadia',
    'navHome': 'হোম',
    'navSaved': 'সেভ করা',
    'navProgress': 'অগ্রগতি',
    'navSettings': 'সেটিংস',
    'welcome': 'স্বাগতম!',
    'subtitle': 'আজ ইংরেজির কোন অংশ শিখবেন?',
    'statusTitle': 'অ্যাপ তৈরির কাজ চলছে',
    'statusBody':
        'এখন শুধু অ্যাপের মূল কাঠামো তৈরি হয়েছে। নিচের ফিচারগুলো ধাপে ধাপে যোগ হবে।',
    'featuresTitle': 'ফিচারসমূহ',
    'textTranslator': 'টেক্সট অনুবাদক',
    'imageTranslator': 'ছবি অনুবাদক',
    'vocabulary': 'ভোকাবুলারি',
    'grammar': 'গ্রামার',
    'dailyQuiz': 'ডেইলি কুইজ',
    'dictionary': 'ডিকশনারি',
    'comingSoonTitle': 'শীঘ্রই আসছে',
    'comingSoonBody':
        'এই ফিচারটি এখনো তৈরি হয়নি। পরবর্তী ধাপে যোগ করা হবে।',
    'language': 'ভাষা',
    'about': 'অ্যাপ সম্পর্কে',
    'version': 'ভার্সন',
  },
  'en': {
    'appName': 'English Master Sadia',
    'navHome': 'Home',
    'navSaved': 'Saved',
    'navProgress': 'Progress',
    'navSettings': 'Settings',
    'welcome': 'Welcome!',
    'subtitle': 'What would you like to learn today?',
    'statusTitle': 'App under construction',
    'statusBody':
        'Only the basic structure is ready for now. The features below will be added step by step.',
    'featuresTitle': 'Features',
    'textTranslator': 'Text Translator',
    'imageTranslator': 'Image Translator',
    'vocabulary': 'Vocabulary',
    'grammar': 'Grammar',
    'dailyQuiz': 'Daily Quiz',
    'dictionary': 'Dictionary',
    'comingSoonTitle': 'Coming soon',
    'comingSoonBody':
        'This feature is not built yet. It will be added in a later step.',
    'language': 'Language',
    'about': 'About',
    'version': 'Version',
  },
};

/// Returns the text for [key] in the current language.
/// Calling this inside build() makes the widget rebuild when language changes.
String tr(BuildContext context, String key) {
  final code = Localizations.localeOf(context).languageCode;
  return _strings[code]?[key] ?? _strings['en']![key] ?? key;
}

// ---------------------------------------------------------------------------
// App root
// ---------------------------------------------------------------------------

class EnglishMasterApp extends StatelessWidget {
  const EnglishMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'English Master Sadia',
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: const [Locale('bn'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: ThemeMode.system,
          home: const MainShell(),
        );
      },
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
  );
}

// ---------------------------------------------------------------------------
// Main screen with bottom navigation bar
// ---------------------------------------------------------------------------

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const List<Widget> _pages = [
    HomePage(),
    ComingSoonPage(titleKey: 'navSaved', icon: Icons.bookmark_border),
    ComingSoonPage(titleKey: 'navProgress', icon: Icons.insights_outlined),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: tr(context, 'navHome'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark_border),
            selectedIcon: const Icon(Icons.bookmark),
            label: tr(context, 'navSaved'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: tr(context, 'navProgress'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: tr(context, 'navSettings'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Home page
// ---------------------------------------------------------------------------

class Feature {
  final String key;
  final IconData icon;
  const Feature(this.key, this.icon);
}

const List<Feature> _features = [
  Feature('textTranslator', Icons.translate),
  Feature('imageTranslator', Icons.document_scanner),
  Feature('vocabulary', Icons.menu_book),
  Feature('grammar', Icons.rule),
  Feature('dailyQuiz', Icons.quiz),
  Feature('dictionary', Icons.library_books),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Tile colors rotate between three Material 3 container colors.
    final List<(Color, Color)> tileColors = [
      (scheme.primaryContainer, scheme.onPrimaryContainer),
      (scheme.secondaryContainer, scheme.onSecondaryContainer),
      (scheme.tertiaryContainer, scheme.onTertiaryContainer),
    ];

    // Make tiles taller when the phone's font size is increased.
    final double textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
    final double tileHeight = 90 + 44 * textScale;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(tr(context, 'appName')),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(context, 'welcome'),
                    style: textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr(context, 'subtitle'),
                    style: textTheme.bodyLarge
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.construction_outlined,
                            color: scheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(context, 'statusTitle'),
                                style: textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tr(context, 'statusBody'),
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    tr(context, 'featuresTitle'),
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: tileHeight,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final feature = _features[i];
                  final colors = tileColors[i % tileColors.length];
                  return _FeatureTile(
                    feature: feature,
                    background: colors.$1,
                    foreground: colors.$2,
                  );
                },
                childCount: _features.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final Feature feature;
  final Color background;
  final Color foreground;

  const _FeatureTile({
    required this.feature,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ComingSoonPage(
                titleKey: feature.key,
                icon: feature.icon,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(feature.icon, color: foreground),
              ),
              const SizedBox(height: 10),
              Text(
                tr(context, feature.key),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Placeholder page for features that are not built yet
// ---------------------------------------------------------------------------

class ComingSoonPage extends StatelessWidget {
  final String titleKey;
  final IconData icon;

  const ComingSoonPage({
    super.key,
    required this.titleKey,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(tr(context, titleKey))),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 44, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(height: 20),
              Text(
                tr(context, 'comingSoonTitle'),
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                tr(context, 'comingSoonBody'),
                style: textTheme.bodyLarge
                    ?.copyWith(color: scheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Settings page (language switch works)
// ---------------------------------------------------------------------------

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currentCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'navSettings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            tr(context, 'language'),
            style:
                textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(value: 'bn', label: Text('বাংলা')),
                ButtonSegment<String>(value: 'en', label: Text('English')),
              ],
              selected: {currentCode},
              onSelectionChanged: (selection) {
                appLocale.value = Locale(selection.first);
              },
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: Text(tr(context, 'appName')),
            subtitle: Text('${tr(context, 'version')}: 1.0.0'),
          ),
        ],
      ),
    );
  }
}
