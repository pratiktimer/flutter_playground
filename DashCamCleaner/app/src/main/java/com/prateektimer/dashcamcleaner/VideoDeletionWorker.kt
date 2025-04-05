package com.prateektimer.dashcamcleaner

import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.documentfile.provider.DocumentFile
import androidx.work.*
import java.util.Calendar
import java.util.Date
import java.util.concurrent.TimeUnit

class VideoDeletionWorker(
    context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {

    override fun doWork(): Result {
        val folderUriString = inputData.getString("folderUri") ?: return Result.failure()
        val durationMonths = inputData.getInt("durationMonths", 3)

        // ✅ Load user-selected base date from SharedPreferences
        val sharedPreferences = applicationContext.getSharedPreferences("DashCamCleanerPrefs", Context.MODE_PRIVATE)
        val selectedDateMillis = sharedPreferences.getLong("deletionDate", -1L)

        if (selectedDateMillis == -1L) {
            Log.e("VideoDeletionWorker", "Missing selectedDate in SharedPreferences")
            return Result.failure()
        }

        // 👇 Subtract durationMonths from selected date to get cutoff
        val calendar = Calendar.getInstance().apply {
            timeInMillis = selectedDateMillis
            add(Calendar.MONTH, -durationMonths)
        }
        val deletionCutoff = calendar.timeInMillis

        Log.d("VideoDeletionWorker", "Cutoff date: $deletionCutoff (${Date(deletionCutoff)})")

        return try {
            val folderUri = Uri.parse(folderUriString)
            val documentFile = DocumentFile.fromTreeUri(applicationContext, folderUri)

            if (documentFile != null && documentFile.isDirectory) {
                documentFile.listFiles().forEach { file ->
                    val name = file.name ?: return@forEach
                    val lastModified = file.lastModified()

                    if (isDashcamVideo(name)) {
                        Log.d("VideoDeletionWorker", "Checking: $name (Modified: $lastModified)")

                        if (lastModified > 0 && lastModified < deletionCutoff) {
                            Log.d("VideoDeletionWorker", "Deleting file: $name")
                            file.delete()
                        }
                    }
                }
            }

            Result.success()
        } catch (e: Exception) {
            Log.e("VideoDeletionWorker", "Error during deletion", e)
            Result.failure()
        }
    }

    private fun isDashcamVideo(fileName: String?): Boolean {
        if (fileName.isNullOrBlank()) return false
        val supportedFormats = listOf(".mp4", ".mov", ".avi", ".ts", ".mkv")
        return supportedFormats.any { fileName.lowercase().endsWith(it) }
    }
}


    fun isDashcamVideo(fileName: String?): Boolean {
        if (fileName.isNullOrBlank()) return false

        val supportedFormats = listOf(".mp4", ".mov", ".avi", ".ts", ".mkv")
        return supportedFormats.any { fileName.lowercase().endsWith(it) }
    }

//    private fun scheduleNextDeletion(context: Context, folderUri: String, durationMonths: Int) {
//        val nextDeletionDate = Calendar.getInstance().apply {
//            add(Calendar.MONTH, durationMonths)
//        }.timeInMillis
//
//        // Save next deletion date in SharedPreferences
//        val sharedPreferences =
//            context.getSharedPreferences("DashCamCleanerPrefs", Context.MODE_PRIVATE)
//        sharedPreferences.edit().putLong("deletionDate", nextDeletionDate).apply()
//
//        val workRequest = OneTimeWorkRequestBuilder<VideoDeletionWorker>()
//            .setInitialDelay(nextDeletionDate - System.currentTimeMillis(), TimeUnit.MILLISECONDS)
//            .setInputData(
//                workDataOf(
//                    "folderUri" to folderUri,
//                    "deletionDate" to nextDeletionDate,
//                    "durationMonths" to durationMonths
//                )
//            )
//            .build()
//
//        WorkManager.getInstance(context).enqueueUniqueWork(
//            "VideoDeletionWork",
//            ExistingWorkPolicy.REPLACE,
//            workRequest
//        )
//
//        Log.d("VideoDeletionWorker", "Scheduled next deletion for: $nextDeletionDate")
//    }
