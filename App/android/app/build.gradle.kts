plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.freud.constellation.freud"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.freud.constellation.freud"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    packaging {
        resources.excludes.addAll(
            listOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE"
            )
        )
        pickFirsts.addAll(
            listOf(
                // 关键：解决 aosl 重复
                "lib/arm64-v8a/libaosl.so",
                "lib/armeabi-v7a/libaosl.so",
                "lib/x86/libaosl.so",
                "lib/x86_64/libaosl.so",

                // 声网其他库兼容
                "lib/arm64-v8a/libagora-rtm-sdk.so",
                "lib/armeabi-v7a/libagora-rtm-sdk.so",
                "lib/arm64-v8a/libagora-rtc-sdk.so",
                "lib/armeabi-v7a/libagora-rtc-sdk.so",
            )
        )
    }
}

flutter {
    source = "../.."
}
