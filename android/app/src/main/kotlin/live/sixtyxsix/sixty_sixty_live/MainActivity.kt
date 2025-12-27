package live.sixtyxsix.sixty_sixty_live

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "sixty_sixty_live/dnd",
        ).setMethodCallHandler { call, result ->
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                when (call.method) {
                    "hasPolicyAccess" -> result.success(false)
                    "requestPolicyAccess" -> result.success(false)
                    "getInterruptionFilter" -> result.success(null)
                    "setInterruptionFilter" -> result.success(null)
                    else -> result.notImplemented()
                }
                return@setMethodCallHandler
            }

            val manager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            when (call.method) {
                "hasPolicyAccess" -> result.success(
                    manager.isNotificationPolicyAccessGranted,
                )
                "requestPolicyAccess" -> {
                    val intent =
                        Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    result.success(manager.isNotificationPolicyAccessGranted)
                }
                "getInterruptionFilter" -> result.success(
                    manager.currentInterruptionFilter,
                )
                "setInterruptionFilter" -> {
                    val filter = call.argument<Int>("filter")
                    if (filter == null) {
                        result.error("invalid_args", "Missing filter", null)
                        return@setMethodCallHandler
                    }
                    if (!manager.isNotificationPolicyAccessGranted) {
                        result.error(
                            "no_access",
                            "Notification policy access not granted",
                            null,
                        )
                        return@setMethodCallHandler
                    }
                    try {
                        manager.setInterruptionFilter(filter)
                        result.success(null)
                    } catch (error: SecurityException) {
                        result.error("security", error.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
