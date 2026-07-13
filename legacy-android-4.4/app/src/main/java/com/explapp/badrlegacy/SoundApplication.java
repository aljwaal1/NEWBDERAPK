package com.explapp.badrlegacy;

import android.app.Activity;
import android.app.Application;
import android.media.AudioManager;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;

/** Enables lightweight native click feedback across the Android 4.4 app only. */
public class SoundApplication extends Application implements Application.ActivityLifecycleCallbacks {
    @Override public void onCreate() {
        super.onCreate();
        registerActivityLifecycleCallbacks(this);
        AudioManager audio = (AudioManager) getSystemService(AUDIO_SERVICE);
        if (audio != null) audio.loadSoundEffects();
    }

    @Override public void onActivityResumed(final Activity activity) {
        final View root = activity.getWindow().getDecorView();
        enableSounds(root);
        root.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override public void onGlobalLayout() {
                enableSounds(root);
            }
        });
    }

    private void enableSounds(View view) {
        if (view == null) return;
        if (view.isClickable() || view.isLongClickable()) view.setSoundEffectsEnabled(true);
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) enableSounds(group.getChildAt(i));
        }
    }

    @Override public void onActivityCreated(Activity activity, Bundle state) {}
    @Override public void onActivityStarted(Activity activity) {}
    @Override public void onActivityPaused(Activity activity) {}
    @Override public void onActivityStopped(Activity activity) {}
    @Override public void onActivitySaveInstanceState(Activity activity, Bundle state) {}
    @Override public void onActivityDestroyed(Activity activity) {}
}
