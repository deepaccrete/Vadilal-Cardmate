allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
//////////////////// 🔧 ADD THIS FIX BLOCK BELOW ////////////////////
//
//subprojects {
//    afterEvaluate { project ->
//        if (project.name.contains("camera") ||
//            project.name.contains("image_picker") ||
//            project.name.contains("path_provider") ||
//            project.name.contains("flutter_plugin_android_lifecycle")) {
//            project.tasks.matching { it.name.contains("generateDebugUnitTestConfig") }.all {
//                it.enabled = false
//            }
//        }
//    }
//}
