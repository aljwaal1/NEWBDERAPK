import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BadrApp());
}

class LearningItem {
  final String id;
  final String emoji;
  final String ar;
  final String en;
  final String note;

  const LearningItem({
    required this.id,
    required this.emoji,
    required this.ar,
    required this.en,
    required this.note,
  });
}

class LearningWorld {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final List<LearningItem> items;

  const LearningWorld({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.items,
  });
}

class ItemRef {
  final LearningWorld world;
  final LearningItem item;

  const ItemRef(this.world, this.item);

  String get key => '${world.id}_${item.id}';
}

class BadrStory {
  final String title;
  final String emoji;
  final List<String> pages;

  const BadrStory(this.title, this.emoji, this.pages);
}

const worlds = <LearningWorld>[
  LearningWorld(
    id: 'animals',
    title: 'عالم الحيوانات',
    subtitle: 'أصوات وأسماء وكلمات',
    emoji: '🦁',
    color: Color(0xff22c55e),
    items: [
      LearningItem(id: 'lion', emoji: '🦁', ar: 'أسد', en: 'Lion', note: 'الأسد قوي ويعيش في الغابة.'),
      LearningItem(id: 'tiger', emoji: '🐯', ar: 'نمر', en: 'Tiger', note: 'النمر سريع وله خطوط جميلة.'),
      LearningItem(id: 'elephant', emoji: '🐘', ar: 'فيل', en: 'Elephant', note: 'الفيل كبير وله خرطوم طويل.'),
      LearningItem(id: 'giraffe', emoji: '🦒', ar: 'زرافة', en: 'Giraffe', note: 'الزرافة لها رقبة طويلة.'),
      LearningItem(id: 'monkey', emoji: '🐒', ar: 'قرد', en: 'Monkey', note: 'القرد يحب اللعب والقفز.'),
      LearningItem(id: 'bear', emoji: '🐻', ar: 'دب', en: 'Bear', note: 'بدر هو الدب الصديق.'),
      LearningItem(id: 'rabbit', emoji: '🐰', ar: 'أرنب', en: 'Rabbit', note: 'الأرنب سريع ويحب الجزر.'),
      LearningItem(id: 'fox', emoji: '🦊', ar: 'ثعلب', en: 'Fox', note: 'الثعلب ذكي وهادئ.'),
      LearningItem(id: 'horse', emoji: '🐴', ar: 'حصان', en: 'Horse', note: 'الحصان يجري بسرعة.'),
      LearningItem(id: 'cat', emoji: '🐱', ar: 'قطة', en: 'Cat', note: 'القطة ناعمة وتحب اللعب.'),
    ],
  ),
  LearningWorld(
    id: 'food',
    title: 'الفواكه والطعام',
    subtitle: 'كلمات سهلة للطفل',
    emoji: '🍎',
    color: Color(0xffff8a18),
    items: [
      LearningItem(id: 'apple', emoji: '🍎', ar: 'تفاحة', en: 'Apple', note: 'التفاحة فاكهة مفيدة.'),
      LearningItem(id: 'banana', emoji: '🍌', ar: 'موز', en: 'Banana', note: 'الموز طري ولذيذ.'),
      LearningItem(id: 'orange', emoji: '🍊', ar: 'برتقال', en: 'Orange', note: 'البرتقال مليء بالعصير.'),
      LearningItem(id: 'grapes', emoji: '🍇', ar: 'عنب', en: 'Grapes', note: 'العنب حبات صغيرة جميلة.'),
      LearningItem(id: 'strawberry', emoji: '🍓', ar: 'فراولة', en: 'Strawberry', note: 'الفراولة حمراء ولذيذة.'),
      LearningItem(id: 'watermelon', emoji: '🍉', ar: 'بطيخ', en: 'Watermelon', note: 'البطيخ منعش في الصيف.'),
      LearningItem(id: 'carrot', emoji: '🥕', ar: 'جزر', en: 'Carrot', note: 'الجزر مفيد ومقرمش.'),
      LearningItem(id: 'corn', emoji: '🌽', ar: 'ذرة', en: 'Corn', note: 'الذرة صفراء ولذيذة.'),
    ],
  ),
  LearningWorld(
    id: 'transport',
    title: 'وسائل النقل',
    subtitle: 'سيارات وطائرات ومركبات',
    emoji: '🚗',
    color: Color(0xff0ea5e9),
    items: [
      LearningItem(id: 'car', emoji: '🚗', ar: 'سيارة', en: 'Car', note: 'السيارة تسير على الطريق.'),
      LearningItem(id: 'bus', emoji: '🚌', ar: 'حافلة', en: 'Bus', note: 'الحافلة تحمل ركابا كثيرين.'),
      LearningItem(id: 'train', emoji: '🚆', ar: 'قطار', en: 'Train', note: 'القطار يسير على السكة.'),
      LearningItem(id: 'plane', emoji: '✈️', ar: 'طائرة', en: 'Airplane', note: 'الطائرة تطير في السماء.'),
      LearningItem(id: 'ship', emoji: '🚢', ar: 'سفينة', en: 'Ship', note: 'السفينة تسير في البحر.'),
      LearningItem(id: 'bike', emoji: '🚲', ar: 'دراجة', en: 'Bicycle', note: 'الدراجة تحتاج توازنا.'),
      LearningItem(id: 'rocket', emoji: '🚀', ar: 'صاروخ', en: 'Rocket', note: 'الصاروخ يصعد إلى الفضاء.'),
      LearningItem(id: 'ambulance', emoji: '🚑', ar: 'إسعاف', en: 'Ambulance', note: 'الإسعاف يساعد المرضى.'),
    ],
  ),
  LearningWorld(
    id: 'letters_ar',
    title: 'الحروف العربية',
    subtitle: 'حروف واضحة مع نطق',
    emoji: 'أ ب',
    color: Color(0xff8b5cf6),
    items: [
      LearningItem(id: 'alef', emoji: 'أ', ar: 'ألف', en: 'A', note: 'ألف مثل أسد.'),
      LearningItem(id: 'baa', emoji: 'ب', ar: 'باء', en: 'B', note: 'باء مثل بدر.'),
      LearningItem(id: 'taa', emoji: 'ت', ar: 'تاء', en: 'T', note: 'تاء مثل تفاحة.'),
      LearningItem(id: 'jeem', emoji: 'ج', ar: 'جيم', en: 'J', note: 'جيم مثل جمل.'),
      LearningItem(id: 'haa', emoji: 'ح', ar: 'حاء', en: 'H', note: 'حاء مثل حصان.'),
      LearningItem(id: 'seen', emoji: 'س', ar: 'سين', en: 'S', note: 'سين مثل سمكة.'),
      LearningItem(id: 'meem', emoji: 'م', ar: 'ميم', en: 'M', note: 'ميم مثل موز.'),
      LearningItem(id: 'noon', emoji: 'ن', ar: 'نون', en: 'N', note: 'نون مثل نمر.'),
    ],
  ),
  LearningWorld(
    id: 'colors',
    title: 'الألوان',
    subtitle: 'الألوان بالعربي والإنجليزي',
    emoji: '🎨',
    color: Color(0xffec4899),
    items: [
      LearningItem(id: 'red', emoji: '🔴', ar: 'أحمر', en: 'Red', note: 'لون التفاح أحيانا أحمر.'),
      LearningItem(id: 'blue', emoji: '🔵', ar: 'أزرق', en: 'Blue', note: 'السماء لونها أزرق.'),
      LearningItem(id: 'green', emoji: '🟢', ar: 'أخضر', en: 'Green', note: 'العشب لونه أخضر.'),
      LearningItem(id: 'yellow', emoji: '🟡', ar: 'أصفر', en: 'Yellow', note: 'الشمس لونها أصفر.'),
      LearningItem(id: 'orange_color', emoji: '🟠', ar: 'برتقالي', en: 'Orange', note: 'الجزر لونه برتقالي.'),
      LearningItem(id: 'purple', emoji: '🟣', ar: 'بنفسجي', en: 'Purple', note: 'البنفسجي لون جميل.'),
    ],
  ),
  LearningWorld(
    id: 'shapes',
    title: 'الأشكال',
    subtitle: 'دائرة ومربع ومثلث',
    emoji: '🔺',
    color: Color(0xfff59e0b),
    items: [
      LearningItem(id: 'circle', emoji: '●', ar: 'دائرة', en: 'Circle', note: 'الدائرة شكل مستدير.'),
      LearningItem(id: 'square', emoji: '■', ar: 'مربع', en: 'Square', note: 'المربع له أربعة أضلاع.'),
      LearningItem(id: 'triangle', emoji: '▲', ar: 'مثلث', en: 'Triangle', note: 'المثلث له ثلاثة أضلاع.'),
      LearningItem(id: 'star', emoji: '★', ar: 'نجمة', en: 'Star', note: 'النجمة تلمع في السماء.'),
      LearningItem(id: 'heart', emoji: '♥', ar: 'قلب', en: 'Heart', note: 'القلب رمز المحبة.'),
      LearningItem(id: 'diamond', emoji: '◆', ar: 'معين', en: 'Diamond', note: 'المعين شكل جميل.'),
    ],
  ),
];

const stories = <BadrStory>[
  BadrStory('بدر في الغابة', '🐻', [
    'خرج بدر إلى الغابة الجميلة.',
    'رأى الأسد والنمر والزرافة.',
    'قال بدر: التعلم ممتع جدا.',
    'تعلم بدر كلمة أسد باللغة العربية والإنجليزية.',
    'عاد بدر ومعه نجمة جديدة.',
  ]),
  BadrStory('بدر في السوق', '🍎', [
    'ذهب بدر مع أمه إلى السوق.',
    'رأى تفاحة وموزا وبرتقالا.',
    'قال بدر: Apple يعني تفاحة.',
    'اختار بدر فاكهة صحية.',
    'فرح بدر لأنه تعلم كلمة جديدة.',
  ]),
  BadrStory('رحلة الطائرة', '✈️', [
    'نظر بدر إلى السماء.',
    'رأى طائرة كبيرة تطير.',
    'ضغط زر النطق وسمع كلمة طائرة.',
    'ثم سمع كلمة Airplane.',
    'قال بدر: أنا أحب التعلم.',
  ]),
  BadrStory('النجمة الصغيرة', '⭐', [
    'وجد بدر نجمة لامعة.',
    'قالت النجمة: اجمع المعرفة كل يوم.',
    'تعلم بدر لونا وشكلا وحرفا.',
    'زاد عدد النجوم في تقدمه.',
    'نام بدر سعيدا بما تعلمه.',
  ]),
];

List<ItemRef> get allRefs {
  return worlds.expand((world) => world.items.map((item) => ItemRef(world, item))).toList();
}

class BadrApp extends StatelessWidget {
  const BadrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عالم بدر',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0ea5e9)),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: BadrHome(),
      ),
    );
  }
}

class BadrHome extends StatefulWidget {
  const BadrHome({super.key});

  @override
  State<BadrHome> createState() => _BadrHomeState();
}

class _BadrHomeState extends State<BadrHome> {
  static const MethodChannel recorderChannel = MethodChannel('badr.audio/recorder');

  final FlutterTts tts = FlutterTts();
  final AudioPlayer player = AudioPlayer();

  int tab = 0;
  int stars = 0;
  int gameWins = 0;
  final Set<String> learned = <String>{};
  final Set<String> recorded = <String>{};
  String? activeRecordingKey;

  @override
  void initState() {
    super.initState();
    loadState();
    warmTts();
  }

  Future<void> warmTts() async {
    try {
      await tts.setVolume(1);
      await tts.setLanguage('ar-JO');
      await tts.setSpeechRate(0.52);
      await tts.stop();
    } catch (_) {}
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      stars = prefs.getInt('stars') ?? 0;
      gameWins = prefs.getInt('gameWins') ?? 0;
      learned
        ..clear()
        ..addAll(prefs.getStringList('learned') ?? const <String>[]);
      recorded
        ..clear()
        ..addAll(prefs.getStringList('recorded') ?? const <String>[]);
    });
  }

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stars', stars);
    await prefs.setInt('gameWins', gameWins);
    await prefs.setStringList('learned', learned.toList());
    await prefs.setStringList('recorded', recorded.toList());
  }

  Future<String> recordPath(String key) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/badr_$key.m4a';
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textDirection: TextDirection.rtl),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> speakArabic(ItemRef ref) async {
    final path = await recordPath(ref.key);
    await player.stop();
    await tts.stop();

    final file = File(path);
    if (file.existsSync() && file.lengthSync() > 600) {
      await player.play(DeviceFileSource(path));
      return;
    }

    await tts.setLanguage('ar-JO');
    await tts.setSpeechRate(0.52);
    await tts.setPitch(1.05);
    await tts.speak('${ref.item.ar}. ${ref.item.note}');
  }

  Future<void> speakEnglish(ItemRef ref) async {
    await player.stop();
    await tts.stop();
    await tts.setLanguage('en-US');
    await tts.setSpeechRate(0.44);
    await tts.setPitch(1.0);
    await tts.speak(ref.item.en);
  }

  Future<bool> startRecording(ItemRef ref) async {
    try {
      final allowed = await recorderChannel.invokeMethod<bool>('ensurePermission') ?? false;
      if (!allowed) {
        showMessage('اسمح للميكروفون، ثم اضغط تسجيل مرة أخرى.');
        return false;
      }

      await player.stop();
      await tts.stop();
      final path = await recordPath(ref.key);
      final started = await recorderChannel.invokeMethod<bool>('start', {'path': path}) ?? false;

      if (!started) {
        showMessage('تعذر بدء التسجيل.');
        return false;
      }

      setState(() => activeRecordingKey = ref.key);
      HapticFeedback.mediumImpact();
      showMessage('بدأ التسجيل. قل: ${ref.item.ar}');
      return true;
    } catch (_) {
      showMessage('تعذر تشغيل الميكروفون.');
      return false;
    }
  }

  Future<bool> stopRecording(ItemRef ref) async {
    try {
      await recorderChannel.invokeMethod('stop');
      final path = await recordPath(ref.key);
      final file = File(path);
      final ok = file.existsSync() && file.lengthSync() > 600;

      setState(() {
        activeRecordingKey = null;
        if (ok) {
          recorded.add(ref.key);
          stars += 2;
        }
      });

      await saveState();

      if (!ok) {
        showMessage('التسجيل قصير أو فارغ. جرب مرة أخرى.');
        return false;
      }

      showMessage('تم حفظ التسجيل العربي ⭐');
      await player.play(DeviceFileSource(path));
      return true;
    } catch (_) {
      setState(() => activeRecordingKey = null);
      showMessage('تعذر حفظ التسجيل.');
      return false;
    }
  }

  Future<void> deleteRecording(ItemRef ref) async {
    final path = await recordPath(ref.key);
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
    setState(() => recorded.remove(ref.key));
    await saveState();
    showMessage('تم حذف التسجيل.');
  }

  Future<void> markLearned(ItemRef ref) async {
    if (learned.add(ref.key)) {
      setState(() => stars++);
      await saveState();
      showMessage('أحسنت يا بطل ⭐');
    } else {
      showMessage('هذا العنصر محفوظ في تقدمك.');
    }
  }

  Future<void> winGame() async {
    setState(() {
      gameWins++;
      stars += 3;
    });
    await saveState();
    await tts.setLanguage('ar-JO');
    await tts.speak('رائع، إجابة صحيحة');
    showMessage('إجابة صحيحة ⭐');
  }

  @override
  void dispose() {
    player.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeWorldsPage(
        stars: stars,
        learned: learned.length,
        recorded: recorded.length,
        onOpenWorld: openWorld,
      ),
      GamesPage(onWin: winGame, speakArabic: speakArabic, speakEnglish: speakEnglish),
      StoriesPage(tts: tts),
      ProgressPage(stars: stars, learned: learned.length, recorded: recorded.length, gameWins: gameWins),
    ];

    return Scaffold(
      extendBody: true,
      body: BadrBackground(child: SafeArea(bottom: false, child: pages[tab])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        height: 76,
        backgroundColor: const Color(0xee052455),
        indicatorColor: const Color(0xffffd166),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Text('🗺️', style: TextStyle(fontSize: 22)), label: 'العوالم'),
          NavigationDestination(icon: Text('🎮', style: TextStyle(fontSize: 22)), label: 'الألعاب'),
          NavigationDestination(icon: Text('📖', style: TextStyle(fontSize: 22)), label: 'القصص'),
          NavigationDestination(icon: Text('⭐', style: TextStyle(fontSize: 22)), label: 'تقدمي'),
        ],
      ),
    );
  }

  void openWorld(LearningWorld world) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: WorldPage(
            world: world,
            recorded: recorded,
            isRecording: (key) => activeRecordingKey == key,
            speakArabic: speakArabic,
            speakEnglish: speakEnglish,
            startRecording: startRecording,
            stopRecording: stopRecording,
            deleteRecording: deleteRecording,
            markLearned: markLearned,
          ),
        ),
      ),
    );
  }
}

class BadrBackground extends StatelessWidget {
  final Widget child;

  const BadrBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff0787e8), Color(0xff64d8ff), Color(0xffffe08a), Color(0xff38c86f)],
              ),
            ),
          ),
        ),
        const Positioned(top: 38, left: 28, child: Text('☁️', style: TextStyle(fontSize: 48))),
        const Positioned(top: 52, right: 28, child: Text('☀️', style: TextStyle(fontSize: 58))),
        const Positioned(bottom: 90, right: 20, child: Text('🌳', style: TextStyle(fontSize: 62))),
        child,
      ],
    );
  }
}

class HomeWorldsPage extends StatelessWidget {
  final int stars;
  final int learned;
  final int recorded;
  final void Function(LearningWorld world) onOpenWorld;

  const HomeWorldsPage({
    super.key,
    required this.stars,
    required this.learned,
    required this.recorded,
    required this.onOpenWorld,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      children: [
        Row(
          children: [
            StatChip('⭐ $stars'),
            const SizedBox(width: 8),
            StatChip('📚 $learned'),
            const SizedBox(width: 8),
            StatChip('🎙️ $recorded'),
          ],
        ),
        const SizedBox(height: 14),
        const HeroCard(),
        const SectionTitle(icon: '🗺️', title: 'اختر عالم التعلم'),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: worlds.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (_, index) => WorldTile(world: worlds[index], onTap: () => onOpenWorld(worlds[index])),
        ),
      ],
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: SizedBox(
        height: 250,
        child: Stack(
          children: const [
            Positioned(left: 16, top: 32, child: BearFace(size: 135)),
            Positioned(
              right: 18,
              bottom: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('عالم', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xffffb703))),
                  Text('بدر', style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: Color(0xff0284c7))),
                  Text('تعلم • نطق • تسجيل • لعب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xff052455))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorldTile extends StatelessWidget {
  final LearningWorld world;
  final VoidCallback onTap;

  const WorldTile({super.key, required this.world, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 2),
          gradient: LinearGradient(colors: [world.color, world.color.withOpacity(0.72)]),
          boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 18, offset: Offset(0, 10))],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(world.emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 10),
            Text(world.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 6),
            Text(world.subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class WorldPage extends StatelessWidget {
  final LearningWorld world;
  final Set<String> recorded;
  final bool Function(String key) isRecording;
  final Future<void> Function(ItemRef ref) speakArabic;
  final Future<void> Function(ItemRef ref) speakEnglish;
  final Future<bool> Function(ItemRef ref) startRecording;
  final Future<bool> Function(ItemRef ref) stopRecording;
  final Future<void> Function(ItemRef ref) deleteRecording;
  final Future<void> Function(ItemRef ref) markLearned;

  const WorldPage({
    super.key,
    required this.world,
    required this.recorded,
    required this.isRecording,
    required this.speakArabic,
    required this.speakEnglish,
    required this.startRecording,
    required this.stopRecording,
    required this.deleteRecording,
    required this.markLearned,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BadrBackground(
        child: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            children: [
              Row(
                children: [
                  IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${world.emoji} ${world.title}', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white))),
                ],
              ),
              const SizedBox(height: 12),
              GridView.builder(
                itemCount: world.items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
                itemBuilder: (_, index) {
                  final ref = ItemRef(world, world.items[index]);
                  return InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: ItemPage(
                              ref: ref,
                              hasRecord: recorded.contains(ref.key),
                              isRecording: isRecording,
                              speakArabic: speakArabic,
                              speakEnglish: speakEnglish,
                              startRecording: startRecording,
                              stopRecording: stopRecording,
                              deleteRecording: deleteRecording,
                              markLearned: markLearned,
                            ),
                          ),
                        ),
                      );
                    },
                    child: SoftCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(ref.item.emoji, style: const TextStyle(fontSize: 46)),
                          const SizedBox(height: 8),
                          Text(ref.item.ar, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xff052455))),
                          Text(ref.item.en, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xff2563eb))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemPage extends StatefulWidget {
  final ItemRef ref;
  final bool hasRecord;
  final bool Function(String key) isRecording;
  final Future<void> Function(ItemRef ref) speakArabic;
  final Future<void> Function(ItemRef ref) speakEnglish;
  final Future<bool> Function(ItemRef ref) startRecording;
  final Future<bool> Function(ItemRef ref) stopRecording;
  final Future<void> Function(ItemRef ref) deleteRecording;
  final Future<void> Function(ItemRef ref) markLearned;

  const ItemPage({
    super.key,
    required this.ref,
    required this.hasRecord,
    required this.isRecording,
    required this.speakArabic,
    required this.speakEnglish,
    required this.startRecording,
    required this.stopRecording,
    required this.deleteRecording,
    required this.markLearned,
  });

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late bool hasRecord;
  bool localRecording = false;

  @override
  void initState() {
    super.initState();
    hasRecord = widget.hasRecord;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.ref.item;
    final recordingNow = localRecording || widget.isRecording(widget.ref.key);

    return Scaffold(
      body: BadrBackground(
        child: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
            children: [
              Row(
                children: [
                  IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(widget.ref.world.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white))),
                ],
              ),
              const SizedBox(height: 16),
              SoftCard(
                child: Column(
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 110)),
                    Text(item.ar, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Color(0xff052455))),
                    Text(item.en, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xff0ea5e9))),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: const Color(0xfffff7d6), borderRadius: BorderRadius.circular(20)),
                      child: Text(item.note, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xff3a2a00))),
                    ),
                    const SizedBox(height: 14),
                    if (hasRecord)
                      const Text('✅ يوجد تسجيل عربي محفوظ، وسيعمل قبل نطق الجهاز.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xff15803d)))
                    else
                      const Text('لا يوجد تسجيل بعد. يمكنك تسجيل صوتك العربي.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xff475569))),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ActionPill(label: '🔊 عربي', color: const Color(0xff16a34a), onTap: () => widget.speakArabic(widget.ref)),
                        ActionPill(label: '🔊 English', color: const Color(0xff2563eb), onTap: () => widget.speakEnglish(widget.ref)),
                        ActionPill(
                          label: recordingNow ? '⏹️ إيقاف' : '🎙️ تسجيل',
                          color: recordingNow ? const Color(0xffef4444) : const Color(0xffec4899),
                          onTap: () async {
                            if (recordingNow) {
                              final ok = await widget.stopRecording(widget.ref);
                              if (mounted) setState(() { localRecording = false; hasRecord = ok || hasRecord; });
                            } else {
                              final ok = await widget.startRecording(widget.ref);
                              if (mounted) setState(() => localRecording = ok);
                            }
                          },
                        ),
                        ActionPill(
                          label: '🗑️ حذف التسجيل',
                          color: const Color(0xff64748b),
                          onTap: () async {
                            await widget.deleteRecording(widget.ref);
                            if (mounted) setState(() => hasRecord = false);
                          },
                        ),
                        ActionPill(
                          label: '⭐ تعلمته',
                          color: const Color(0xfff59e0b),
                          onTap: () => widget.markLearned(widget.ref),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GamesPage extends StatefulWidget {
  final Future<void> Function() onWin;
  final Future<void> Function(ItemRef ref) speakArabic;
  final Future<void> Function(ItemRef ref) speakEnglish;

  const GamesPage({super.key, required this.onWin, required this.speakArabic, required this.speakEnglish});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  final Random random = Random();
  late ItemRef answer;
  late List<ItemRef> options;
  bool answered = false;
  bool englishMode = false;

  @override
  void initState() {
    super.initState();
    newQuestion();
  }

  void newQuestion() {
    final pool = allRefs;
    answer = pool[random.nextInt(pool.length)];
    final shuffled = [...pool]..shuffle(random);
    options = [answer, ...shuffled.where((ref) => ref.key != answer.key).take(3)]..shuffle(random);
    answered = false;
  }

  Future<void> choose(ItemRef ref) async {
    if (answered) return;
    setState(() => answered = true);
    if (ref.key == answer.key) {
      await widget.onWin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetText = englishMode ? answer.item.en : answer.item.ar;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      children: [
        const SectionTitle(icon: '🎮', title: 'ألعاب بدر'),
        SoftCard(
          child: Column(
            children: [
              Text(englishMode ? 'اختر صورة: $targetText' : 'أين: $targetText ؟', textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xff052455))),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ActionPill(label: '🔊 اسمع السؤال', color: const Color(0xff0ea5e9), onTap: () => englishMode ? widget.speakEnglish(answer) : widget.speakArabic(answer)),
                  ActionPill(label: englishMode ? 'عربي' : 'English', color: const Color(0xff8b5cf6), onTap: () => setState(() => englishMode = !englishMode)),
                  ActionPill(label: 'سؤال جديد', color: const Color(0xfff59e0b), onTap: () => setState(newQuestion)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemBuilder: (_, index) {
            final ref = options[index];
            final isCorrect = ref.key == answer.key;
            Color? color;
            if (answered) color = isCorrect ? const Color(0xffdcfce7) : const Color(0xffffe4e6);
            return InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () => choose(ref),
              child: SoftCard(
                color: color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(ref.item.emoji, style: const TextStyle(fontSize: 58)),
                    const SizedBox(height: 8),
                    Text(ref.item.ar, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Color(0xff052455))),
                    Text(ref.item.en, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xff2563eb))),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        CountingGame(onWin: widget.onWin),
      ],
    );
  }
}

class CountingGame extends StatefulWidget {
  final Future<void> Function() onWin;

  const CountingGame({super.key, required this.onWin});

  @override
  State<CountingGame> createState() => _CountingGameState();
}

class _CountingGameState extends State<CountingGame> {
  final Random random = Random();
  int number = 3;
  String emoji = '⭐';
  List<int> options = const [2, 3, 4, 5];
  bool answered = false;

  @override
  void initState() {
    super.initState();
    next();
  }

  void next() {
    number = 1 + random.nextInt(8);
    emoji = ['⭐', '🍎', '🐻', '🚗', '🎈'][random.nextInt(5)];
    final values = <int>{number, max(1, number - 1), number + 1, number + 2}.toList()..shuffle(random);
    options = values;
    answered = false;
  }

  Future<void> choose(int value) async {
    if (answered) return;
    setState(() => answered = true);
    if (value == number) {
      await widget.onWin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        children: [
          const Text('🔢 لعبة العد', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xff052455))),
          const SizedBox(height: 10),
          Text(List.filled(number, emoji).join(' '), textAlign: TextAlign.center, style: const TextStyle(fontSize: 38)),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final value in options)
                ActionPill(
                  label: '$value',
                  color: answered && value == number ? const Color(0xff16a34a) : const Color(0xff0ea5e9),
                  onTap: () => choose(value),
                ),
              ActionPill(label: 'جديد', color: const Color(0xfff59e0b), onTap: () => setState(next)),
            ],
          ),
        ],
      ),
    );
  }
}

class StoriesPage extends StatefulWidget {
  final FlutterTts tts;

  const StoriesPage({super.key, required this.tts});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  int storyIndex = 0;
  int pageIndex = 0;

  Future<void> speakPage() async {
    final text = stories[storyIndex].pages[pageIndex];
    await widget.tts.stop();
    await widget.tts.setLanguage('ar-JO');
    await widget.tts.setSpeechRate(0.52);
    await widget.tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final story = stories[storyIndex];
    final page = story.pages[pageIndex];

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      children: [
        const SectionTitle(icon: '📖', title: 'قصص بدر'),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: stories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) => ChoiceChip(
              label: Text('${stories[index].emoji} ${stories[index].title}', style: const TextStyle(fontWeight: FontWeight.w900)),
              selected: storyIndex == index,
              onSelected: (_) => setState(() { storyIndex = index; pageIndex = 0; }),
            ),
          ),
        ),
        SoftCard(
          child: Column(
            children: [
              Text(story.emoji, style: const TextStyle(fontSize: 78)),
              Text(story.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xff052455))),
              const SizedBox(height: 14),
              LinearProgressIndicator(value: (pageIndex + 1) / story.pages.length, minHeight: 10, borderRadius: BorderRadius.circular(99)),
              const SizedBox(height: 18),
              Text(page, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, height: 1.65, fontWeight: FontWeight.w900, color: Color(0xff0f172a))),
              const SizedBox(height: 18),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionPill(label: '🔊 اسمع الصفحة', color: const Color(0xff16a34a), onTap: speakPage),
                  ActionPill(label: 'السابق', color: const Color(0xff64748b), onTap: pageIndex == 0 ? null : () => setState(() => pageIndex--)),
                  ActionPill(label: pageIndex == story.pages.length - 1 ? 'إعادة' : 'التالي', color: const Color(0xff0ea5e9), onTap: () => setState(() => pageIndex = pageIndex == story.pages.length - 1 ? 0 : pageIndex + 1)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProgressPage extends StatelessWidget {
  final int stars;
  final int learned;
  final int recorded;
  final int gameWins;

  const ProgressPage({super.key, required this.stars, required this.learned, required this.recorded, required this.gameWins});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      children: [
        const SectionTitle(icon: '⭐', title: 'تقدم الطفل'),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ProgressBox(icon: '⭐', value: stars, title: 'نجمة'),
            ProgressBox(icon: '📚', value: learned, title: 'عنصر تعلمه'),
            ProgressBox(icon: '🎙️', value: recorded, title: 'تسجيل صوتي'),
            ProgressBox(icon: '🎮', value: gameWins, title: 'فوز في الألعاب'),
          ],
        ),
        const SizedBox(height: 14),
        const SoftCard(
          child: Column(
            children: [
              BearFace(size: 120),
              SizedBox(height: 10),
              Text('بدر فخور بك جدا!', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Color(0xff052455))),
              SizedBox(height: 8),
              Text(
                'هذا التطبيق Native APK فقط. لا يستخدم WebView ولا يفتح موقعا داخله. التسجيل العربي يحفظ على الجهاز.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xff475569)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProgressBox extends StatelessWidget {
  final String icon;
  final int value;
  final String title;

  const ProgressBox({super.key, required this.icon, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 38)),
          Text('$value', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xfff59e0b))),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xff052455))),
        ],
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const SoftCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.93),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xffffd166), width: 2),
        boxShadow: const [BoxShadow(color: Color(0x30000000), blurRadius: 20, offset: Offset(0, 10))],
      ),
      padding: padding,
      child: child,
    );
  }
}

class StatChip extends StatelessWidget {
  final String text;

  const StatChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xff052455),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xffffd166), width: 2),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String icon;
  final String title;

  const SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff052455),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xffffd166), width: 2),
      ),
      child: Text('$icon $title', textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w900)),
    );
  }
}

class ActionPill extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const ActionPill({super.key, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: onTap == null ? Colors.grey : color,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}

class BearFace extends StatelessWidget {
  final double size;

  const BearFace({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(left: size * .02, top: size * .04, child: CircleAvatar(radius: size * .18, backgroundColor: const Color(0xff8b4a1f))),
          Positioned(right: size * .02, top: size * .04, child: CircleAvatar(radius: size * .18, backgroundColor: const Color(0xff8b4a1f))),
          Container(
            width: size * .86,
            height: size * .86,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [Color(0xffffd29a), Color(0xffb96b2c), Color(0xff6b3416)]),
              boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 18, offset: Offset(0, 8))],
            ),
          ),
          Positioned(top: size * .34, left: size * .27, child: _Dot(size: size * .06)),
          Positioned(top: size * .34, right: size * .27, child: _Dot(size: size * .06)),
          Positioned(top: size * .48, child: _Dot(size: size * .08)),
          Positioned(bottom: size * .24, child: Container(width: size * .26, height: size * .05, decoration: BoxDecoration(color: const Color(0xff2b1608), borderRadius: BorderRadius.circular(99)))),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;

  const _Dot({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff1f1308)));
  }
}
