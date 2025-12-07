apply plugin: 'com.android.application'
apply plugin: 'com.google.gms.google-services' // أضف هذا

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.2.0')
    implementation 'com.google.firebase:firebase-auth'
}
