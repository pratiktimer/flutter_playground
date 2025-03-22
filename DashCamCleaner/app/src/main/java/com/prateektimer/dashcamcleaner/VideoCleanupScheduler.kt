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
fun VideoCleanupScheduler(modifier: Modifier) {
    val context = LocalContext.current
    val sharedPreferences = context.getSharedPreferences("DashCamCleanerPrefs", Context.MODE_PRIVATE)

    var folderUri by remember { mutableStateOf<Uri?>(null) }
    var selectedDate by remember { mutableStateOf(Calendar.getInstance().time) }
    var durationMonths by remember { mutableStateOf(3) }
    var previewVideos by remember { mutableStateOf(listOf<String>()) }

    // Launcher for folder picker
    val folderPickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.OpenDocumentTree()
    ) { uri: Uri? ->
        uri?.let {
            folderUri = it
            // Persist URI permissions
            context.contentResolver.takePersistableUriPermission(
                it,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            )
            // Save the folder URI to SharedPreferences
            sharedPreferences.edit().putString("folderUri", it.toString()).apply()
        }
    }

    // Load saved folder URI
    LaunchedEffect(Unit) {
        val savedUri = sharedPreferences.getString("folderUri", null)
        folderUri = savedUri?.let { Uri.parse(it) }
        val savedDate = sharedPreferences.getLong("deletionDate", 0L)
        if (savedDate > 0) {
            selectedDate = Date(savedDate)
        }
        durationMonths = sharedPreferences.getInt("durationMonths", 3) // Default to 3 months
    }

    LazyColumn(
        modifier = modifier
            .fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        item {
            // Button to open folder picker
            Button(onClick = { folderPickerLauncher.launch(null) }) {
                Text("Selected Folder: ${folderUri?.toString() ?: "None"}")
            }

            Spacer(modifier = Modifier.height(16.dp))

            Button(onClick = {
                    // Open DatePickerDialog
                    val calendar = Calendar.getInstance()
                    val datePickerDialog = DatePickerDialog(
                        context,
                        { _, year, month, dayOfMonth ->
                            calendar.set(year, month, dayOfMonth)
                            // Open TimePickerDialog after date is set
                            TimePickerDialog(
                                context,
                                { _, hourOfDay, minute ->
                                    calendar.set(Calendar.HOUR_OF_DAY, hourOfDay)
                                    calendar.set(Calendar.MINUTE, minute)
                                    selectedDate = calendar.time
                                },
                                calendar.get(Calendar.HOUR_OF_DAY),
                                calendar.get(Calendar.MINUTE),
                                true
                            ).show()
                        },
                        calendar.get(Calendar.YEAR),
                        calendar.get(Calendar.MONTH),
                        calendar.get(Calendar.DAY_OF_MONTH)
                    )
                    datePickerDialog.show()
                }) {
                    Text("Select Date & Time: ${selectedDate.toString()}")
                }

            Spacer(modifier = Modifier.height(16.dp))

            // Number input for specifying months
            TextField(
                value = if (durationMonths == 0) "" else durationMonths.toString(),
                onValueChange = {
                    durationMonths = it.toIntOrNull() ?: 0  // Allow empty input
                    sharedPreferences.edit().putInt("durationMonths", durationMonths).apply()
                },
                label = { Text("Duration (Months)") },
                modifier = Modifier.width(200.dp),
                singleLine = true
            )



            Spacer(modifier = Modifier.height(16.dp))

            // Button to preview files before deletion
            Button(onClick = {
                // Reset previewVideos before adding new ones
                previewVideos = emptyList()
                // Implement preview logic using ContentResolver
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
            }) {
                Text("Preview Videos")
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Display previewed videos
            if (previewVideos.isNotEmpty()) {
                Text("Videos to be deleted:")
                previewVideos.forEach { video ->
                    Text(video)
                }
            }

            // Confirm/Delete button
            Button(onClick = {
                folderUri?.let { uri ->
                    scheduleInitialDeletion(
                        context = context, // Pass the correct context
                        folderUri = uri.toString(),
                        selectedDate = selectedDate.time,
                        durationMonths = durationMonths
                    )
                } ?: Toast.makeText(context, "Please select a folder", Toast.LENGTH_SHORT).show()
            }) {
                Text("Confirm/Delete")
            }

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


