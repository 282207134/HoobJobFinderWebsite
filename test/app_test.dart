import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoob_app/app.dart';
import 'package:hoob_app/data/app_store.dart';
import 'package:hoob_app/data/catalog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestFilePicker extends FilePicker {
  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async =>
      FilePickerResult([PlatformFile(name: 'Cameron_Resume.pdf', size: 2048)]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final navigator = GlobalKey<NavigatorState>();
  final boundaryKey = GlobalKey();
  late AppStore store;
  Future<void> load(
    WidgetTester tester, {
    double width = 390,
    double height = 844,
    Map<String, Object> initial = const {},
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues(initial);
    store = AppStore(await SharedPreferences.getInstance());
    final font = FontLoader('RedHatDisplay')
      ..addFont(rootBundle.load('assets/fonts/RedHatDisplay-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/RedHatDisplay-Bold.ttf'))
      ..addFont(rootBundle.load('assets/fonts/RedHatDisplay-ExtraBold.ttf'));
    await font.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    await tester.pumpWidget(
      RepaintBoundary(
        key: boundaryKey,
        child: HoobApp(store: store, navigatorKey: navigator),
      ),
    );
    await tester.runAsync(() async {
      for (final asset in [
        'hero',
        'funding',
        'startup',
        'investor',
        'partners',
        'article-hiring',
        'article-funds',
        'article-team',
        'article-culture',
        'shopify',
        'mailchimp',
        'intercom',
        'telegram',
        'airbnb',
        'meta',
      ]) {
        await precacheImage(
          AssetImage('assets/images/$asset.png'),
          boundaryKey.currentContext!,
        );
      }
    });
    await tester.pumpAndSettle();
  }

  Future<void> open(
    WidgetTester tester,
    String route, {
    Object? arguments,
  }) async {
    navigator.currentState!.pushNamedAndRemoveUntil(
      route,
      (_) => false,
      arguments: arguments,
    );
    await tester.pumpAndSettle();
  }

  Future<void> capture(WidgetTester tester, String name) async {
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: name);
    if (!const bool.fromEnvironment('CAPTURE_SCREENSHOTS')) {
      return;
    }
    debugPrint('Capture: $name');
    final boundary =
        boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      final file = File('docs/screenshots/app/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });
  }

  testWidgets('all source screens render and export at mobile size', (
    tester,
  ) async {
    await load(
      tester,
      initial: {
        'savedJobs': ['mailchimp-fe', 'shopify-design', 'telegram-marketing'],
        'savedCompanies': ['shopify', 'point-nine'],
        'applications': '{"shopify-design":"2026-11-01T12:00:00.000"}',
      },
    );
    const routes = [
      ('01-home', '/'),
      ('02-find-jobs', '/jobs'),
      ('03-job-details', '/job'),
      ('04-browse-startups', '/startups'),
      ('05-seek-funding', '/funding'),
      ('06-for-investor', '/for-investor'),
      ('07-for-startups', '/for-startups'),
      ('08-company', '/company'),
      ('09-blogs', '/blogs'),
      ('10-blog-details', '/article'),
      ('11-contact', '/contact'),
      ('12-apply', '/apply'),
      ('13-application-sent', '/sent'),
      ('14-my-jobs', '/my-jobs'),
      ('15-startup-profile', '/organization'),
    ];
    for (final item in routes) {
      await open(tester, item.$2);
      await capture(tester, item.$1);
    }
    await open(tester, '/jobs');
    await tester.tap(find.byKey(const Key('job-filters')));
    await tester.pumpAndSettle();
    await capture(tester, '16-job-filters');
  });

  testWidgets('search, filters, bookmark and persistence', (tester) async {
    await load(tester);
    await open(tester, '/jobs');
    await tester.enterText(find.byKey(const Key('job-search')), 'Mailchimp');
    await tester.pumpAndSettle();
    expect(find.text('Job opportunities (1)'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('save-mailchimp-fe')));
    await tester.pumpAndSettle();
    expect(store.savedJobs, contains('mailchimp-fe'));
    final restored = AppStore(await SharedPreferences.getInstance());
    expect(restored.savedJobs, contains('mailchimp-fe'));
    await tester.enterText(find.byKey(const Key('job-search')), 'no-such-job');
    await tester.pumpAndSettle();
    expect(find.text('No matching roles yet'), findsOneWidget);
    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('job-filters')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Design'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('apply-filters')));
    await tester.pumpAndSettle();
    expect(find.text('Job opportunities (1)'), findsOneWidget);
    expect(find.text('Lead Product Designer'), findsOneWidget);
    await open(tester, '/my-jobs');
    expect(find.text('Front-End Developer'), findsOneWidget);
  });

  testWidgets('application validates then saves and appears in dashboard', (
    tester,
  ) async {
    FilePicker.platform = TestFilePicker();
    await load(tester);
    await open(tester, '/apply');
    await tester.ensureVisible(find.byKey(const Key('submit-application')));
    await tester.tap(find.byKey(const Key('submit-application')));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your full name.'), findsOneWidget);
    expect(store.applications, isEmpty);
    final fields = find.byType(TextFormField);
    await tester.ensureVisible(fields.at(0));
    await tester.enterText(fields.at(0), 'Cameron Williamson');
    await tester.enterText(fields.at(1), 'bad-email');
    await tester.ensureVisible(find.byKey(const Key('submit-application')));
    await tester.tap(find.byKey(const Key('submit-application')));
    await tester.pumpAndSettle();
    expect(find.text('Please enter a valid email.'), findsOneWidget);
    await tester.ensureVisible(fields.at(1));
    await tester.enterText(fields.at(1), 'cameron@example.com');
    await tester.ensureVisible(find.byKey(const Key('resume-picker')));
    await tester.tap(find.byKey(const Key('resume-picker')));
    await tester.pumpAndSettle();
    expect(find.text('Cameron_Resume.pdf'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('submit-application')));
    await tester.tap(find.byKey(const Key('submit-application')));
    await tester.pumpAndSettle();
    expect(find.text('You made\nyour next move.'), findsOneWidget);
    expect(store.applications, contains('mailchimp-fe'));
    await tester.tap(find.text('View My Jobs ↗'));
    await tester.pumpAndSettle();
    expect(find.text('Front-End Developer'), findsOneWidget);
    expect(
      AppStore(await SharedPreferences.getInstance()).applications,
      contains('mailchimp-fe'),
    );
  });

  testWidgets('small phones and wide layouts avoid overflow', (tester) async {
    await load(tester, width: 320, height: 740);
    for (final route in [
      '/',
      '/jobs',
      '/job',
      '/startups',
      '/funding',
      '/for-investor',
      '/for-startups',
      '/company',
      '/blogs',
      '/article',
      '/contact',
      '/apply',
      '/sent',
      '/my-jobs',
      '/organization',
    ]) {
      await open(tester, route);
      expect(tester.takeException(), isNull, reason: '320px $route');
    }
    await open(tester, '/jobs');
    await tester.tap(find.byKey(const Key('job-filters')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: '320px filter sheet');
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(1280, 900);
    await open(tester, '/');
    await capture(tester, '17-desktop-home');
    tester.view.physicalSize = const Size(768, 1024);
    await open(tester, '/jobs');
    await capture(tester, '18-tablet-jobs');
  });

  testWidgets('local profile and contact drafts survive navigation', (
    tester,
  ) async {
    await load(tester);
    await open(tester, '/for-investor');
    await tester.tap(find.text('Create investor profile ↗'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'North Ventures');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Early-stage climate technology',
    );
    await tester.tap(find.text('Save local profile ↗'));
    await tester.pumpAndSettle();
    expect(store.readDraft('investorDraft')['name'], 'North Ventures');
    await capture(tester, '19-local-investor-profile');
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create investor profile ↗'));
    await tester.pumpAndSettle();
    expect(find.text('North Ventures'), findsOneWidget);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    await open(tester, '/contact');
    for (final entry in [
      'Cameron',
      'Williamson',
      'cameron@example.com',
      'Let’s build a great community together.',
    ].indexed) {
      await tester.enterText(find.byType(TextFormField).at(entry.$1), entry.$2);
    }
    await tester.ensureVisible(find.text('Save my note ↗'));
    await tester.tap(find.text('Save my note ↗'));
    await tester.pumpAndSettle();
    expect(find.text('Your note is saved.'), findsOneWidget);
    await capture(tester, '20-contact-saved');
    await open(tester, '/contact');
    expect(find.text('cameron@example.com'), findsOneWidget);
  });

  testWidgets('directory search, article categories and FAQ work', (
    tester,
  ) async {
    await load(tester);
    await open(tester, '/startups');
    await tester.enterText(find.byType(TextField).first, 'Shopify');
    await tester.pumpAndSettle();
    expect(find.text('Exciting companies (1)'), findsOneWidget);
    await open(tester, '/startups');
    await tester.tap(find.widgetWithIcon(OutlinedButton, Icons.tune));
    await tester.pumpAndSettle();
    final industry = find.byType(DropdownButtonFormField<String>).first;
    await tester.tap(industry);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Technology').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(tester.state<FormFieldState<String>>(industry).value, 'All');
    await tester.tap(find.text('Apply filters'));
    await tester.pumpAndSettle();
    expect(find.text('Exciting companies (6)'), findsOneWidget);
    await open(tester, '/blogs');
    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Funding'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Funding'));
    await tester.pumpAndSettle();
    expect(find.text(articles[1].title), findsOneWidget);
    await open(tester, '/for-investor');
    await tester.ensureVisible(find.text('How come all of this is for free?'));
    await tester.tap(find.text('How come all of this is for free?'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Our goal is to make it easier'),
      findsOneWidget,
    );
  });
}
