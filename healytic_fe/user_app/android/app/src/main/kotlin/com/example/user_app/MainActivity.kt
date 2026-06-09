package com.example.user_app

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "healytics/firebase_config"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isConfigured" -> result.success(hasFirebaseConfig())
                else -> result.notImplemented()
            }
        }
    }

    private fun hasFirebaseConfig(): Boolean {
        val appIdResId = resources.getIdentifier("google_app_id", "string", packageName)
        if (appIdResId == 0) {
            return false
        }

        return runCatching { resources.getString(appIdResId).isNotBlank() }
            .getOrDefault(false)
    }
}
