package com.explapp.badrlegacy;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.media.AudioManager;
import android.media.ToneGenerator;
import android.os.Bundle;
import android.os.Handler;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.TextView;

import java.util.WeakHashMap;

/**
 * Lightweight sound coordinator for the Android 4.4 edition only.
 * It keeps the original final MainActivity untouched and instruments its views at runtime.
 */
public class SoundApplication extends Application implements Application.ActivityLifecycleCallbacks {
    private final Handler handler = new Handler();
    private final WeakHashMap<View, Boolean> instrumented = new WeakHashMap<View, Boolean>();
    private ToneGenerator tones;
    private SharedPreferences preferences;
    private Activity currentActivity;
    private String lastSnapshot = "";
    private long lastSoundAt;

    @Override public void onCreate() {
        super.onCreate();
        preferences = getSharedPreferences("legacy_sound", Context.MODE_PRIVATE);
        tones = new ToneGenerator(AudioManager.STREAM_MUSIC, 58);
        registerActivityLifecycleCallbacks(this);
    }

    @Override public void onActivityResumed(final Activity activity) {
        currentActivity = activity;
        lastSnapshot = "";
        final View root = activity.getWindow().getDecorView();
        instrumentTree(root);
        root.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override public void onGlobalLayout() {
                if (currentActivity == activity) instrumentTree(root);
            }
        });
        handler.removeCallbacks(statusWatcher);
        handler.post(statusWatcher);
    }

    @Override public void onActivityPaused(Activity activity) {
        if (currentActivity == activity) {
            currentActivity = null;
            handler.removeCallbacks(statusWatcher);
        }
    }

    private void instrumentTree(View view) {
        if (view == null || view.getVisibility() != View.VISIBLE) return;
        if ((view.isClickable() || view.isLongClickable()) && !instrumented.containsKey(view)) {
            instrumented.put(view, Boolean.TRUE);
            view.setSoundEffectsEnabled(false);
            view.setOnTouchListener(new View.OnTouchListener() {
                private float downX;
                private float downY;

                @Override public boolean onTouch(View target, MotionEvent event) {
                    if (event.getAction() == MotionEvent.ACTION_DOWN) {
                        downX = event.getRawX();
                        downY = event.getRawY();
                    } else if (event.getAction() == MotionEvent.ACTION_UP
                            && Math.abs(event.getRawX() - downX) < 20f
                            && Math.abs(event.getRawY() - downY) < 20f) {
                        String label = target instanceof TextView
                                ? ((TextView) target).getText().toString() : "";
                        playForLabel(label);
                    }
                    return false;
                }
            });
        }
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) instrumentTree(group.getChildAt(i));
        }
    }

    private void playForLabel(String label) {
        if (containsAny(label, "رجوع", "العودة", "إغلاق")) {
            play(ToneGenerator.TONE_PROP_BEEP2, 80);
        } else if (containsAny(label, "حذف", "إلغاء", "إيقاف")) {
            play(ToneGenerator.TONE_PROP_NACK, 115);
        } else if (containsAny(label, "استمع", "Listen", "تشغيل صوتي")) {
            play(ToneGenerator.TONE_DTMF_6, 75);
        } else if (containsAny(label, "سجل", "حفظ", "تعلمت")) {
            play(ToneGenerator.TONE_PROP_ACK, 115);
        } else if (containsAny(label, "السؤال التالي", "ابدأ", "اختر", "لعبة")) {
            play(ToneGenerator.TONE_DTMF_5, 70);
        } else {
            play(ToneGenerator.TONE_PROP_BEEP, 55);
        }
    }

    private final Runnable statusWatcher = new Runnable() {
        @Override public void run() {
            Activity activity = currentActivity;
            if (activity == null || tones == null) return;
            String snapshot = collectText(activity.getWindow().getDecorView());
            if (!snapshot.equals(lastSnapshot)) {
                if (containsAny(snapshot, "أحسنت! إجابة صحيحة", "+3 نجوم")) {
                    play(ToneGenerator.TONE_CDMA_ALERT_CALL_GUARD, 360);
                } else if (containsAny(snapshot, "تم تعلم هذه الكلمة", "تم الحفظ")) {
                    play(ToneGenerator.TONE_PROP_ACK, 130);
                } else if (containsAny(snapshot, "إيقاف وحفظ التسجيل")) {
                    play(ToneGenerator.TONE_CDMA_CONFIRM, 90);
                }
                lastSnapshot = snapshot;
            }
            handler.postDelayed(this, 280L);
        }
    };

    private String collectText(View view) {
        StringBuilder builder = new StringBuilder();
        appendText(view, builder);
        return builder.toString();
    }

    private void appendText(View view, StringBuilder builder) {
        if (view == null || view.getVisibility() != View.VISIBLE) return;
        if (view instanceof TextView) builder.append('|').append(((TextView) view).getText());
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) appendText(group.getChildAt(i), builder);
        }
    }

    private void play(int tone, int durationMs) {
        if (tones == null || !preferences.getBoolean("enabled", true)) return;
        long now = System.currentTimeMillis();
        if (now - lastSoundAt < 65L) return;
        lastSoundAt = now;
        tones.startTone(tone, durationMs);
    }

    private boolean containsAny(String value, String... words) {
        for (String word : words) if (value.contains(word)) return true;
        return false;
    }

    @Override public void onActivityCreated(Activity activity, Bundle state) {}
    @Override public void onActivityStarted(Activity activity) {}
    @Override public void onActivityStopped(Activity activity) {}
    @Override public void onActivitySaveInstanceState(Activity activity, Bundle state) {}
    @Override public void onActivityDestroyed(Activity activity) {}

    @Override public void onTerminate() {
        handler.removeCallbacksAndMessages(null);
        if (tones != null) {
            tones.release();
            tones = null;
        }
        super.onTerminate();
    }
}
