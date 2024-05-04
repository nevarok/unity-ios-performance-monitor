using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using nevarok.PerformanceMonitor.Abstract;
using nevarok.PerformanceMonitor.Monitors;

namespace nevarok.PerformanceMonitor.Examples
{
    /// <summary>
    /// Demonstrates the use of the PerformanceMonitor to display performance data in Unity.
    /// This example toggles performance data collection on and off and displays the results.
    /// </summary>
    public class DemoPerformanceMonitor : MonoBehaviour
    {
        [SerializeField] private Text _dataDisplay; // UI Text element to display performance data.
        [SerializeField] private Toggle _autoUpdate; // Toggle to control automatic updating of performance data.

        [SerializeField, Min(0.0f)]
        private float _autoUpdateDelay = 1.0f; // Delay between automatic updates, in seconds.

        private Coroutine _autoUpdateCoroutine; // Reference to the currently running auto-update coroutine.

        private void Start()
        {
            // Adds a listener to the toggle's value changed event to handle auto-update toggling.
            if (_autoUpdate)
            {
                _autoUpdate.onValueChanged.AddListener(OnAutoUpdateValueChanged);
            }
        }

        /// <summary>
        /// Called when the auto-update toggle's value changes.
        /// </summary>
        /// <param name="isAutoUpdating">Whether auto-updating should start or stop.</param>
        private void OnAutoUpdateValueChanged(bool isAutoUpdating)
        {
            if (isAutoUpdating)
            {
                StartAutoUpdate();
            }
            else
            {
                StopAutoUpdate();
            }
        }

        /// <summary>
        /// Starts the auto-update coroutine if it is not already running.
        /// </summary>
        private void StartAutoUpdate()
        {
            if (_autoUpdateCoroutine != null)
            {
                return; // Prevent starting multiple instances of the coroutine.
            }

            _autoUpdateCoroutine = StartCoroutine(AutoUpdateCycle(_autoUpdateDelay));
        }

        /// <summary>
        /// Stops the auto-update coroutine and halts performance tracking.
        /// </summary>
        private void StopAutoUpdate()
        {
            if (_autoUpdateCoroutine != null)
            {
                StopCoroutine(_autoUpdateCoroutine);
                _autoUpdateCoroutine = null;
            }

            StopTracking();
        }

        /// <summary>
        /// Repeatedly performs performance tracking at the specified interval.
        /// </summary>
        /// <param name="delay">Time in seconds between performance data collections.</param>
        private IEnumerator AutoUpdateCycle(float delay)
        {
            while (_autoUpdate.isOn)
            {
                StartTracking();
                yield return new WaitForSeconds(delay);
                StopTracking();
            }
        }

        /// <summary>
        /// Starts performance data tracking.
        /// </summary>
        public void StartTracking()
        {
            PerformanceMonitor.StartTracking();
        }

        /// <summary>
        /// Stops performance data tracking and processes the data for display.
        /// </summary>
        public void StopTracking()
        {
            var data = PerformanceMonitor.StopTracking();
            DisplayData(data);
        }

        /// <summary>
        /// Displays the formatted performance data in the UI.
        /// </summary>
        /// <param name="data">Performance data to display.</param>
        private void DisplayData(IPerformanceData data)
        {
            if (!_dataDisplay)
            {
                return; // Check for null reference before using the text component.
            }

            _dataDisplay.text = FormatDataDisplay(data);
        }

        /// <summary>
        /// Formats the performance data for display.
        /// </summary>
        /// <param name="data">Performance data to format.</param>
        /// <returns>Formatted string for display.</returns>
        private string FormatDataDisplay(IPerformanceData data)
        {
            var displayText = ConstructBasicDisplayText(data);

#if (UNITY_EDITOR && UNITY_IOS) || UNITY_IOS
            // Append additional GPU data for iOS platform.
            displayText += FormatIOSGPUData(data);
#endif
            return displayText;
        }

        /// <summary>
        /// Constructs basic performance data text display.
        /// </summary>
        /// <param name="data">Data containing basic performance metrics.</param>
        /// <returns>A formatted string with basic performance metrics.</returns>
        private string ConstructBasicDisplayText(IPerformanceData data)
        {
            return
                $"<color=yellow>CPU</color> [<color=yellow>{nameof(data.CpuCoresCount)}</color>]: [<color=yellow>{data.CpuCoresCount}</color>]\n" +
                $"<color=yellow>CPU</color> [<color=yellow>{nameof(data.CpuUsagePercents)}</color>]:\nAVR = [<color=yellow>{data.CpuUsagePercents:0.00}</color>]%, MIN = [<color=yellow>{data.MinCpuUsagePercents:0.00}</color>]%, MAX = [<color=yellow>{data.MaxCpuUsagePercents:0.00}</color>]%\n" +
                $"<color=yellow>RAM</color> [<color=yellow>{nameof(data.MemoryUsageMegabytes)}</color>]:\nAVR = [<color=yellow>{data.MemoryUsageMegabytes:0.00}</color>]MB, MIN = [<color=yellow>{data.MinMemoryUsageMegabytes:0.00}</color>]MB, MAX = [<color=yellow>{data.MaxMemoryUsageMegabytes:0.00}</color>]MB\n" +
                $"<color=cyan>GPU</color> [<color=cyan>{nameof(data.RendererUtilization)}</color>]:\nAVR = [<color=cyan>{data.RendererUtilization:0.00}</color>]%, MIN = [<color=cyan>{data.MinRendererUtilization:0.00}</color>]%, MAX = [<color=cyan>{data.MaxRendererUtilization:0.00}</color>]%\n";
        }

#if (UNITY_EDITOR && UNITY_IOS) || UNITY_IOS
        /// <summary>
        /// Formats additional GPU data specific to iOS platform.
        /// </summary>
        /// <param name="data">Data containing iOS-specific GPU metrics.</param>
        /// <returns>A formatted string with iOS-specific GPU metrics.</returns>
        private string FormatIOSGPUData(IPerformanceData data)
        {
            var iosData = (IOSPerformanceMonitor.PerformanceData)data; // Cast to specific iOS data type.

            return // Construct formatted text for iOS-specific GPU data.
                $"<color=cyan>GPU</color> [<color=cyan>{nameof(iosData.DeviceUtilization)}</color>]:\nAVR = [<color=cyan>{iosData.DeviceUtilization:0.00}</color>]%, MIN = [<color=cyan>{iosData.MinDeviceUtilization:0.00}</color>]%, MAX = [<color=cyan>{iosData.MaxDeviceUtilization:0.00}</color>]%\n" +
                $"<color=cyan>GPU</color> [<color=cyan>{nameof(iosData.TilerUtilization)}</color>]:\nAVR = [<color=cyan>{iosData.TilerUtilization:0.00}</color>]%, MIN = [<color=cyan>{iosData.MinTilerUtilization:0.00}</color>]%, MAX = [<color=cyan>{iosData.MaxTilerUtilization:0.00}</color>]%\n" +
                $"<color=cyan>GPU</color> [<color=cyan>{nameof(iosData.InUseSystemMemoryMegabytes)}</color>]:\nAVR = [<color=cyan>{iosData.InUseSystemMemoryMegabytes:0.00}</color>]MB, MIN = [<color=cyan>{iosData.MinInUseSystemMemoryMegabytes:0.00}</color>]MB, MAX = [<color=cyan>{iosData.MaxInUseSystemMemoryMegabytes:0.00}</color>]MB\n" +
                $"<color=cyan>GPU</color> [<color=cyan>{nameof(iosData.AllocatedSystemMemoryMegabytes)}</color>]:\nAVR = [<color=cyan>{iosData.AllocatedSystemMemoryMegabytes:0.00}</color>]MB, MIN = [<color=cyan>{iosData.MinAllocatedSystemMemoryMegabytes:0.00}</color>]MB, MAX = [<color=cyan>{iosData.MaxAllocatedSystemMemoryMegabytes:0.00}</color>]MB\n" +
                $"<color=cyan>GPU</color> [<color=cyan>{nameof(iosData.TiledSceneMegabytes)}</color>]:\nAVR = [<color=cyan>{iosData.TiledSceneMegabytes:0.00}</color>]MB, MIN = [<color=cyan>{iosData.MinTiledSceneMegabytes:0.00}</color>]MB, MAX = [<color=cyan>{iosData.MaxTiledSceneMegabytes:0.00}</color>]MB\n" +
                $"<color=cyan>GPU</color> [<color=cyan>{nameof(iosData.AllocatedPbSizeMegabytes)}</color>]:\nAVR = [<color=cyan>{iosData.AllocatedPbSizeMegabytes:0.00}</color>]MB, MIN = [<color=cyan>{iosData.MinAllocatedPbSizeMegabytes:0.00}</color>]MB, MAX = [<color=cyan>{iosData.MaxAllocatedPbSizeMegabytes:0.00}</color>]MB\n" +
                $"<color=cyan>GPU</color> [<color=cyan>{nameof(iosData.SplitSceneCount)}</color>]:\nAVR = [<color=cyan>{iosData.SplitSceneCount}</color>], MIN = [<color=cyan>{iosData.MinSplitSceneCount}</color>], MAX = [<color=cyan>{iosData.MaxSplitSceneCount}</color>]\n" +
                $"<color=cyan>GPU</color> [<color=cyan>{nameof(iosData.RecoveryCount)}</color>]:\nAVR = [<color=cyan>{iosData.RecoveryCount}</color>], MIN = [<color=cyan>{iosData.MinRecoveryCount}</color>], MAX = [<color=cyan>{iosData.MaxRecoveryCount}</color>]\n";
        }
#endif
    }
}