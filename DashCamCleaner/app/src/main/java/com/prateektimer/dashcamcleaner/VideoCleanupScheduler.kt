package com.prateektimer.dashcamcleaner

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import android.provider.OpenableColumns
import android.util.Log
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import java.util.*
import androidx.work.*
import java.util.concurrent.TimeUnit

@Composable
fun VideoCleanupScheduler(modifier: Modifier = Modifier) {
    val context = LocalContext.current
    val sharedPreferences = context.getSharedPreferences("DashCamCleanerPrefs", Context.MODE_PRIVATE)

    var folderUri by remember { mutableStateOf<Uri?>(null) }
    var selectedDate by remember { mutableStateOf(Calendar.getInstance().time) }
    var durationMonths by remember { mutableStateOf(3) }
    var previewVideos by remember { mutableStateOf(listOf<String>()) }

    val folderPickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.OpenDocumentTree()
    ) { uri: Uri? ->
        uri?.let {
            folderUri = it
            context.contentResolver.takePersistableUriPermission(
                it,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            )
            sharedPreferences.edit().putString("folderUri", it.toString()).apply()
        }
    }

    LaunchedEffect(Unit) {
        folderUri = sharedPreferences.getString("folderUri", null)?.let { Uri.parse(it) }
        val savedDate = sharedPreferences.getLong("deletionDate", 0L)
        if (savedDate > 0) selectedDate = Date(savedDate)
        durationMonths = sharedPreferences.getInt("durationMonths", 3)
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(16.dp)
            .verticalScroll(rememberScrollState()), // Make it scrollable
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("AutoClean Dash", style = MaterialTheme.typography.headlineSmall)

        Spacer(modifier = Modifier.height(16.dp))

        Card(
            modifier = Modifier.fillMaxWidth(),
            elevation = CardDefaults.cardElevation(defaultElevation = 6.dp)
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                // Folder Picker Button
                OutlinedButton(onClick = { folderPickerLauncher.launch(null) }) {
                    Text("Select Folder: ${folderUri?.lastPathSegment ?: "None"}")
                }

                Spacer(modifier = Modifier.height(12.dp))

                // Date Picker
                OutlinedButton(onClick = {
                    val calendar = Calendar.getInstance()
                    DatePickerDialog(
                        context,
                        { _, year, month, dayOfMonth ->
                            calendar.set(year, month, dayOfMonth)
                            TimePickerDialog(
                                context,
                                { _, hourOfDay, minute ->
                                    calendar.set(Calendar.HOUR_OF_DAY, hourOfDay)
                                    calendar.set(Calendar.MINUTE, minute)
                                    selectedDate = calendar.time
                                    sharedPreferences.edit().putLong("deletionDate", selectedDate.time).apply()
                                },
                                calendar.get(Calendar.HOUR_OF_DAY),
                                calendar.get(Calendar.MINUTE),
                                true
                            ).show()
                        },
                        calendar.get(Calendar.YEAR),
                        calendar.get(Calendar.MONTH),
                        calendar.get(Calendar.DAY_OF_MONTH)
                    ).show()
                }) {
                    Text("Select Date & Time: ${selectedDate}")
                }

                Spacer(modifier = Modifier.height(12.dp))

                // Duration Input
                OutlinedTextField(
                    value = if (durationMonths == 0) "" else durationMonths.toString(),
                    onValueChange = {
                        durationMonths = it.toIntOrNull() ?: 0
                        sharedPreferences.edit().putInt("durationMonths", durationMonths).apply()
                    },
                    label = { Text("Retention Period (Months)") },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Preview Videos Button
        ElevatedButton(
            onClick = {
                previewVideos = emptyList()
                folderUri?.let { uri ->
                    val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(uri, DocumentsContract.getTreeDocumentId(uri))
                    val cursor = context.contentResolver.query(childrenUri, null, null, null, null)
                    cursor?.use {
                        val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                        while (cursor.moveToNext()) {
                            val name = cursor.getString(nameIndex)
                            if (name.endsWith(".mp4") || name.endsWith(".avi") || name.endsWith(".mkv")) {
                                previewVideos = previewVideos + name
                            }
                        }
                    }
                }
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Preview Videos")
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Video List
        if (previewVideos.isNotEmpty()) {
            Card(
                modifier = Modifier.fillMaxWidth(),
                elevation = CardDefaults.cardElevation(defaultElevation = 6.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text("Videos to be deleted:", style = MaterialTheme.typography.bodyLarge)
                    previewVideos.forEach { video ->
                        Text(video, style = MaterialTheme.typography.bodyMedium)
                    }
                }
            }
        } else {
            Text(
                "No videos found for deletion.",
                style = MaterialTheme.typography.bodyMedium,
                modifier = Modifier.padding(16.dp)
            )
        }


        Spacer(modifier = Modifier.height(16.dp))

        // Confirm/Delete Button
        Button(
            onClick = {
                folderUri?.let { uri ->
                    scheduleInitialDeletion(
                        context = context,
                        folderUri = uri.toString(),
                        selectedDate = selectedDate.time,
                        durationMonths = durationMonths
                    )
                } ?: Toast.makeText(context, "Please select a folder", Toast.LENGTH_SHORT).show()
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Confirm & Schedule Cleanup")
        }
    }
}

fun scheduleInitialDeletion(context: Context, folderUri: String, selectedDate: Long, durationMonths: Int) {
    val currentTime = System.currentTimeMillis()
    val delay = if (selectedDate > currentTime) selectedDate - currentTime else 1000 // At least 1 second delay

    val workRequest = OneTimeWorkRequestBuilder<VideoDeletionWorker>()
        .setInitialDelay(delay, TimeUnit.MILLISECONDS)
        .setInputData(
            workDataOf(
                "folderUri" to folderUri,
                "deletionDate" to selectedDate,
                "durationMonths" to durationMonths
            )
        )
        .build()

    WorkManager.getInstance(context).enqueueUniqueWork(
        "VideoDeletionWork",
        ExistingWorkPolicy.REPLACE,
        workRequest
    )

    Log.d("Scheduler", "Initial deletion scheduled for: $selectedDate with delay: $delay ms")
}


