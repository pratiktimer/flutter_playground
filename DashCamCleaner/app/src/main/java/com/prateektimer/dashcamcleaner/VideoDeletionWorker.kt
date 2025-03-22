package com.prateektimer.dashcamcleaner

import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.documentfile.provider.DocumentFile
import androidx.work.*
import java.util.Calendar
import java.util.concurrent.TimeUnit

class VideoDeletionWorker(
    context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {

    override fun doWork(): Result {
        val folderUriString = inputData.getString("folderUri") ?: return Result.failure()
        val deletionDate = inputData.getLong("deletionDate", 0L)
        val durationMonths = inputData.getInt("durationMonths", 3) // Default to 3 months

        Log.d("VideoDeletionWorker", "Starting deletion with URI: $folderUriString")

        return try {
            val folderUri = Uri.parse(folderUriString)
            val documentFile = DocumentFile.fromTreeUri(applicationContext, folderUri)

            if (documentFile != null && documentFile.isDirectory) {
                documentFile.listFiles().forEach { file ->
                    if (isDashcamVideo(file.name)) {
                        if (file.lastModified() < deletionDate) {
                            Log.d("VideoDeletionWorker", "Deleting file: ${file.name}")
                            file.delete()
                        }
                    }
                }
            }

            // ✅ Schedule the next deletion
            scheduleNextDeletion(applicationContext, folderUriString, durationMonths)

            Result.success()
        } catch (e: Exception) {
            Log.e("VideoDeletionWorker", "Error during deletion", e)
            Result.failure()
        }
    }

    fun isDashcamVideo(fileName: String?): Boolean {
        if (fileName.isNullOrBlank()) return false

        val supportedFormats = listOf(".mp4", ".mov", ".avi", ".ts", ".mkv")
        return supportedFormats.any { fileName.lowercase().endsWith(it) }
    }

    private fun scheduleNextDeletion(context: Context, folderUri: String, durationMonths: Int) {
        val nextDeletionDate = Calendar.getInstance().apply {
            add(Calendar.MONTH, durationMonths)
        }.timeInMillis

        // Save next deletion date in SharedPreferences
        val sharedPreferences =
            context.getSharedPreferences("DashCamCleanerPrefs", Context.MODE_PRIVATE)
        sharedPreferences.edit().putLong("deletionDate", nextDeletionDate).apply()

        val workRequest = OneTimeWorkRequestBuilder<VideoDeletionWorker>()
            .setInitialDelay(nextDeletionDate - System.currentTimeMillis(), TimeUnit.MILLISECONDS)
            .setInputData(
                workDataOf(
                    "folderUri" to folderUri,
                    "deletionDate" to nextDeletionDate,
                    "durationMonths" to durationMonths
                )
            )
            .build()

        WorkManager.getInstance(context).enqueueUniqueWork(
            "VideoDeletionWork",
            ExistingWorkPolicy.REPLACE,
            workRequest
        )

        Log.d("VideoDeletionWorker", "Scheduled next deletion for: $nextDeletionDate")
    }
}