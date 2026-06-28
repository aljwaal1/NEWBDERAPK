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

class BadrApp extends StatelessWidget {
  const BadrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عالم بدر',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1d9bf0)),
      ),
      home: const BadrShell(),
    );
  }
}

class LearnItem {
  final String id;
  final String emoji;
  final String ar;
  final String en;
  final String hint;

  const LearnItem(this.id, this.emoji, this.ar, this.en, this.hint);
}

class LearnWorld {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final List<LearnItem> items;

  const LearnWorld({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.items,
  });
}

class StoryData {
  final String title;
  final String emoji;
  final List<String> pages;

  const StoryData(this.title, this.emoji, this.pages);
}

const worlds = <LearnWorld>[
  LearnWorld(
    id: 'animals',
    title: 'غابة الحيوانات',
    subtitle: 'حيوانات وصوت وتخيل',
    emoji: '🦁',
    color: Color(0xff16a34a),
    items: [
      LearnItem('lion', '🦁', 'أسد', 'Lion', 'الأسد قوي وشجاع.'),
      LearnItem('tiger', '🐯', 'نمر', 'Tiger', 'النمر سريع وله خطوط جميلة.'),
      LearnItem('elephant', '🐘', 'فيل', 'Elephant', 'الفيل كبير وله خرطوم طويل.'),
      LearnItem('giraffe', '🦒', 'زرافة', 'Giraffe', 'الزرافة لها رقبة طويلة.'),
      LearnItem('monkey', '🐒', 'قرد', 'Monkey', 'القرد يحب القفز واللعب.'),
      LearnItem('rabbit', '🐰', 'أرنب', 'Rabbit', 'الأرنب سريع ويحب الجزر.'),
      LearnItem('horse', '🐴', 'حصان', 'Horse', 'الحصان يجري بسرعة.'),
      LearnItem('cat', '🐱', 'قطة', 'Cat', 'القطة لطيفة وتحب اللعب.'),
    ],
  ),
  LearnWorld(
    id: 'food',
    title: 'سوق بدر',
    subtitle: 'فواكه وخضار لذيذة',
    emoji: '🍎',
    color: Color(0xfff97316),
    items: [
      LearnItem('apple', '🍎', 'تفاحة', 'Apple', 'التفاحة فاكهة مفيدة.'),
      LearnItem('banana', '🍌', 'موز', 'Banana', 'الموز طري ولذيذ.'),
      LearnItem('orange', '🍊', 'برتقال', 'Orange', 'البرتقال مليء بالعصير.'),
      LearnItem('grapes', '🍇', 'عنب', 'Grapes', 'العنب حبات صغيرة جميلة.'),
      LearnItem('watermelon', '🍉', 'بطيخ', 'Watermelon', 'البطيخ منعش في الصيف.'),
      LearnItem('carrot', '🥕', 'جزر', 'Carrot', 'الجزر مقرمش ومفيد.'),
      LearnItem('corn', '🌽', 'ذرة', 'Corn', 'الذرة صفراء ولذيذة.'),
      LearnItem('strawberry', '🍓', 'فراولة', 'Strawberry', 'الفراولة حمراء وجميلة.'),
    ],
  ),
  LearnWorld(
    id: 'transport',
    title: 'مدينة المركبات',
    subtitle: 'سيارات وقطارات وطائرات',
    emoji: '🚗',
    color: Color(0xff0284c7),
    items: [
      LearnItem('car', '🚗', 'سيارة', 'Car', 'السيارة تسير على الطريق.'),
      LearnItem('bus', '🚌', 'حافلة', 'Bus', 'الحافلة تحمل ركاباً كثيرين.'),
      LearnItem('train', '🚆', 'قطار', 'Train', 'القطار يسير على السكة.'),
      LearnItem('plane', '✈️', 'طائرة', 'Airplane', 'الطائرة تطير في السماء.'),
      LearnItem('ship', '🚢', 'سفينة', 'Ship', 'السفينة تسير في البحر.'),
      LearnItem('bike', '🚲', 'دراجة', 'Bicycle', 'الدراجة لها عجلتان.'),
      LearnItem('rocket', '🚀', 'صاروخ', 'Rocket', 'الصاروخ يصعد إلى الفضاء.'),
      LearnItem('ambulance', '🚑', 'سيارة إسعاف', 'Ambulance', 'الإسعاف يساعد المرضى.'),
    ],
  ),
  LearnWorld(
    id: 'letters',
    title: 'جزيرة الحروف',
    subtitle: 'حروف عربية وإنجليزية',
    emoji: '🔤',
    color: Color(0xff8b5cf6),
    items: [
      LearnItem('alef', 'أ', 'ألف', 'A', 'ألف مثل أسد.'),
      LearnItem('baa', 'ب', 'باء', 'B', 'باء مثل بدر.'),
      LearnItem('taa', 'ت', 'تاء', 'T', 'تاء مثل تفاحة.'),
      LearnItem('jeem', 'ج', 'جيم', 'J', 'جيم مثل جمل.'),
      LearnItem('seen', 'س', 'سين', 'S', 'سين مثل سمكة.'),
      LearnItem('meem', 'م', 'ميم', 'M', 'ميم مثل موز.'),
      LearnItem('noon', 'ن', 'نون', 'N', 'نون مثل نمر.'),
      LearnItem('yaa', 'ي', 'ياء', 'Y', 'ياء في كلمة يد.'),
    ],
  ),
  LearnWorld(
    id: 'numbers',
    title: 'وادي الأرقام',
    subtitle: 'عد من صفر إلى عشرة',
    emoji: '🔢',
    color: Color(0xffeab308),
    items: [
      LearnItem('n0', '0', 'صفر', 'Zero', 'لا يوجد شيء.'),
      LearnItem('n1', '1', 'واحد', 'One', 'شيء واحد.'),
      LearnItem('n2', '2', 'اثنان', 'Two', 'شيئان اثنان.'),
      LearnItem('n3', '3', 'ثلاثة', 'Three', 'ثلاث نجوم.'),
      LearnItem('n4', '4', 'أربعة', 'Four', 'أربع كرات.'),
      LearnItem('n5', '5', 'خمسة', 'Five', 'خمس أصابع.'),
      LearnItem('n6', '6', 'ستة', 'Six', 'ست زهور.'),
      LearnItem('n10', '10', 'عشرة', 'Ten', 'عشرة أشياء.'),
    ],
  ),
  LearnWorld(
    id: 'colors_shapes',
    title: 'حديقة الألوان',
    subtitle: 'ألوان وأشكال جميلة',
    emoji: '🎨',
    color: Color(0xffec4899),
    items: [
      LearnItem('red', '🔴', 'أحمر', 'Red', 'لون التفاحة.'),
      LearnItem('blue', '🔵', 'أزرق', 'Blue', 'لون السماء.'),
      LearnItem('green', '🟢', 'أخضر', 'Green', 'لون العشب.'),
      LearnItem('yellow', '🟡', 'أصفر', 'Yellow', 'لون الشمس.'),
      LearnItem('circle', '●', 'دائرة', 'Circle', 'شكل دائري بلا زوايا.'),
      LearnItem('square', '■', 'مربع', 'Square', 'له أربعة أضلاع متساوية.'),
      LearnItem('triangle', '▲', 'مثلث', 'Triangle', 'له ثلاثة أضلاع.'),
      LearnItem('star', '★', 'نجمة', 'Star', 'نجمة لامعة في السماء.'),
    ],
  ),
];

const stories = <StoryData>[
  StoryData('بدر والنجمة الصغيرة', '⭐', [
    'رأى بدر نجمة صغيرة تلمع فوق البيت.',
    'قال بدر: سأتعلم كلمة جديدة حتى أصل إليها.',
    'تعلم كلمة أسد، ثم حصل على نجمة جميلة.',
    'فرحت النجمة وقالت: أحسنت يا بدر.',
  ]),
  StoryData('رحلة بدر إلى الغابة', '🌳', [
    'دخل بدر الغابة بهدوء ومعه حقيبة صغيرة.',
    'قابل الأرنب والقرد والفيل.',
    'سمع أسماء الحيوانات بالعربي والإنجليزي.',
    'عاد بدر سعيداً لأنه تعلم كثيراً.',
  ]),
  StoryData('سوق الفواكه الملون', '🍎', [
    'ذهب بدر إلى سوق مليء بالألوان.',
    'وجد تفاحة وموزة وبرتقالة.',
    'قال بدر: Apple ثم قال تفاحة.',
    'ابتسم البائع وأهداه نجمة تعلم.',
  ]),
  StoryData('القطار السريع', '🚆', [
    'ركب بدر قطاراً جميلاً.',
    'كان القطار يقول: توت توت.',
    'تعلم بدر كلمة قطار وكلمة Train.',
    'وصل بدر إلى مدينة المركبات.',
  ]),
  StoryData('حديقة الألوان', '🎨', [
    'دخل بدر حديقة فيها زهور كثيرة.',
    'رأى الأحمر والأزرق والأخضر والأصفر.',
    'جمع الألوان في لوحة جميلة.',
    'قال بدر: التعلم يشبه الرسم.',
  ]),
  StoryData('سر الحرف باء', 'ب', [
    'وجد بدر حرف باء على باب صغير.',
    'قال: باء مثل بدر وباب وبطة.',
    'كرر الحرف بصوته الجميل.',
    'فتح الباب ووجد لعبة جديدة.',
  ]),
];

List<LearnItem> get allItems => worlds.expand((w) => w.items).toList();

class BadrShell extends StatefulWidget {
  const BadrShell({super.key});

  @override
  State<BadrShell> createState() => _BadrShellState();
}

class _BadrShellState extends State<BadrShell> {
  static const recorder = MethodChannel('badr.audio/recorder');
  final FlutterTts tts = FlutterTts();
  final AudioPlayer player = AudioPlayer();

  int tab = 0;
  int stars = 0;
  int games = 0;
  final Set<String> learned = {};
  final Set<String> recorded = {};
  bool recording = false;
  String? recordingId;

  @override
  void initState() {
    super.initState();
    _load();
    _prepareVoice();
  }

  Future<void> _prepareVoice() async {
    await tts.setVolume(1);
    await tts.setPitch(1.06);
    await tts.setSpeechRate(0.52);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      stars = prefs.getInt('stars') ?? 0;
      games = prefs.getInt('games') ?? 0;
      learned.addAll(prefs.getStringList('learned') ?? const []);
      recorded.addAll(prefs.getStringList('recorded') ?? const []);
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stars', stars);
    await prefs.setInt('games', games);
    await prefs.setStringList('learned', learned.toList());
    await prefs.setStringList('recorded', recorded.toList());
  }

  Future<String> _recordPath(String id) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/badr_voice_$id.m4a';
  }

  Future<void> speakArabic(LearnItem item) async {
    await tts.stop();
    await player.stop();
    final path = await _recordPath(item.id);
    if (File(path).existsSync()) {
      await player.play(DeviceFileSource(path));
      return;
    }
    await tts.setLanguage('ar-JO');
    await tts.setSpeechRate(0.52);
    await tts.speak('${item.ar}. ${item.hint}');
  }

  Future<void> speakEnglish(LearnItem item) async {
    await tts.stop();
    await player.stop();
    await tts.setLanguage('en-US');
    await tts.setSpeechRate(0.42);
    await tts.speak(item.en);
  }

  Future<void> sayText(String text) async {
    await tts.stop();
    await player.stop();
    await tts.setLanguage('ar-JO');
    await tts.setSpeechRate(0.52);
    await tts.speak(text);
  }

  Future<void> startRecording(LearnItem item) async {
    try {
      final allowed = await recorder.invokeMethod<bool>('ensurePermission') ?? false;
      if (!allowed) {
        _message('اسمح للميكروفون ثم اضغط التسجيل مرة أخرى');
        return;
      }
      final path = await _recordPath(item.id);
      await tts.stop();
      await player.stop();
      final ok = await recorder.invokeMethod<bool>('start', {'path': path}) ?? false;
      if (!ok) {
        _message('تعذر بدء التسجيل');
        return;
      }
      HapticFeedback.mediumImpact();
      setState(() {
        recording = true;
        recordingId = item.id;
      });
      _message('بدأ التسجيل: قل ${item.ar} بوضوح');
    } catch (_) {
      _message('تعذر تشغيل التسجيل على هذا الجهاز');
    }
  }

  Future<void> stopRecording(LearnItem item) async {
    try {
      await recorder.invokeMethod('stop');
      final path = await _recordPath(item.id);
      setState(() {
        recording = false;
        recordingId = null;
        recorded.add(item.id);
        stars += 2;
      });
      await _save();
      _message('تم حفظ صوتك ⭐');
      if (File(path).existsSync()) {
        await player.play(DeviceFileSource(path));
      }
    } catch (_) {
      setState(() {
        recording = false;
        recordingId = null;
      });
      _message('تعذر حفظ التسجيل');
    }
  }

  void markLearned(LearnItem item) {
    if (learned.add(item.id)) {
      setState(() => stars += 1);
      _save();
      _message('أحسنت، تعلمت كلمة جديدة ⭐');
    }
  }

  void winGame() {
    setState(() {
      games += 1;
      stars += 3;
    });
    _save();
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      stars = 0;
      games = 0;
      learned.clear();
      recorded.clear();
      recording = false;
      recordingId = null;
      tab = 0;
    });
    _message('تم تصفير التقدم فقط');
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    tts.stop();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(stars: stars, learned: learned.length, recorded: recorded.length),
      WorldsPage(
        learned: learned,
        recorded: recorded,
        recording: recording,
        recordingId: recordingId,
        onArabic: speakArabic,
        onEnglish: speakEnglish,
        onRecord: startRecording,
        onStop: stopRecording,
        onLearned: markLearned,
      ),
      GamesPage(onWin: winGame, sayText: sayText),
      StoriesPage(sayText: sayText),
      ProgressPage(
        stars: stars,
        learned: learned.length,
        recorded: recorded.length,
        games: games,
        onReset: resetProgress,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: BadrBackground(child: SafeArea(bottom: false, child: pages[tab])),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xee06285a),
          indicatorColor: Colors.white.withOpacity(0.18),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
          ),
        ),
        child: NavigationBar(
          height: 76,
          selectedIndex: tab,
          onDestinationSelected: (value) => setState(() => tab = value),
          destinations: const [
            NavigationDestination(icon: Text('🏰', style: TextStyle(fontSize: 24)), label: 'الرئيسية'),
            NavigationDestination(icon: Text('🗺️', style: TextStyle(fontSize: 24)), label: 'العوالم'),
            NavigationDestination(icon: Text('🎮', style: TextStyle(fontSize: 24)), label: 'الألعاب'),
            NavigationDestination(icon: Text('📖', style: TextStyle(fontSize: 24)), label: 'القصص'),
            NavigationDestination(icon: Text('⭐', style: TextStyle(fontSize: 24)), label: 'تقدمي'),
          ],
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
                colors: [Color(0xff0587e8), Color(0xff5ed4ff), Color(0xffffe38a), Color(0xff42c96d)],
              ),
            ),
          ),
        ),
        const Positioned(top: 26, right: 26, child: Text('☀️', style: TextStyle(fontSize: 52))),
        const Positioned(top: 82, left: 18, child: Text('☁️', style: TextStyle(fontSize: 44))),
        const Positioned(bottom: 100, right: 16, child: Text('🌈', style: TextStyle(fontSize: 72))),
        const Positioned(bottom: 102, left: 18, child: Text('🏡', style: TextStyle(fontSize: 64))),
        child,
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  final int stars;
  final int learned;
  final int recorded;

  const HomePage({super.key, required this.stars, required this.learned, required this.recorded});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        Row(
          children: [
            StatPill('⭐ $stars'),
            const SizedBox(width: 8),
            StatPill('📚 $learned'),
            const SizedBox(width: 8),
            StatPill('🎙️ $recorded'),
          ],
        ),
        const SizedBox(height: 14),
        const HeroCastle(),
        const SizedBox(height: 18),
        const SectionTitle(icon: '✨', title: 'بوابات عالم بدر'),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          physics: const NeverScrollableScrollPhysics(),
          children: worlds.map((world) => WorldPreview(world: world)).toList(),
        ),
        const SizedBox(height: 16),
        const InfoCard(
          emoji: '🎙️',
          title: 'ميزة مميزة',
          text: 'يمكنك تسجيل صوت عربي لكل كلمة، وبعدها يسمع الطفل صوتك بدل صوت الجهاز.',
        ),
      ],
    );
  }
}

class HeroCastle extends StatelessWidget {
  const HeroCastle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xffffd44d), width: 2),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 14))],
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xff063b83), Color(0xff0ea5e9), Color(0xffffd166)],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          Positioned(top: 18, right: 22, child: Text('عالم', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.black38, offset: Offset(0, 4), blurRadius: 8)]))),
          Positioned(top: 78, right: 22, child: Text('بدر', style: TextStyle(fontSize: 78, fontWeight: FontWeight.w900, color: Color(0xffffc531), shadows: [Shadow(color: Colors.white, offset: Offset(0, 4), blurRadius: 0), Shadow(color: Colors.black38, offset: Offset(0, 10), blurRadius: 12)]))),
          Positioned(top: 174, right: 24, child: Text('تعلم • اسمع • سجل • العب', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900))),
          Positioned(left: 28, bottom: 44, child: BadrBear(size: 138)),
          Positioned(left: 12, top: 20, child: Text('⭐', style: TextStyle(fontSize: 42))),
          Positioned(right: 30, bottom: 24, child: Text('🏰', style: TextStyle(fontSize: 72))),
          Positioned(left: 110, bottom: 18, child: Text('🌳', style: TextStyle(fontSize: 58))),
          Positioned(left: 150, top: 28, child: Text('☁️', style: TextStyle(fontSize: 40))),
        ],
      ),
    );
  }
}

class WorldsPage extends StatelessWidget {
  final Set<String> learned;
  final Set<String> recorded;
  final bool recording;
  final String? recordingId;
  final Future<void> Function(LearnItem) onArabic;
  final Future<void> Function(LearnItem) onEnglish;
  final Future<void> Function(LearnItem) onRecord;
  final Future<void> Function(LearnItem) onStop;
  final void Function(LearnItem) onLearned;

  const WorldsPage({
    super.key,
    required this.learned,
    required this.recorded,
    required this.recording,
    required this.recordingId,
    required this.onArabic,
    required this.onEnglish,
    required this.onRecord,
    required this.onStop,
    required this.onLearned,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        const SectionTitle(icon: '🗺️', title: 'اختر عالماً للتعلم'),
        ...worlds.map(
          (world) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorldDetailsPage(
                    world: world,
                    learned: learned,
                    recorded: recorded,
                    recording: recording,
                    recordingId: recordingId,
                    onArabic: onArabic,
                    onEnglish: onEnglish,
                    onRecord: onRecord,
                    onStop: onStop,
                    onLearned: onLearned,
                  ),
                ),
              ),
              child: WorldWideCard(world: world),
            ),
          ),
        ),
      ],
    );
  }
}

class WorldDetailsPage extends StatelessWidget {
  final LearnWorld world;
  final Set<String> learned;
  final Set<String> recorded;
  final bool recording;
  final String? recordingId;
  final Future<void> Function(LearnItem) onArabic;
  final Future<void> Function(LearnItem) onEnglish;
  final Future<void> Function(LearnItem) onRecord;
  final Future<void> Function(LearnItem) onStop;
  final void Function(LearnItem) onLearned;

  const WorldDetailsPage({
    super.key,
    required this.world,
    required this.learned,
    required this.recorded,
    required this.recording,
    required this.recordingId,
    required this.onArabic,
    required this.onEnglish,
    required this.onRecord,
    required this.onStop,
    required this.onLearned,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BadrBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 26),
            children: [
              Row(
                children: [
                  RoundButton(text: 'رجوع', icon: '↩️', onTap: () => Navigator.pop(context)),
                  const Spacer(),
                  StatPill('${world.emoji} ${world.title}'),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.white.withOpacity(0.94),
                  border: Border.all(color: const Color(0xffffd44d), width: 2),
                ),
                child: Row(
                  children: [
                    CircleAvatar(radius: 42, backgroundColor: world.color.withOpacity(0.16), child: Text(world.emoji, style: const TextStyle(fontSize: 46))),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(world.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xff06285a))),
                          const SizedBox(height: 4),
                          Text(world.subtitle, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xff355077))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .82),
                itemCount: world.items.length,
                itemBuilder: (context, index) {
                  final item = world.items[index];
                  return LearnTile(
                    item: item,
                    learned: learned.contains(item.id),
                    recorded: recorded.contains(item.id),
                    color: world.color,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemPage(
                          item: item,
                          color: world.color,
                          recorded: recorded.contains(item.id),
                          learned: learned.contains(item.id),
                          onArabic: onArabic,
                          onEnglish: onEnglish,
                          onRecord: onRecord,
                          onStop: onStop,
                          onLearned: onLearned,
                        ),
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

class ItemPage extends StatelessWidget {
  final LearnItem item;
  final Color color;
  final bool recorded;
  final bool learned;
  final Future<void> Function(LearnItem) onArabic;
  final Future<void> Function(LearnItem) onEnglish;
  final Future<void> Function(LearnItem) onRecord;
  final Future<void> Function(LearnItem) onStop;
  final void Function(LearnItem) onLearned;

  const ItemPage({
    super.key,
    required this.item,
    required this.color,
    required this.recorded,
    required this.learned,
    required this.onArabic,
    required this.onEnglish,
    required this.onRecord,
    required this.onStop,
    required this.onLearned,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BadrBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
            children: [
              Row(children: [RoundButton(text: 'رجوع', icon: '↩️', onTap: () => Navigator.pop(context)), const Spacer(), StatPill(recorded ? '🎙️ صوت محفوظ' : '🔊 نطق الجهاز')]),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  color: Colors.white.withOpacity(.95),
                  border: Border.all(color: const Color(0xffffd44d), width: 2),
                  boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 22, offset: Offset(0, 12))],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 210,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(colors: [color.withOpacity(.28), const Color(0xfffff4bd)]),
                      ),
                      child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 110, fontWeight: FontWeight.w900))),
                    ),
                    const SizedBox(height: 16),
                    Text(item.ar, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Color(0xff06285a))),
                    const SizedBox(height: 4),
                    Directionality(textDirection: TextDirection.ltr, child: Text(item.en, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: color))),
                    const SizedBox(height: 10),
                    Text(item.hint, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xff355077))),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        BigAction(text: 'نطق عربي', icon: '🔊', color: const Color(0xff16a34a), onTap: () => onArabic(item)),
                        BigAction(text: 'English', icon: '🇬🇧', color: const Color(0xff0284c7), onTap: () => onEnglish(item)),
                        BigAction(text: 'تسجيل صوتي', icon: '🎙️', color: const Color(0xffec4899), onTap: () => onRecord(item)),
                        BigAction(text: 'إيقاف وحفظ', icon: '⏹️', color: const Color(0xfff97316), onTap: () => onStop(item)),
                        BigAction(text: learned ? 'تم التعلم' : 'تعلمت', icon: learned ? '✅' : '⭐', color: const Color(0xffeab308), onTap: () => onLearned(item)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              InfoCard(
                emoji: '🐻',
                title: 'نصيحة بدر',
                text: 'سجل الكلمة بصوتك مرة واحدة، وبعدها سيستخدم التطبيق التسجيل بدل نطق الجهاز.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GamesPage extends StatefulWidget {
  final VoidCallback onWin;
  final Future<void> Function(String) sayText;

  const GamesPage({super.key, required this.onWin, required this.sayText});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  final random = Random();
  String game = 'pick';
  late LearnItem answer;
  late List<LearnItem> options;
  int countNumber = 3;
  String countEmoji = '⭐';
  String feedback = '';

  @override
  void initState() {
    super.initState();
    _newQuestion('pick');
  }

  void _newQuestion(String type) {
    final pool = allItems;
    answer = pool[random.nextInt(pool.length)];
    options = [answer];
    while (options.length < 4) {
      final item = pool[random.nextInt(pool.length)];
      if (!options.any((x) => x.id == item.id)) options.add(item);
    }
    options.shuffle(random);
    countNumber = random.nextInt(7) + 2;
    countEmoji = ['⭐', '🍎', '🐻', '🚗', '🎈'][random.nextInt(5)];
    setState(() {
      game = type;
      feedback = '';
    });
    if (type == 'sound') {
      Future.delayed(const Duration(milliseconds: 280), () => widget.sayText(answer.ar));
    }
  }

  void _check(bool ok) {
    if (ok) {
      HapticFeedback.mediumImpact();
      widget.onWin();
      setState(() => feedback = 'أحسنت يا بطل ⭐');
    } else {
      HapticFeedback.lightImpact();
      setState(() => feedback = 'حاول مرة أخرى يا بطل');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        const SectionTitle(icon: '🎮', title: 'مدينة الألعاب'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            GameCard('👀', 'اختر الصورة', 'أين الكلمة؟', const Color(0xff16a34a), () => _newQuestion('pick')),
            GameCard('🔊', 'اسمع واختر', 'اختبار الصوت', const Color(0xff0284c7), () => _newQuestion('sound')),
            GameCard('🔢', 'العد السريع', 'كم العدد؟', const Color(0xffeab308), () => _newQuestion('count')),
            GameCard('🧠', 'ذاكرة بدر', 'لعبة خفيفة', const Color(0xff8b5cf6), () => _newQuestion('memory')),
          ],
        ),
        const SizedBox(height: 14),
        if (game == 'pick') _pickGame(),
        if (game == 'sound') _soundGame(),
        if (game == 'count') _countGame(),
        if (game == 'memory') _memoryGame(),
      ],
    );
  }

  Widget _pickGame() => QuizBox(
        title: 'أين ${answer.ar}؟',
        feedback: feedback,
        onNext: () => _newQuestion('pick'),
        child: optionGrid(showNames: true),
      );

  Widget _soundGame() => QuizBox(
        title: 'اسمع واختر الصورة',
        feedback: feedback,
        onNext: () => _newQuestion('sound'),
        extraButton: RoundButton(text: 'تشغيل الصوت', icon: '🔊', onTap: () => widget.sayText(answer.ar)),
        child: optionGrid(showNames: false),
      );

  Widget _countGame() {
    final opts = <int>{countNumber, countNumber + 1, max(1, countNumber - 1), countNumber + 2}.toList()..shuffle(random);
    return QuizBox(
      title: 'كم عدد الأشياء؟',
      feedback: feedback,
      onNext: () => _newQuestion('count'),
      child: Column(
        children: [
          Text(List.filled(countNumber, countEmoji).join(' '), textAlign: TextAlign.center, style: const TextStyle(fontSize: 34, height: 1.5)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: opts.map((n) => BigAction(text: '$n', icon: '🔢', color: const Color(0xffeab308), onTap: () => _check(n == countNumber))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _memoryGame() => QuizBox(
        title: 'تحدي الذاكرة: اختر ${answer.ar}',
        feedback: feedback,
        onNext: () => _newQuestion('memory'),
        child: optionGrid(showNames: false),
      );

  Widget optionGrid({required bool showNames}) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.25,
      children: options
          .map(
            (item) => GestureDetector(
              onTap: () => _check(item.id == answer.id),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: const Color(0xffeff7ff), border: Border.all(color: const Color(0xffbde7ff), width: 2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w900)),
                    if (showNames) Text(item.ar, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xff06285a))),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class StoriesPage extends StatefulWidget {
  final Future<void> Function(String) sayText;
  const StoriesPage({super.key, required this.sayText});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  int story = 0;
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final s = stories[story];
    final text = s.pages[page];
    final progress = (page + 1) / s.pages.length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        const SectionTitle(icon: '📖', title: 'قصص بدر'),
        SizedBox(
          height: 118,
          child: ListView.separated(
            reverse: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => setState(() {
                story = i;
                page = 0;
              }),
              child: Container(
                width: 170,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: story == i ? const Color(0xff06285a) : Colors.white.withOpacity(.94), border: Border.all(color: const Color(0xffffd44d), width: 2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(stories[i].emoji, style: const TextStyle(fontSize: 32)),
                    Text(stories[i].title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, color: story == i ? Colors.white : const Color(0xff06285a))),
                  ],
                ),
              ),
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemCount: stories.length,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Colors.white.withOpacity(.95), border: Border.all(color: const Color(0xffffd44d), width: 2)),
          child: Column(
            children: [
              LinearProgressIndicator(value: progress, minHeight: 12, borderRadius: BorderRadius.circular(99), backgroundColor: const Color(0xffdbeafe)),
              const SizedBox(height: 16),
              Text(s.emoji, style: const TextStyle(fontSize: 100)),
              Text(s.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xff06285a))),
              const SizedBox(height: 14),
              Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, height: 1.55, fontWeight: FontWeight.w900, color: Color(0xff10213d))),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  BigAction(text: 'اسمع الصفحة', icon: '🔊', color: const Color(0xff16a34a), onTap: () => widget.sayText(text)),
                  BigAction(text: 'السابق', icon: '⬅️', color: const Color(0xff64748b), onTap: page == 0 ? null : () => setState(() => page--)),
                  BigAction(text: page == s.pages.length - 1 ? 'قصة جديدة' : 'التالي', icon: '➡️', color: const Color(0xff0284c7), onTap: () => setState(() {
                        if (page < s.pages.length - 1) {
                          page++;
                        } else {
                          story = (story + 1) % stories.length;
                          page = 0;
                        }
                      })),
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
  final int games;
  final VoidCallback onReset;

  const ProgressPage({super.key, required this.stars, required this.learned, required this.recorded, required this.games, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      children: [
        const SectionTitle(icon: '⭐', title: 'تقدم الطفل'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.15,
          children: [
            ProgressCard('⭐', 'النجوم', stars),
            ProgressCard('📚', 'كلمات تعلمها', learned),
            ProgressCard('🎙️', 'تسجيلات محفوظة', recorded),
            ProgressCard('🎮', 'ألعاب ناجحة', games),
          ],
        ),
        const SizedBox(height: 14),
        const InfoCard(emoji: '🐻', title: 'بدر فخور بك', text: 'كل كلمة تتعلمها وكل تسجيل تحفظه يجعل عالم بدر أجمل.'),
        const SizedBox(height: 14),
        BigAction(text: 'تصفير التقدم', icon: '🧹', color: const Color(0xffef4444), onTap: onReset),
      ],
    );
  }
}

class LearnTile extends StatelessWidget {
  final LearnItem item;
  final bool learned;
  final bool recorded;
  final Color color;
  final VoidCallback onTap;

  const LearnTile({super.key, required this.item, required this.learned, required this.recorded, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), color: Colors.white.withOpacity(.95), border: Border.all(color: const Color(0xffffd44d), width: 2), boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 14, offset: Offset(0, 8))]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(item.ar, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xff06285a))),
            Directionality(textDirection: TextDirection.ltr, child: Text(item.en, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color))),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [if (learned) const Text('✅'), if (recorded) const Padding(padding: EdgeInsets.only(right: 6), child: Text('🎙️'))]),
          ],
        ),
      ),
    );
  }
}

class WorldPreview extends StatelessWidget {
  final LearnWorld world;
  const WorldPreview({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: LinearGradient(colors: [world.color, world.color.withOpacity(.68)]), border: Border.all(color: Colors.white70, width: 2), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 14, offset: Offset(0, 8))]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(world.emoji, style: const TextStyle(fontSize: 48)), const SizedBox(height: 8), Text(world.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)), Text('${world.items.length} كلمات', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))]),
    );
  }
}

class WorldWideCard extends StatelessWidget {
  final LearnWorld world;
  const WorldWideCard({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), gradient: LinearGradient(colors: [world.color, world.color.withOpacity(.72)]), border: Border.all(color: const Color(0xffffd44d), width: 2), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, 10))]),
      child: Row(
        children: [
          CircleAvatar(radius: 40, backgroundColor: Colors.white.withOpacity(.24), child: Text(world.emoji, style: const TextStyle(fontSize: 44))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(world.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)), Text(world.subtitle, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)), const SizedBox(height: 8), Text('${world.items.length} بطاقات تعليمية', style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white))])),
          const Text('ادخل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class QuizBox extends StatelessWidget {
  final String title;
  final String feedback;
  final Widget child;
  final VoidCallback onNext;
  final Widget? extraButton;

  const QuizBox({super.key, required this.title, required this.feedback, required this.child, required this.onNext, this.extraButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white.withOpacity(.95), border: Border.all(color: const Color(0xffffd44d), width: 2)),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xff06285a))),
          if (extraButton != null) Padding(padding: const EdgeInsets.only(top: 10), child: extraButton!),
          const SizedBox(height: 12),
          child,
          if (feedback.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(feedback, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xff16a34a))),
          ],
          const SizedBox(height: 12),
          RoundButton(text: 'سؤال جديد', icon: '🔄', onTap: onNext),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String icon;
  final String title;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const GameCard(this.icon, this.title, this.text, this.color, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: LinearGradient(colors: [color, color.withOpacity(.68)]), border: Border.all(color: Colors.white70, width: 2), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 14, offset: Offset(0, 8))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(icon, style: const TextStyle(fontSize: 42)), const SizedBox(height: 8), Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)), Text(text, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white))]),
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String icon;
  final String title;
  final int value;

  const ProgressCard(this.icon, this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), color: Colors.white.withOpacity(.95), border: Border.all(color: const Color(0xffffd44d), width: 2)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(icon, style: const TextStyle(fontSize: 42)), Text('$value', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xfff59e0b))), Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xff06285a)))]),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String text;

  const InfoCard({super.key, required this.emoji, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), color: Colors.white.withOpacity(.95), border: Border.all(color: const Color(0xffffd44d), width: 2)),
      child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 44)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xff06285a))), Text(text, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xff355077)))]))]),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), color: const Color(0xff06285a), border: Border.all(color: const Color(0xffffd44d), width: 2), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, 8))]),
      child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [Text(icon, style: const TextStyle(fontSize: 24)), const SizedBox(width: 8), Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900))]),
    );
  }
}

class StatPill extends StatelessWidget {
  final String text;
  const StatPill(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.92), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xffffd44d), width: 2)),
      child: Text(text, style: const TextStyle(color: Color(0xff06285a), fontWeight: FontWeight.w900)),
    );
  }
}

class RoundButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback? onTap;

  const RoundButton({super.key, required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(backgroundColor: const Color(0xff06285a), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
      child: Text('$icon $text', style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}

class BigAction extends StatelessWidget {
  final String text;
  final String icon;
  final Color color;
  final VoidCallback? onTap;

  const BigAction({super.key, required this.text, required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Text('$icon $text', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
    );
  }
}

class BadrBear extends StatelessWidget {
  final double size;
  const BadrBear({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(shape: BoxShape.circle, gradient: const RadialGradient(colors: [Color(0xffffd08a), Color(0xffb96b2c), Color(0xff6b3b1c)]), boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 18, offset: Offset(0, 10))]))),
          Positioned(left: size * .08, top: size * .05, child: CircleAvatar(radius: size * .18, backgroundColor: const Color(0xff8b4a22))),
          Positioned(right: size * .08, top: size * .05, child: CircleAvatar(radius: size * .18, backgroundColor: const Color(0xff8b4a22))),
          Positioned(left: size * .29, top: size * .35, child: const Text('●', style: TextStyle(fontSize: 22, color: Color(0xff10213d)))),
          Positioned(right: size * .29, top: size * .35, child: const Text('●', style: TextStyle(fontSize: 22, color: Color(0xff10213d)))),
          Positioned(left: 0, right: 0, top: size * .50, child: const Text('▾\n◡', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, height: .85, fontWeight: FontWeight.w900, color: Color(0xff10213d)))),
        ],
      ),
    );
  }
}
