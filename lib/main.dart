
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const BadrApp());

class Word {
  final String id, emoji, ar, en, note;
  const Word(this.id, this.emoji, this.ar, this.en, this.note);
}

class World {
  final String id, title, emoji, colorText;
  final Color color;
  final List<Word> words;
  const World(this.id, this.title, this.emoji, this.colorText, this.color, this.words);
}

const worlds = [
  World('animals','غابة الحيوانات','🦁','تعلم الحيوانات وسجل صوتك',Color(0xff22c55e),[
    Word('lion','🦁','أسد','Lion','الأسد قوي ويعيش في الغابة'),
    Word('tiger','🐯','نمر','Tiger','النمر سريع وله خطوط جميلة'),
    Word('elephant','🐘','فيل','Elephant','الفيل كبير وله خرطوم طويل'),
    Word('bear','🐻','دب','Bear','بدر هو الدب الصديق'),
    Word('rabbit','🐰','أرنب','Rabbit','الأرنب سريع ويحب الجزر'),
    Word('fish','🐟','سمكة','Fish','السمكة تعيش في الماء'),
  ]),
  World('food','سوق الفواكه','🍎','فواكه وطعام وكلمات سهلة',Color(0xffff8a18),[
    Word('apple','🍎','تفاحة','Apple','التفاحة فاكهة مفيدة'),
    Word('banana','🍌','موز','Banana','الموز طري ولذيذ'),
    Word('orange','🍊','برتقال','Orange','البرتقال مليء بالعصير'),
    Word('grapes','🍇','عنب','Grapes','العنب حبات صغيرة جميلة'),
    Word('watermelon','🍉','بطيخ','Watermelon','البطيخ منعش في الصيف'),
  ]),
  World('cars','مدينة المركبات','🚗','سيارات وقطارات وطائرات',Color(0xff0ea5e9),[
    Word('car','🚗','سيارة','Car','السيارة تسير على الطريق'),
    Word('bus','🚌','حافلة','Bus','الحافلة تحمل ركابا كثيرين'),
    Word('train','🚆','قطار','Train','القطار يسير على السكة'),
    Word('plane','✈️','طائرة','Airplane','الطائرة تطير في السماء'),
    Word('rocket','🚀','صاروخ','Rocket','الصاروخ يصعد إلى الفضاء'),
  ]),
  World('letters','جزيرة الحروف','🔤','حروف عربية وإنجليزية منفصلة',Color(0xff8b5cf6),[
    Word('alef','أ','ألف','A','ألف مثل أسد'),
    Word('baa','ب','باء','B','باء مثل بدر'),
    Word('taa','ت','تاء','T','تاء مثل تفاحة'),
    Word('jeem','ج','جيم','J','جيم مثل جمل'),
    Word('seen','س','سين','S','سين مثل سمكة'),
  ]),
];

const stories = [
  ['🐻','بدر في الغابة','خرج بدر إلى الغابة الجميلة.','رأى الأسد والنمر والزرافة.','سجل بدر كلمة أسد بصوته.','جمع بدر نجمة جديدة.'],
  ['🍎','بدر في السوق','ذهب بدر إلى سوق الفواكه.','تعلم كلمة تفاحة وموز.','قال بدر Apple بصوت واضح.','ثم لعب لعبة الاختيار.'],
  ['✈️','بدر والطائرة','رأى بدر طائرة في السماء.','ضغط زر English.','سمع كلمة Airplane.','ثم سجل كلمة طائرة بالعربي.'],
];

class BadrApp extends StatelessWidget {
  const BadrApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عالم بدر',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Arial'),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterTts tts = FlutterTts();
  final AudioRecorder rec = AudioRecorder();
  final AudioPlayer player = AudioPlayer();
  int tab = 0, stars = 0, games = 0;
  final Set<String> learned = {}, recorded = {};
  bool recording = false;
  String? recordingId;

  @override
  void initState() {
    super.initState();
    load();
    warmSound();
  }

  Future<void> warmSound() async {
    await tts.setVolume(1);
    await tts.setLanguage('ar-JO');
    await tts.setSpeechRate(.55);
    await tts.speak(' ');
    await tts.stop();
  }

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      stars = p.getInt('stars') ?? 0;
      games = p.getInt('games') ?? 0;
      learned.addAll(p.getStringList('learned') ?? []);
      recorded.addAll(p.getStringList('recorded') ?? []);
    });
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('stars', stars);
    await p.setInt('games', games);
    await p.setStringList('learned', learned.toList());
    await p.setStringList('recorded', recorded.toList());
  }

  Future<String> recPath(String id) async {
    final d = await getApplicationDocumentsDirectory();
    return '${d.path}/badr_$id.m4a';
  }

  Future<void> arSpeak(Word w) async {
    final p = await recPath(w.id);
    await tts.stop();
    await player.stop();
    if (File(p).existsSync()) {
      await player.play(DeviceFileSource(p));
    } else {
      await tts.setLanguage('ar-JO');
      await tts.setSpeechRate(.58);
      await tts.setPitch(1.06);
      await tts.speak('${w.ar}. ${w.note}');
    }
  }

  Future<void> enSpeak(Word w) async {
    await player.stop();
    await tts.stop();
    await tts.setLanguage('en-US');
    await tts.setSpeechRate(.45);
    await tts.speak(w.en);
  }

  Future<void> startRecord(Word w) async {
    if (!await rec.hasPermission()) {
      msg('اسمح للتطبيق باستخدام الميكروفون');
      return;
    }
    final p = await recPath(w.id);
    await player.stop();
    await tts.stop();
    await rec.start(const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 96000, sampleRate: 44100), path: p);
    setState(() { recording = true; recordingId = w.id; });
    HapticFeedback.mediumImpact();
  }

  Future<void> stopRecord(Word w) async {
    await rec.stop();
    setState(() {
      recording = false;
      recordingId = null;
      recorded.add(w.id);
      stars += 2;
    });
    await save();
    msg('تم حفظ التسجيل العربي ⭐');
    final p = await recPath(w.id);
    if (File(p).existsSync()) await player.play(DeviceFileSource(p));
  }

  void doneWord(Word w) {
    if (learned.add(w.id)) {
      setState(() => stars++);
      save();
      msg('أحسنت ⭐');
    }
  }

  void msg(String s) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), duration: const Duration(seconds: 2)));
  }

  @override
  void dispose() {
    rec.dispose();
    player.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MainMap(stars: stars, learned: learned.length, recorded: recorded.length, open: (w) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => WorldPage(
          world: w,
          arSpeak: arSpeak,
          enSpeak: enSpeak,
          startRecord: startRecord,
          stopRecord: stopRecord,
          doneWord: doneWord,
          isRecording: () => recording,
          recordingId: () => recordingId,
          recorded: recorded,
        )));
      }),
      GamePage(arSpeak: arSpeak, enSpeak: enSpeak, win: () { setState(() { games++; stars += 3; }); save(); }),
      StoryPage(tts: tts),
      StatsPage(stars: stars, learned: learned.length, recorded: recorded.length, games: games),
    ];
    return Scaffold(
      extendBody: true,
      body: Sky(child: SafeArea(bottom: false, child: pages[tab])),
      bottomNavigationBar: NavigationBar(
        height: 76,
        backgroundColor: const Color(0xee052455),
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Text('🗺️', style: TextStyle(fontSize: 22)), label: 'العوالم'),
          NavigationDestination(icon: Text('🎮', style: TextStyle(fontSize: 22)), label: 'الألعاب'),
          NavigationDestination(icon: Text('📖', style: TextStyle(fontSize: 22)), label: 'القصص'),
          NavigationDestination(icon: Text('⭐', style: TextStyle(fontSize: 22)), label: 'تقدمي'),
        ],
      ),
    );
  }
}

class Sky extends StatelessWidget {
  final Widget child;
  const Sky({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Stack(children: [
    const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [Color(0xff0787e8),Color(0xff65d8ff),Color(0xffffe28a),Color(0xff43cf70)])))),
    const Positioned(top: 40, right: 30, child: Text('☀️', style: TextStyle(fontSize: 54))),
    const Positioned(top: 80, left: 20, child: Text('☁️', style: TextStyle(fontSize: 46))),
    const Positioned(bottom: 90, right: 12, child: Text('🏡', style: TextStyle(fontSize: 68))),
    child,
  ]);
}

class MainMap extends StatelessWidget {
  final int stars, learned, recorded;
  final void Function(World) open;
  const MainMap({super.key, required this.stars, required this.learned, required this.recorded, required this.open});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(14,12,14,100), children: [
    Row(children: [ChipX('⭐ $stars'), const SizedBox(width: 8), ChipX('🎙️ $recorded'), const Spacer(), ChipX('📚 $learned')]),
    const SizedBox(height: 12),
    CardX(child: SizedBox(height: 260, child: Stack(children: [
      const Positioned(left: 18, top: 34, child: Bear(size: 140)),
      const Positioned(right: 14, bottom: 28, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BigText('عالم', 48, Color(0xffffb703)),
        BigText('بدر', 66, Color(0xff0ea5e9)),
        Text('اسمع • سجل • العب', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xff052455))),
      ])),
    ]))),
    const TitleX('🗺️', 'خريطة العوالم'),
    SizedBox(height: 188, child: ListView.separated(scrollDirection: Axis.horizontal, reverse: true, itemCount: worlds.length, separatorBuilder: (_,__)=>const SizedBox(width: 12), itemBuilder: (_,i)=>WorldCard(worlds[i], () => open(worlds[i])))),
    const SizedBox(height: 14),
    const TitleX('✨', 'ابدأ التعلم'),
    GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: worlds.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12), itemBuilder: (_,i)=>WorldTile(worlds[i], () => open(worlds[i]))),
  ]);
}

class WorldPage extends StatefulWidget {
  final World world;
  final Future<void> Function(Word) arSpeak, enSpeak, startRecord, stopRecord;
  final void Function(Word) doneWord;
  final bool Function() isRecording;
  final String? Function() recordingId;
  final Set<String> recorded;
  const WorldPage({super.key, required this.world, required this.arSpeak, required this.enSpeak, required this.startRecord, required this.stopRecord, required this.doneWord, required this.isRecording, required this.recordingId, required this.recorded});
  @override
  State<WorldPage> createState() => _WorldPageState();
}

class _WorldPageState extends State<WorldPage> {
  int i = 0;
  Word get w => widget.world.words[i];
  @override
  Widget build(BuildContext context) {
    final recThis = widget.isRecording() && widget.recordingId() == w.id;
    final hasRec = widget.recorded.contains(w.id);
    return Scaffold(backgroundColor: Colors.transparent, body: Sky(child: SafeArea(child: ListView(padding: const EdgeInsets.all(14), children: [
      Row(children: [IconButton.filledTonal(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back)), const Spacer(), ChipX(widget.world.title)]),
      const SizedBox(height: 10),
      CardX(child: Column(children: [
        Container(height: 210, alignment: Alignment.center, decoration: BoxDecoration(gradient: LinearGradient(colors: [widget.world.color.withAlpha(95), const Color(0xfffff4bd), const Color(0xffa7f3d0)]), borderRadius: BorderRadius.circular(28)), child: Text(w.emoji, style: const TextStyle(fontSize: 96))),
        const SizedBox(height: 14),
        WordBox('العربية ${hasRec ? "🎙️" : ""}', w.ar, TextDirection.rtl, const Color(0xfffff7d8)),
        const SizedBox(height: 10),
        WordBox('English', w.en, TextDirection.ltr, const Color(0xffeff7ff)),
        const SizedBox(height: 10),
        Text(w.note, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w800, color: Color(0xff10213d))),
      ])),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: Btn('اسمع العربي', hasRec ? 'تشغيل تسجيلك' : 'نطق عربي', Icons.volume_up, const Color(0xff20c46b), () => widget.arSpeak(w))),
        const SizedBox(width: 10),
        Expanded(child: Btn('English', 'en-US', Icons.record_voice_over, const Color(0xff0b7fe8), () => widget.enSpeak(w))),
      ]),
      const SizedBox(height: 10),
      Btn(recThis ? 'إيقاف التسجيل وحفظه' : 'تسجيل صوتك بالعربي', recThis ? 'اضغط للحفظ' : 'زر تسجيل عربي حقيقي', recThis ? Icons.stop_circle : Icons.mic, recThis ? const Color(0xffe11d48) : const Color(0xff7c3aed), () => recThis ? widget.stopRecord(w) : widget.startRecord(w)),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: SmallBtn('السابق', const Color(0xff0b7fe8), () => setState(()=> i = (i - 1 + widget.world.words.length) % widget.world.words.length))),
        const SizedBox(width: 8),
        Expanded(child: SmallBtn('تعلمتها ⭐', const Color(0xff20c46b), () => widget.doneWord(w))),
        const SizedBox(width: 8),
        Expanded(child: SmallBtn('التالي', const Color(0xffff8a18), () => setState(()=> i = (i + 1) % widget.world.words.length))),
      ]),
      const SizedBox(height: 12),
      SizedBox(height: 76, child: ListView.separated(scrollDirection: Axis.horizontal, reverse: true, itemCount: widget.world.words.length, separatorBuilder: (_,__)=>const SizedBox(width: 8), itemBuilder: (_,x)=>GestureDetector(onTap: ()=>setState(()=>i=x), child: Container(width: 72, alignment: Alignment.center, decoration: BoxDecoration(color: x==i ? const Color(0xffffd35a) : Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xff0b7fe8), width: 2)), child: Text(widget.world.words[x].emoji, style: const TextStyle(fontSize: 32)))))),
    ]))));
  }
}

class GamePage extends StatefulWidget {
  final Future<void> Function(Word) arSpeak, enSpeak;
  final VoidCallback win;
  const GamePage({super.key, required this.arSpeak, required this.enSpeak, required this.win});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Word q; late List<Word> opts;
  @override void initState(){super.initState(); next();}
  void next(){ final all=worlds.expand((e)=>e.words).toList()..shuffle(); q=all.first; opts=[q,...all.where((e)=>e.id!=q.id).take(3)]..shuffle(); setState((){}); }
  @override Widget build(BuildContext context)=>ListView(padding: const EdgeInsets.fromLTRB(14,12,14,100), children:[
    const TitleX('🎮','اسمع واختر'),
    CardX(child: Column(children:[Text(q.emoji, style: const TextStyle(fontSize: 90)), Text(q.en, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 34, color: Color(0xff0755b2), fontWeight: FontWeight.w900)), const SizedBox(height: 10), Row(children:[Expanded(child: Btn('عربي','تسجيل/نطق',Icons.volume_up,const Color(0xff20c46b),()=>widget.arSpeak(q))), const SizedBox(width:8), Expanded(child: Btn('English','Listen',Icons.hearing,const Color(0xff0b7fe8),()=>widget.enSpeak(q)))])])),
    const SizedBox(height: 12),
    ...opts.map((o)=>Padding(padding: const EdgeInsets.only(bottom: 9), child: FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xff10213d), padding: const EdgeInsets.all(15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xffffd35a), width: 2))), onPressed: (){ if(o.id==q.id){widget.win(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('صحيح ⭐')));} else {ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حاول مرة أخرى')));} }, child: Text('${o.emoji}  ${o.ar}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))))),
    SmallBtn('سؤال جديد ✨', const Color(0xffff8a18), next),
  ]);
}

class StoryPage extends StatefulWidget {
  final FlutterTts tts;
  const StoryPage({super.key, required this.tts});
  @override State<StoryPage> createState()=>_StoryPageState();
}
class _StoryPageState extends State<StoryPage>{
  int s=0,l=2;
  Future<void> speak(String t) async { await widget.tts.stop(); await widget.tts.setLanguage('ar-JO'); await widget.tts.setSpeechRate(.56); await widget.tts.speak(t); }
  @override Widget build(BuildContext context){ final st=stories[s]; return ListView(padding: const EdgeInsets.fromLTRB(14,12,14,100), children:[
    const TitleX('📖','قصص بدر'),
    CardX(child: Column(children:[Text(st[0], style: const TextStyle(fontSize: 76)), Text(st[1], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xff10213d))), const SizedBox(height: 12), Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xfffff7d8), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xffffd35a), width: 2)), child: Text(st[l], textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, height: 1.6, fontWeight: FontWeight.w900))), const SizedBox(height: 12), Btn('اسمع السطر','نطق عربي',Icons.volume_up,const Color(0xff20c46b),()=>speak(st[l])), const SizedBox(height: 10), Row(children:[Expanded(child: SmallBtn('السابق', const Color(0xff0b7fe8), ()=>setState(()=>l=max(2,l-1)))), const SizedBox(width:8), Expanded(child: SmallBtn('التالي', const Color(0xffff8a18), ()=>setState(()=>l=min(st.length-1,l+1))))])])),
    const SizedBox(height: 12),
    ...List.generate(stories.length, (i)=>Padding(padding: const EdgeInsets.only(bottom: 8), child: FilledButton(onPressed: ()=>setState((){s=i;l=2;}), child: Text('${stories[i][0]} ${stories[i][1]}')))),
  ]);}
}

class StatsPage extends StatelessWidget {
  final int stars, learned, recorded, games;
  const StatsPage({super.key, required this.stars, required this.learned, required this.recorded, required this.games});
  @override Widget build(BuildContext context)=>ListView(padding: const EdgeInsets.fromLTRB(14,12,14,100), children:[
    const TitleX('⭐','تقدمي'),
    CardX(child: Column(children:[const Bear(size: 130), RowX('⭐','النجوم','$stars'), RowX('📚','الكلمات','$learned'), RowX('🎙️','التسجيلات العربية','$recorded'), RowX('🎮','الألعاب','$games'), const SizedBox(height: 10), const Text('التسجيل العربي محفوظ داخل الجهاز ويعمل بسرعة من ملف صوتي، وليس انتظار نطق آلي.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, height: 1.5))])),
  ]);
}

class ChipX extends StatelessWidget{final String t; const ChipX(this.t,{super.key}); @override Widget build(BuildContext c)=>Container(padding: const EdgeInsets.symmetric(horizontal:13,vertical:8), decoration: BoxDecoration(color: const Color(0xee073b7a), borderRadius: BorderRadius.circular(99), border: Border.all(color: const Color(0xffffd35a), width: 2)), child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)));}
class CardX extends StatelessWidget{final Widget child; const CardX({super.key, required this.child}); @override Widget build(BuildContext c)=>Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: const LinearGradient(colors:[Color(0xeeffffff), Color(0xddeff8ff)]), borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xffffd35a), width: 2), boxShadow: const [BoxShadow(color: Color(0x33042356), blurRadius: 22, offset: Offset(0,14))]), child: child);}
class TitleX extends StatelessWidget{final String i,t; const TitleX(this.i,this.t,{super.key}); @override Widget build(BuildContext c)=>Container(margin: const EdgeInsets.only(bottom:12, top: 10), padding: const EdgeInsets.symmetric(vertical:10), decoration: BoxDecoration(color: const Color(0xee052455), borderRadius: BorderRadius.circular(99), border: Border.all(color: const Color(0xffffd35a), width: 2)), child: Center(child: Text('$i  $t', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900))));}
class BigText extends StatelessWidget{final String t; final double s; final Color c; const BigText(this.t,this.s,this.c,{super.key}); @override Widget build(BuildContext x)=>Text(t, style: TextStyle(fontSize:s, height:.9, fontWeight: FontWeight.w900, color:c, shadows: const [Shadow(offset: Offset(0,3), color: Colors.white), Shadow(offset: Offset(0,7), color: Color(0xaa043763))]));}
class Bear extends StatelessWidget{final double size; const Bear({super.key, required this.size}); @override Widget build(BuildContext c)=>SizedBox(width:size,height:size,child:Stack(alignment:Alignment.center,children:[Positioned(top:3,left:size*.12,child:Circle(size*.28,const Color(0xff9a5a29))),Positioned(top:3,right:size*.12,child:Circle(size*.28,const Color(0xff9a5a29))),Circle(size*.92,const Color(0xffb96b2c)),Circle(size*.65,const Color(0xfff0b66b)),Positioned(top:size*.39,left:size*.34,child:Circle(size*.075,const Color(0xff11203a))),Positioned(top:size*.39,right:size*.34,child:Circle(size*.075,const Color(0xff11203a))),Positioned(top:size*.52,child:Circle(size*.11,const Color(0xff11203a)))]));}
class Circle extends StatelessWidget{final double s; final Color c; const Circle(this.s,this.c,{super.key}); @override Widget build(BuildContext x)=>Container(width:s,height:s,decoration:BoxDecoration(shape:BoxShape.circle,color:c,boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0,5))]));}
class WorldCard extends StatelessWidget{final World w; final VoidCallback tap; const WorldCard(this.w,this.tap,{super.key}); @override Widget build(BuildContext c)=>SizedBox(width:170, child: GestureDetector(onTap:tap, child: CardX(child: Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(w.emoji, style: const TextStyle(fontSize:48)), Text(w.title, textAlign: TextAlign.center, style: const TextStyle(fontSize:18, fontWeight:FontWeight.w900, color: Color(0xff10213d))), Text('${w.words.length} كلمات', style: const TextStyle(color: Color(0xff0755b2), fontWeight: FontWeight.w900))]))));}
class WorldTile extends StatelessWidget{final World w; final VoidCallback tap; const WorldTile(this.w,this.tap,{super.key}); @override Widget build(BuildContext c)=>GestureDetector(onTap:tap, child: CardX(child: Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(w.emoji, style: const TextStyle(fontSize:42)), Text(w.title, textAlign: TextAlign.center, style: const TextStyle(fontSize:18, fontWeight: FontWeight.w900, color: Color(0xff10213d))), const SizedBox(height:5), Text(w.colorText, textAlign: TextAlign.center, maxLines:2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize:12, fontWeight: FontWeight.w700, color: Color(0xff355077)))])));}
class WordBox extends StatelessWidget{final String l,v; final TextDirection d; final Color c; const WordBox(this.l,this.v,this.d,this.c,{super.key}); @override Widget build(BuildContext x)=>Container(width:double.infinity,padding: const EdgeInsets.all(14), decoration: BoxDecoration(color:c, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xffffd35a), width:2)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(l, style: const TextStyle(color: Color(0xff0755b2), fontWeight: FontWeight.w900)), Text(v, textDirection:d, style: const TextStyle(fontSize:32, fontWeight: FontWeight.w900, color: Color(0xff10213d)))]));}
class Btn extends StatelessWidget{final String a,b; final IconData ic; final Color c; final VoidCallback tap; const Btn(this.a,this.b,this.ic,this.c,this.tap,{super.key}); @override Widget build(BuildContext x)=>InkWell(onTap:tap, borderRadius: BorderRadius.circular(22), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: LinearGradient(colors:[c,c.withAlpha(210)]), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white70, width:2)), child: Row(children:[Icon(ic,color:Colors.white,size:28), const SizedBox(width:8), Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(a, style: const TextStyle(color:Colors.white,fontWeight:FontWeight.w900,fontSize:15)), Text(b, style: const TextStyle(color:Colors.white70,fontWeight:FontWeight.w800,fontSize:12))]))])));}
class SmallBtn extends StatelessWidget{final String t; final Color c; final VoidCallback tap; const SmallBtn(this.t,this.c,this.tap,{super.key}); @override Widget build(BuildContext x)=>FilledButton(style: FilledButton.styleFrom(backgroundColor:c, padding: const EdgeInsets.symmetric(vertical:13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), onPressed: tap, child: Text(t, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)));}
class RowX extends StatelessWidget{final String i,t,v; const RowX(this.i,this.t,this.v,{super.key}); @override Widget build(BuildContext c)=>Container(margin: const EdgeInsets.only(top:10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xffeff7ff), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xffbde7ff), width:2)), child: Row(children:[Text(i, style: const TextStyle(fontSize:28)), const SizedBox(width:10), Expanded(child:Text(t, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xff10213d)))), Text(v, style: const TextStyle(fontSize:22, fontWeight: FontWeight.w900, color: Color(0xff0755b2)))]));}
