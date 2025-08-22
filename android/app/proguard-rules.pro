# Razorpay SDK – prevent it from being removed by R8
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep ProGuard annotations (used in Razorpay SDK)
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# Keep annotations in general
-keepattributes *Annotation*
