En el android manifest.xml se encuentra las 2 apis, una que sirvio para el mapa, otra para la deteccion de lugares en el mundo.

Una modificacion se tiene que realizar dentro del archivo:
C:\Users\"Usuaria"\AppData\Local\Pub\Cache\hosted\pub.dev\google_api_headers-1.6.0\android\build.gradle

en el apartado de android se tiene que agregar el namespace y el kotlinOptions:


android {
    compileSdkVersion 32

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }
    defaultConfig {
        minSdkVersion 16
    }

    namespace 'io.github.zeshuaro.google_api_headers'

    kotlinOptions {
        jvmTarget = '1.8'  // Usar 1.8 en lugar de 21
    }
}

La aplicacion solo esta disponible para ANDROID
