package com.example.ai_life

import io.flutter.app.FlutterApplication
import com.facebook.stetho.Stetho

class App :FlutterApplication(){
    override fun onCreate() {
        super.onCreate()
        Stetho.initializeWithDefaults(this)
    }
}