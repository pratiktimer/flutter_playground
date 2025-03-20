package com.prateektimer.dashcamcleaner

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.prateektimer.dashcamcleaner.ui.VideoCleanupScheduler
import com.prateektimer.dashcamcleaner.ui.theme.DashCamCleanerTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            DashCamCleanerTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    VideoCleanupScheduler()
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun VideoCleanupSchedulerPreview() {
    DashCamCleanerTheme {
        VideoCleanupScheduler()
    }
}