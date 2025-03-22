package com.prateektimer.dashcamcleaner

import android.content.res.Configuration
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Devices
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.prateektimer.dashcamcleaner.ui.theme.DashCamCleanerTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            DashCamCleanerTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    VideoCleanupScheduler(
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
}

@Preview(
    name = "Landscape Preview",
    showBackground = true,
    uiMode = Configuration.UI_MODE_TYPE_UNDEFINED,
    device = Devices.DEFAULT,
    widthDp = 640, // Set a wider width for landscape
    heightDp = 400 // Set a shorter height for landscape
)
@Composable
fun VideoCleanupSchedulerLandscapePreview() {
    DashCamCleanerTheme {
        VideoCleanupScheduler(Modifier.padding(16.dp))
    }
}
