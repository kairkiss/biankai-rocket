package com.follow.clash.common

import android.content.ComponentName

object Components {
    const val PACKAGE_NAME = "com.biankai.rocket"
    private const val APP_COMPONENT_PACKAGE_NAME = "com.follow.clash"

    val MAIN_ACTIVITY =
        ComponentName(GlobalState.packageName, "$APP_COMPONENT_PACKAGE_NAME.MainActivity")

    val TEMP_ACTIVITY =
        ComponentName(GlobalState.packageName, "$APP_COMPONENT_PACKAGE_NAME.TempActivity")

    val BROADCAST_RECEIVER =
        ComponentName(GlobalState.packageName, "$APP_COMPONENT_PACKAGE_NAME.BroadcastReceiver")
}
