package com.prateektimer.dashcamcleaner

import android.content.Context
import android.net.Uri
import android.provider.DocumentsContract
import android.util.Log
import androidx.documentfile.provider.DocumentFile
import androidx.work.Worker
import androidx.work.WorkerParameters

class VideoDeletionWorker(
    context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {

    override fun doWork(): Result {
        val folderUriString = inputData.getString("folderUri") ?: return Result.failure()
        val deletionDate = inputData.getLong("deletionDate", 0L)

        Log.d("VideoDeletionWorker", "Starting deletion with URI: $folderUriString")

        return try {
            val folderUri = Uri.parse(folderUriString)
            val documentFile = DocumentFile.fromTreeUri(applicationContext, folderUri)

            if (documentFile != null && documentFile.isDirectory) {
                documentFile.listFiles().forEach { file ->
                    if (file.name?.endsWith(".mp4") == true || file.name?.endsWith(".avi") == true || file.name?.endsWith(".mkv") == true) {
                        if (file.lastModified() < deletionDate) {
                            Log.d("VideoDeletionWorker", "Deleting file: ${file.name}")
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
} 