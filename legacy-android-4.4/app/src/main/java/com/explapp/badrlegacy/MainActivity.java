package com.explapp.badrlegacy;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PixelFormat;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.os.Build;
import android.os.Bundle;
import android.speech.tts.TextToSpeech;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.Set;

public final class MainActivity extends Activity {
    private static final int MIC_REQUEST=71;
    private static final String PREFS="badr_progress_v2";
    private final Random random=new Random();
    private final Set<String> learned=new HashSet<String>();
    private TextToSpeech tts;
    private boolean ttsReady;
    private MediaRecorder recorder;
    private MediaPlayer player;
    private BadrData.Item pendingRecordItem;
    private String recordingId;
    private long recordingStartedAt;
    private int stars,games;
    private int storyIndex,storyPage;
    private int currentScreen;
    private BadrData.World currentWorld;

    @Override public void onCreate(Bundle state){
        super.onCreate(state);
        loadProgress();
        tts=new TextToSpeech(this,new TextToSpeech.OnInitListener(){
            @Override public void onInit(int status){
                ttsReady=status==TextToSpeech.SUCCESS;
                if(ttsReady){tts.setSpeechRate(.78f);tts.setPitch(1.05f);}
            }
        });
        showHome();
    }

    private void showHome(){
        abandonRecording();
        currentScreen=0;currentWorld=null;
        LinearLayout root=page();
        LinearLayout stats=row();
        stats.addView(pill("النجوم: "+stars),weight());
        stats.addView(gap(6));
        stats.addView(pill("تعلمت: "+learned.size()),weight());
        stats.addView(gap(6));
        stats.addView(pill("الألعاب: "+games),weight());
        root.addView(stats,match());

        IllustrationView hero=new IllustrationView(this);
        hero.setWorldColor(0xff146fb1);
        root.addView(hero,new LinearLayout.LayoutParams(-1,dp(210)));
        TextView title=text("عالم بدر",31,0xff123552,true);title.setGravity(Gravity.CENTER);root.addView(title,top(6));
        TextView sub=text("تعلم • استمع • سجل صوتك • العب",16,0xff486b7b,false);sub.setGravity(Gravity.CENTER);root.addView(sub,match());

        for(final BadrData.World world:BadrData.WORLDS){
            Button b=button(world.title+"\n"+world.subtitle,world.color);
            b.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showWorld(world);}});
            root.addView(b,top(8));
        }
        setPage(root,true);
    }

    private void showWorlds(){
        abandonRecording();
        currentScreen=1;currentWorld=null;
        LinearLayout root=page();root.addView(section("العوالم التعليمية"),match());
        for(final BadrData.World world:BadrData.WORLDS){
            LinearLayout card=row();card.setPadding(dp(10),dp(10),dp(10),dp(10));card.setBackground(round(0xffffffff,18));
            IllustrationView art=new IllustrationView(this);art.setWorldColor(world.color);card.addView(art,new LinearLayout.LayoutParams(dp(112),dp(100)));
            TextView info=text(world.title+"\n"+world.subtitle+"\n"+world.items.size()+" بطاقات",18,world.color,true);info.setGravity(Gravity.CENTER_VERTICAL);card.addView(info,weight());
            card.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showWorld(world);}});
            root.addView(card,top(8));
        }
        setPage(root,true);
    }

    private void showWorld(final BadrData.World world){
        abandonRecording();
        currentScreen=2;currentWorld=world;
        LinearLayout root=page();
        Button back=smallButton("رجوع إلى العوالم",0xff607d8b);back.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showWorlds();}});root.addView(back,match());
        root.addView(section(world.title),top(8));
        for(final BadrData.Item item:world.items){
            LinearLayout card=row();card.setGravity(Gravity.CENTER_VERTICAL);card.setPadding(dp(8),dp(8),dp(8),dp(8));card.setBackground(round(0xffffffff,16));
            IllustrationView art=new IllustrationView(this);art.setItem(item);card.addView(art,new LinearLayout.LayoutParams(dp(105),dp(105)));
            String mark=learned.contains(item.id)?"  ✓":"";
            TextView info=text(item.ar+mark+"\n"+item.en+"\n"+item.hint,17,0xff173956,true);info.setPadding(dp(10),0,dp(10),0);card.addView(info,weight());
            card.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showItem(item);}});
            root.addView(card,top(7));
        }
        setPage(root,false);
    }

    private void showItem(final BadrData.Item item){
        currentScreen=3;
        LinearLayout root=page();
        Button back=smallButton("رجوع",0xff607d8b);back.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showWorld(findWorld(item.world));}});root.addView(back,match());
        IllustrationView art=new IllustrationView(this);art.setItem(item);root.addView(art,new LinearLayout.LayoutParams(-1,dp(270)));
        TextView name=text(item.ar+"  —  "+item.en,28,0xff123552,true);name.setGravity(Gravity.CENTER);root.addView(name,top(8));
        TextView hint=text(item.hint,19,0xff35566b,true);hint.setGravity(Gravity.CENTER);root.addView(hint,top(4));

        LinearLayout speech=row();
        Button ar=button("استمع بالعربية",0xff2e9d58);ar.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){speak(item.ar+". "+item.hint,new Locale("ar","JO"));markLearned(item);}});
        Button en=button("Listen in English",0xff1687c3);en.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){speak(item.en,Locale.US);markLearned(item);}});
        speech.addView(ar,weight());speech.addView(gap(7));speech.addView(en,weight());root.addView(speech,top(10));

        final File voice=voiceFile(item.id);
        Button record=button(recordingId!=null&&recordingId.equals(item.id)?"إيقاف وحفظ التسجيل":"سجل صوتك",0xffd14b75);
        record.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){if(recordingId!=null)stopRecording(item);else startRecording(item);}});
        root.addView(record,top(8));
        if(voice.exists()){
            LinearLayout voiceActions=row();
            Button play=button("تشغيل صوتي",0xff8b5bb5);play.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){playVoice(voice);}});
            Button delete=button("حذف التسجيل",0xffc84f4f);delete.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){confirmDeleteVoice(item);}});
            voiceActions.addView(play,weight());voiceActions.addView(gap(7));voiceActions.addView(delete,weight());
            root.addView(voiceActions,top(7));
        }
        Button learnedButton=button(learned.contains(item.id)?"تم تعلم هذه الكلمة ✓":"تعلمت هذه الكلمة",0xffef9c28);
        learnedButton.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){markLearned(item);showItem(item);}});
        root.addView(learnedButton,top(7));setPage(root,false);
    }

    private void showGames(){
        abandonRecording();
        currentScreen=4;currentWorld=null;
        LinearLayout root=page();root.addView(section("ألعاب بدر"),match());
        TextView intro=text("كل إجابة صحيحة تمنحك ثلاث نجوم",17,0xff35566b,true);intro.setGravity(Gravity.CENTER);root.addView(intro,top(5));
        Button names=button("اختر الاسم الصحيح",0xff2e9d58);names.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showQuiz(false,false);}});root.addView(names,top(10));
        Button sounds=button("اسمع ثم اختر",0xff1687c3);sounds.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showQuiz(true,false);}});root.addView(sounds,top(8));
        Button counting=button("لعبة الأرقام",0xffd8a60d);counting.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showQuiz(false,true);}});root.addView(counting,top(8));
        setPage(root,true);
    }

    private void showQuiz(final boolean audio,final boolean numbers){
        abandonRecording();
        currentScreen=5;
        final List<BadrData.Item> pool=new ArrayList<BadrData.Item>();
        if(numbers)pool.addAll(findWorld("numbers").items);else pool.addAll(BadrData.allItems());
        final BadrData.Item target=pool.get(random.nextInt(pool.size()));
        final ArrayList<BadrData.Item> options=new ArrayList<BadrData.Item>();options.add(target);
        while(options.size()<4){BadrData.Item x=pool.get(random.nextInt(pool.size()));if(!contains(options,x.id))options.add(x);}
        Collections.shuffle(options);

        final LinearLayout root=page();
        Button back=smallButton("رجوع للألعاب",0xff607d8b);back.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showGames();}});root.addView(back,match());
        root.addView(section(audio?"استمع واختر الصورة":"اختر الاسم الصحيح"),top(8));
        if(!audio){IllustrationView art=new IllustrationView(this);art.setItem(target);root.addView(art,new LinearLayout.LayoutParams(-1,dp(210)));}
        final Button listen=button(audio?"استمع ثم اختر الرسم":"استمع إلى الكلمة",0xff1687c3);
        listen.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){speak(audio?"أين "+target.ar:target.ar,new Locale("ar","JO"));}});
        root.addView(listen,top(8));
        final LinearLayout grid=new LinearLayout(this);grid.setOrientation(LinearLayout.VERTICAL);
        final boolean[] locked={false};
        LinearLayout optionRow=null;int optionIndex=0;
        for(final BadrData.Item option:options){
            if(optionIndex%2==0){optionRow=row();grid.addView(optionRow,new LinearLayout.LayoutParams(-1,audio?dp(158):dp(66)));}
            final View answer=audio?quizPicture(option):button(option.ar,option.color);
            answer.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){answerQuiz(root,v,locked,option,target,audio,numbers);}});
            LinearLayout.LayoutParams optionParams=new LinearLayout.LayoutParams(0,-1,1f);optionParams.setMargins(dp(4),dp(4),dp(4),dp(4));optionRow.addView(answer,optionParams);optionIndex++;
        }
        root.addView(grid,top(8));setPage(root,false);
        if(audio)listen.performClick();
    }

    private View quizPicture(BadrData.Item item){
        LinearLayout card=new LinearLayout(this);card.setOrientation(LinearLayout.VERTICAL);card.setGravity(Gravity.CENTER);card.setPadding(dp(5),dp(5),dp(5),dp(5));card.setBackground(round(0xffffffff,16));card.setContentDescription(item.ar);
        IllustrationView art=new IllustrationView(this);art.setItem(item);card.addView(art,new LinearLayout.LayoutParams(-1,0,1f));
        TextView hint=text("اضغط على الرسم",12,0xff486b7b,true);hint.setGravity(Gravity.CENTER);card.addView(hint,match());
        if(Build.VERSION.SDK_INT>=21)card.setElevation(dp(2));
        return card;
    }

    private void answerQuiz(final LinearLayout root,final View clicked,final boolean[] locked,BadrData.Item option,final BadrData.Item target,final boolean audio,final boolean numbers){
        if(locked[0])return;
        if(!option.id.equals(target.id)){
            toast("حاول مرة أخرى");speak("حاول مرة أخرى",new Locale("ar","JO"));
            clicked.animate().translationX(dp(7)).setDuration(70).withEndAction(new Runnable(){@Override public void run(){clicked.animate().translationX(-dp(7)).setDuration(70).withEndAction(new Runnable(){@Override public void run(){clicked.animate().translationX(0).setDuration(70).start();}}).start();}}).start();
            return;
        }
        locked[0]=true;stars+=3;games++;learned.add(target.id);saveProgress();clicked.setBackground(round(0xffdff7e7,16));
        TextView feedback=text("أحسنت! إجابة صحيحة  •  +3 نجوم",17,0xff237a47,true);feedback.setGravity(Gravity.CENTER);feedback.setPadding(dp(10),dp(13),dp(10),dp(13));feedback.setBackground(round(0xffe7f8ed,14));root.addView(feedback,top(9));
        Button next=button("السؤال التالي",0xff1687c3);next.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){showQuiz(audio,numbers);}});root.addView(next,top(8));
        speak("أحسنت",new Locale("ar","JO"));
    }

    private void showStories(){
        abandonRecording();
        currentScreen=6;currentWorld=null;
        final BadrData.Story story=BadrData.STORIES.get(storyIndex);
        LinearLayout root=page();root.addView(section("قصص بدر"),match());
        LinearLayout choices=row();
        for(int i=0;i<BadrData.STORIES.size();i++){final int index=i;Button b=smallButton(String.valueOf(i+1),i==storyIndex?0xffd14b75:0xff607d8b);b.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){storyIndex=index;storyPage=0;showStories();}});choices.addView(b,weight());}
        root.addView(choices,top(7));
        TextView title=text(story.title,25,0xff123552,true);title.setGravity(Gravity.CENTER);root.addView(title,top(12));
        IllustrationView art=new IllustrationView(this);art.setWorldColor(0xff8358c7);root.addView(art,new LinearLayout.LayoutParams(-1,dp(190)));
        final String page=story.pages[storyPage];
        TextView body=text(page,23,0xff203f50,true);body.setGravity(Gravity.CENTER);body.setPadding(dp(12),dp(18),dp(12),dp(18));body.setBackground(round(0xffffffff,18));root.addView(body,top(9));
        Button hear=button("استمع إلى الصفحة",0xff2e9d58);hear.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){speak(page,new Locale("ar","JO"));}});root.addView(hear,top(8));
        LinearLayout move=row();
        Button prev=button("السابق",0xff607d8b);prev.setEnabled(storyPage>0);prev.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){storyPage--;showStories();}});
        Button next=button(storyPage==story.pages.length-1?"قصة جديدة":"التالي",0xff1687c3);next.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){if(storyPage<story.pages.length-1)storyPage++;else{storyIndex=(storyIndex+1)%BadrData.STORIES.size();storyPage=0;}showStories();}});
        move.addView(prev,weight());move.addView(gap(7));move.addView(next,weight());root.addView(move,top(8));setPage(root,true);
    }

    private void showProgress(){
        abandonRecording();
        currentScreen=7;currentWorld=null;
        LinearLayout root=page();root.addView(section("تقدم الطفل"),match());
        TextView completion=text("أنجزت "+learned.size()+" من "+BadrData.allItems().size()+" بطاقة تعليمية",17,0xff123552,true);completion.setGravity(Gravity.CENTER);root.addView(completion,top(12));
        ProgressBar progress=new ProgressBar(this,null,android.R.attr.progressBarStyleHorizontal);progress.setMax(BadrData.allItems().size());progress.setProgress(learned.size());progress.setMinimumHeight(dp(18));root.addView(progress,top(6));
        root.addView(progressCard("النجوم التي جمعتها",stars,0xffffb22e),top(8));
        root.addView(progressCard("الكلمات التي تعلمتها",learned.size(),0xff2e9d58),top(8));
        root.addView(progressCard("الألعاب الناجحة",games,0xff1687c3),top(8));
        root.addView(progressCard("تسجيلات صوتية",countRecordings(),0xffd14b75),top(8));
        Button reset=button("تصفير التقدم",0xffd34a4a);reset.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){confirmReset();}});root.addView(reset,top(12));
        setPage(root,true);
    }

    private void speak(String value,Locale locale){
        if(!ttsReady){toast("محرك النطق غير جاهز على الجهاز");return;}
        int result=tts.setLanguage(locale);
        if(result==TextToSpeech.LANG_MISSING_DATA||result==TextToSpeech.LANG_NOT_SUPPORTED){toast("هذا الصوت غير مثبت في إعدادات النطق");return;}
        tts.stop();
        if(Build.VERSION.SDK_INT>=21)tts.speak(value,TextToSpeech.QUEUE_FLUSH,null,"badr");
        else tts.speak(value,TextToSpeech.QUEUE_FLUSH,null);
    }

    private void markLearned(BadrData.Item item){if(learned.add(item.id)){stars++;saveProgress();toast("أحسنت! تعلمت كلمة جديدة");}}

    @android.annotation.SuppressLint("MissingPermission")
    private void startRecording(final BadrData.Item item){
        if(Build.VERSION.SDK_INT>=23&&checkSelfPermission(Manifest.permission.RECORD_AUDIO)!=PackageManager.PERMISSION_GRANTED){pendingRecordItem=item;requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO},MIC_REQUEST);return;}
        releaseRecorder();
        try{
            File file=voiceFile(item.id);recorder=new MediaRecorder();recorder.setAudioSource(MediaRecorder.AudioSource.MIC);recorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);recorder.setAudioEncodingBitRate(64000);recorder.setAudioSamplingRate(22050);recorder.setMaxDuration(15000);recorder.setMaxFileSize(1024L*1024L);recorder.setOutputFile(file.getAbsolutePath());recorder.setOnInfoListener(new MediaRecorder.OnInfoListener(){@Override public void onInfo(MediaRecorder mr,int what,int extra){if(recordingId!=null&&recordingId.equals(item.id))stopRecording(item);}});recorder.prepare();recorder.start();recordingId=item.id;recordingStartedAt=System.currentTimeMillis();toast("بدأ التسجيل: قل "+item.ar+" بوضوح");showItem(item);
        }catch(Exception e){releaseRecorder();recordingId=null;toast("تعذر بدء التسجيل على هذا الجهاز");}
    }

    private void stopRecording(BadrData.Item item){
        boolean longEnough=System.currentTimeMillis()-recordingStartedAt>=700;
        try{
            if(recorder!=null)recorder.stop();File file=voiceFile(item.id);if(!longEnough||!file.exists()||file.length()<256)throw new IllegalStateException("short recording");
            boolean rewarded=getSharedPreferences(PREFS,MODE_PRIVATE).getBoolean("record_reward_"+item.id,false);
            if(!rewarded){stars+=2;getSharedPreferences(PREFS,MODE_PRIVATE).edit().putBoolean("record_reward_"+item.id,true).apply();toast("تم حفظ صوتك +2 نجوم");}
            else toast("تم تحديث تسجيلك بنجاح");
            saveProgress();
        }catch(Exception e){voiceFile(item.id).delete();toast("التسجيل قصير جدًا، حاول مرة أخرى");}
        releaseRecorder();recordingId=null;showItem(item);
    }

    private void playVoice(File file){
        releasePlayer();try{player=new MediaPlayer();player.setDataSource(file.getAbsolutePath());player.setOnCompletionListener(new MediaPlayer.OnCompletionListener(){@Override public void onCompletion(MediaPlayer mp){releasePlayer();}});player.prepare();player.start();}catch(Exception e){releasePlayer();toast("تعذر تشغيل التسجيل");}
    }

    @Override public void onRequestPermissionsResult(int requestCode,String[] permissions,int[] results){
        super.onRequestPermissionsResult(requestCode,permissions,results);
        if(requestCode==MIC_REQUEST&&results.length>0&&results[0]==PackageManager.PERMISSION_GRANTED&&pendingRecordItem!=null){BadrData.Item item=pendingRecordItem;pendingRecordItem=null;startRecording(item);}else if(requestCode==MIC_REQUEST){pendingRecordItem=null;toast("صلاحية الميكروفون مطلوبة للتسجيل");}
    }

    private void confirmDeleteVoice(final BadrData.Item item){
        new AlertDialog.Builder(this).setTitle("حذف التسجيل؟").setMessage("سيُحذف تسجيل هذه الكلمة فقط، وسيبقى تقدم التعلم محفوظاً.")
                .setPositiveButton("حذف",new DialogInterface.OnClickListener(){@Override public void onClick(DialogInterface dialog,int which){releasePlayer();if(voiceFile(item.id).delete())toast("تم حذف التسجيل");else toast("لا يوجد تسجيل للحذف");showItem(item);}})
                .setNegativeButton("إلغاء",null).show();
    }

    private void confirmReset(){
        new AlertDialog.Builder(this).setTitle("تصفير التقدم").setMessage("هل تريد حذف النجوم والكلمات والألعاب والتسجيلات؟").setPositiveButton("حذف",new DialogInterface.OnClickListener(){@Override public void onClick(DialogInterface d,int w){learned.clear();stars=games=0;for(BadrData.Item i:BadrData.allItems())voiceFile(i.id).delete();getSharedPreferences(PREFS,MODE_PRIVATE).edit().clear().apply();saveProgress();showProgress();}}).setNegativeButton("إلغاء",null).show();
    }

    private LinearLayout nav(){
        LinearLayout nav=row();
        String[] labels={"الرئيسية","العوالم","الألعاب","القصص","تقدمي"};
        int active=currentScreen==0?0:currentScreen==1?1:currentScreen==4?2:currentScreen==6?3:4;
        nav.setPadding(dp(4),dp(5),dp(4),dp(5));nav.setBackgroundColor(Color.WHITE);
        if(Build.VERSION.SDK_INT>=21)nav.setElevation(dp(7));
        for(int i=0;i<labels.length;i++){
            final int index=i;boolean selected=i==active;Button b=new Button(this);b.setText(labels[i]);b.setTextSize(10);b.setTextColor(selected?0xff075f91:0xff526b78);b.setTypeface(Typeface.DEFAULT,selected?Typeface.BOLD:Typeface.NORMAL);b.setAllCaps(false);b.setGravity(Gravity.CENTER);b.setPadding(dp(1),dp(2),dp(1),dp(2));
            Drawable glyph=new NavGlyph(i,selected?0xff0c83bd:0xff718792,dp(24));b.setCompoundDrawables(null,glyph,null,null);b.setCompoundDrawablePadding(dp(2));b.setBackground(selected?round(0xffdff4ff,14):round(Color.TRANSPARENT,14));
            b.setContentDescription(labels[i]+(selected?"، الصفحة الحالية":""));
            b.setOnClickListener(new View.OnClickListener(){@Override public void onClick(View v){if(index==0)showHome();else if(index==1)showWorlds();else if(index==2)showGames();else if(index==3)showStories();else showProgress();}});nav.addView(b,new LinearLayout.LayoutParams(0,dp(60),1f));
        }
        return nav;
    }

    private void setPage(LinearLayout body,boolean mainNavigation){LinearLayout shell=new LinearLayout(this);shell.setOrientation(LinearLayout.VERTICAL);shell.setBackgroundColor(0xffeaf7fb);ScrollView scroll=new ScrollView(this);scroll.setFillViewport(true);scroll.setOverScrollMode(View.OVER_SCROLL_IF_CONTENT_SCROLLS);scroll.addView(body);shell.addView(scroll,new LinearLayout.LayoutParams(-1,0,1f));if(mainNavigation)shell.addView(nav(),new LinearLayout.LayoutParams(-1,dp(70)));setContentView(shell);body.setAlpha(0f);body.setTranslationY(dp(7));body.animate().alpha(1f).translationY(0).setDuration(180).start();}
    private LinearLayout page(){LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);root.setPadding(dp(12),dp(12),dp(12),dp(20));if(Build.VERSION.SDK_INT>=17)root.setLayoutDirection(View.LAYOUT_DIRECTION_RTL);return root;}
    private LinearLayout row(){LinearLayout r=new LinearLayout(this);r.setOrientation(LinearLayout.HORIZONTAL);r.setGravity(Gravity.CENTER);return r;}
    private TextView section(String value){TextView v=text(value,25,Color.WHITE,true);v.setGravity(Gravity.CENTER);v.setPadding(dp(10),dp(12),dp(10),dp(12));v.setBackground(round(0xff123b65,18));return v;}
    private TextView pill(String value){TextView v=text(value,13,0xff123552,true);v.setGravity(Gravity.CENTER);v.setPadding(dp(4),dp(9),dp(4),dp(9));v.setBackground(round(0xffffffff,50));return v;}
    private TextView progressCard(String title,int value,int color){TextView v=text(value+"\n"+title,22,color,true);v.setGravity(Gravity.CENTER);v.setPadding(dp(10),dp(20),dp(10),dp(20));v.setBackground(round(0xffffffff,18));return v;}
    private TextView text(String value,int size,int color,boolean bold){TextView v=new TextView(this);v.setText(value);v.setTextSize(size);v.setTextColor(color);v.setTypeface(Typeface.DEFAULT,bold?Typeface.BOLD:Typeface.NORMAL);return v;}
    private Button button(String value,int color){Button b=new Button(this);b.setText(value);b.setTextSize(16);b.setTextColor(Color.WHITE);b.setAllCaps(false);b.setTypeface(Typeface.DEFAULT,Typeface.BOLD);b.setGravity(Gravity.CENTER);b.setMinHeight(dp(56));b.setBackground(round(color,16));return b;}
    private Button smallButton(String value,int color){Button b=button(value,color);b.setTextSize(12);b.setMinHeight(dp(44));b.setPadding(dp(3),dp(3),dp(3),dp(3));return b;}
    private GradientDrawable round(int color,int radius){GradientDrawable d=new GradientDrawable();d.setColor(color);d.setCornerRadius(dp(radius));return d;}
    private View gap(int size){View v=new View(this);v.setLayoutParams(new LinearLayout.LayoutParams(dp(size),1));return v;}
    private LinearLayout.LayoutParams weight(){return new LinearLayout.LayoutParams(0,-2,1f);}
    private LinearLayout.LayoutParams match(){return new LinearLayout.LayoutParams(-1,-2);}
    private LinearLayout.LayoutParams top(int m){LinearLayout.LayoutParams p=match();p.topMargin=dp(m);return p;}
    private int dp(int n){return(int)(n*getResources().getDisplayMetrics().density+.5f);}
    private void toast(String value){Toast.makeText(this,value,Toast.LENGTH_SHORT).show();}
    private boolean contains(List<BadrData.Item> items,String id){for(BadrData.Item i:items)if(i.id.equals(id))return true;return false;}
    private BadrData.World findWorld(String id){for(BadrData.World w:BadrData.WORLDS)if(w.id.equals(id))return w;return BadrData.WORLDS.get(0);}
    private File voiceFile(String id){return new File(getFilesDir(),"badr_voice_"+id+".m4a");}
    private int countRecordings(){int n=0;for(BadrData.Item i:BadrData.allItems())if(voiceFile(i.id).exists())n++;return n;}
    private void loadProgress(){SharedPreferences p=getSharedPreferences(PREFS,MODE_PRIVATE);stars=p.getInt("stars",0);games=p.getInt("games",0);Set<String> saved=p.getStringSet("learned",null);if(saved!=null)learned.addAll(saved);}
    private void saveProgress(){getSharedPreferences(PREFS,MODE_PRIVATE).edit().putInt("stars",stars).putInt("games",games).putStringSet("learned",new HashSet<String>(learned)).apply();}
    private void releaseRecorder(){if(recorder!=null){try{recorder.reset();}catch(Exception ignored){}recorder.release();recorder=null;}}
    private void releasePlayer(){if(player!=null){try{player.stop();}catch(Exception ignored){}player.release();player=null;}}
    private void abandonRecording(){if(recordingId==null)return;releaseRecorder();voiceFile(recordingId).delete();recordingId=null;recordingStartedAt=0;toast("تم إلغاء التسجيل غير المحفوظ");}

    private static final class NavGlyph extends Drawable{
        private final Paint p=new Paint(Paint.ANTI_ALIAS_FLAG);private final Path path=new Path();private final int type,size;
        NavGlyph(int type,int color,int size){this.type=type;this.size=size;p.setColor(color);p.setStyle(Paint.Style.STROKE);p.setStrokeWidth(Math.max(2f,size*.085f));p.setStrokeCap(Paint.Cap.ROUND);p.setStrokeJoin(Paint.Join.ROUND);setBounds(0,0,size,size);}
        @Override public void draw(Canvas c){RectF b=new RectF(getBounds());float l=b.left,t=b.top,w=b.width(),h=b.height();path.reset();p.setStyle(Paint.Style.STROKE);
            if(type==0){c.drawLine(l+w*.18f,t+h*.48f,l+w*.5f,t+h*.17f,p);c.drawLine(l+w*.5f,t+h*.17f,l+w*.82f,t+h*.48f,p);c.drawRoundRect(new RectF(l+w*.25f,t+h*.43f,l+w*.75f,t+h*.86f),w*.06f,w*.06f,p);c.drawLine(l+w*.46f,t+h*.86f,l+w*.46f,t+h*.63f,p);c.drawLine(l+w*.46f,t+h*.63f,l+w*.62f,t+h*.63f,p);c.drawLine(l+w*.62f,t+h*.63f,l+w*.62f,t+h*.86f,p);}
            else if(type==1){c.drawRoundRect(new RectF(l+w*.12f,t+h*.18f,l+w*.45f,t+h*.82f),w*.05f,w*.05f,p);c.drawRoundRect(new RectF(l+w*.55f,t+h*.18f,l+w*.88f,t+h*.82f),w*.05f,w*.05f,p);c.drawLine(l+w*.5f,t+h*.25f,l+w*.5f,t+h*.76f,p);c.drawLine(l+w*.21f,t+h*.34f,l+w*.36f,t+h*.34f,p);c.drawLine(l+w*.64f,t+h*.34f,l+w*.79f,t+h*.34f,p);}
            else if(type==2){c.drawRoundRect(new RectF(l+w*.13f,t+h*.27f,l+w*.87f,t+h*.78f),w*.14f,w*.14f,p);c.drawLine(l+w*.30f,t+h*.52f,l+w*.46f,t+h*.52f,p);c.drawLine(l+w*.38f,t+h*.44f,l+w*.38f,t+h*.60f,p);c.drawCircle(l+w*.65f,t+h*.46f,w*.035f,p);c.drawCircle(l+w*.75f,t+h*.58f,w*.035f,p);c.drawLine(l+w*.35f,t+h*.27f,l+w*.43f,t+h*.14f,p);c.drawLine(l+w*.65f,t+h*.27f,l+w*.57f,t+h*.14f,p);}
            else if(type==3){path.moveTo(l+w*.14f,t+h*.22f);path.quadTo(l+w*.36f,t+h*.15f,l+w*.5f,t+h*.31f);path.quadTo(l+w*.64f,t+h*.15f,l+w*.86f,t+h*.22f);path.lineTo(l+w*.86f,t+h*.78f);path.quadTo(l+w*.65f,t+h*.72f,l+w*.5f,t+h*.86f);path.quadTo(l+w*.35f,t+h*.72f,l+w*.14f,t+h*.78f);path.close();c.drawPath(path,p);c.drawLine(l+w*.5f,t+h*.31f,l+w*.5f,t+h*.86f,p);}
            else{for(int i=0;i<10;i++){double a=-Math.PI/2+i*Math.PI/5;float r=i%2==0?w*.38f:w*.18f,x=l+w*.5f+(float)Math.cos(a)*r,y=t+h*.5f+(float)Math.sin(a)*r;if(i==0)path.moveTo(x,y);else path.lineTo(x,y);}path.close();c.drawPath(path,p);c.drawCircle(l+w*.5f,t+h*.5f,w*.07f,p);}
        }
        @Override public void setAlpha(int a){p.setAlpha(a);}@Override public void setColorFilter(ColorFilter f){p.setColorFilter(f);}@Override public int getOpacity(){return PixelFormat.TRANSLUCENT;}@Override public int getIntrinsicWidth(){return size;}@Override public int getIntrinsicHeight(){return size;}
    }

    @Override public void onBackPressed(){if(currentScreen==0){super.onBackPressed();return;}if(currentScreen==1)showHome();else if(currentScreen==2)showWorlds();else if(currentScreen==3&&currentWorld!=null)showWorld(currentWorld);else showHome();}
    @Override protected void onPause(){abandonRecording();releasePlayer();if(tts!=null)tts.stop();super.onPause();}
    @Override protected void onDestroy(){releaseRecorder();releasePlayer();if(tts!=null){tts.stop();tts.shutdown();}super.onDestroy();}
}
