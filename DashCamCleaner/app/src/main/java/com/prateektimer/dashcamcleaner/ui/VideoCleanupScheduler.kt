package com.prateektimer.dashcamcleaner.ui

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.provider.DocumentsContract
import android.provider.OpenableColumns
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
import java.io.File
import java.util.*
import androidx.work.*
import com.prateektimer.dashcamcleaner.VideoDeletionWorker
import java.util.concurrent.TimeUnit

@Composable
fun VideoCleanupScheduler() {
    val context = LocalContext.current
    val sharedPreferences = context.getSharedPreferences("DashCamCleanerPrefs", Context.MODE_PRIVATE)

    var folderUri by remember { mutableStateOf<Uri?>(null) }
    var deletionCondition by remember { mutableStateOf(DeletionCondition.DATE) }
    var selectedDate by remember { mutableStateOf(Calendar.getInstance().time) }
    var durationMonths by remember { mutableStateOf(0) }
    var scheduleInterval by remember { mutableStateOf(ScheduleInterval.DAILY) }
    var previewVideos by remember { mutableStateOf(listOf<String>()) }
    var dropdownExpanded by remember { mutableStateOf(false) } // State for dropdown menu

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
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.Start
    ) {
        item {
            // Button to open folder picker
            Button(onClick = { folderPickerLauncher.launch(null) }) {
                Text("Select Folder")
            }

            // Display selected folder URI
            Text("Selected Folder: ${folderUri?.toString() ?: "None"}")

            Spacer(modifier = Modifier.height(16.dp))

            // Radio buttons for deletion condition
            Text("Deletion Condition:")
            Row {
                RadioButton(
                    selected = deletionCondition == DeletionCondition.DATE,
                    onClick = { deletionCondition = DeletionCondition.DATE }
                )
                Text("Specific Date")

                Spacer(modifier = Modifier.width(16.dp))

                RadioButton(
                    selected = deletionCondition == DeletionCondition.DURATION,
                    onClick = { deletionCondition = DeletionCondition.DURATION }
                )
                Text("Duration (Months)")
            }

            Spacer(modifier = Modifier.height(16.dp))

            // DatePicker and TimePicker for specific date and time
            if (deletionCondition == DeletionCondition.DATE) {
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
            }

            // Number input for specifying months
            if (deletionCondition == DeletionCondition.DURATION) {
                TextField(
                    value = durationMonths.toString(),
                    onValueChange = { durationMonths = it.toIntOrNull() ?: 0 },
                    label = { Text("Duration (Months)") },
                    modifier = Modifier.fillMaxWidth()
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Dropdown for scheduling interval
            Text("Schedule Interval:")
            Box {
                Button(onClick = { dropdownExpanded = true }) {
                    Text(scheduleInterval.name)
                }
                DropdownMenu(
                    expanded = dropdownExpanded,
                    onDismissRequest = { dropdownExpanded = false }
                ) {
                    ScheduleInterval.values().forEach { interval ->
                        DropdownMenuItem(
                            text = { Text(interval.name) },
                            onClick = {
                                scheduleInterval = interval
                                dropdownExpanded = false // Close dropdown after selection
                            }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Button to preview files before deletion
            Button(onClick = {
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

            Spacer(modifier = Modifier.height(16.dp))

            // Confirm/Delete button
            Button(onClick = {
                // Prepare input data for the worker
                val inputData = workDataOf(
                    "folderUri" to (folderUri?.toString() ?: ""),
                    "deletionDate" to selectedDate.time
                )

                // Create a periodic work request based on the selected interval
                val workRequest = when (scheduleInterval) {
                    ScheduleInterval.DAILY -> PeriodicWorkRequestBuilder<VideoDeletionWorker>(1, TimeUnit.DAYS)
                    ScheduleInterval.WEEKLY -> PeriodicWorkRequestBuilder<VideoDeletionWorker>(7, TimeUnit.DAYS)
                    ScheduleInterval.MONTHLY -> PeriodicWorkRequestBuilder<VideoDeletionWorker>(30, TimeUnit.DAYS)
                }.setInputData(inputData).build()

                // Enqueue the work request
                WorkManager.getInstance(context).enqueueUniquePeriodicWork(
                    "VideoDeletionWork",
                    ExistingPeriodicWorkPolicy.REPLACE,
                    workRequest
                )
            }) {
                Text("Confirm/Delete")
            }
        }
    }
}

enum class DeletionCondition {
    DATE, DURATION
}

enum class ScheduleInterval {
    DAILY, WEEKLY, MONTHLY
} 