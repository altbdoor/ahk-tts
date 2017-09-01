using System;
using System.IO;

using NAudio;
using NAudio.Wave;


public class AHKTTSWatcher
{
    static WaveOut waveOutDevice;
    static AudioFileReader audioFileReader;
    
    static string bridgeFilePath;
    
    const int fileReaderRetry = 100;
    const int fileReaderSleep = 10;
    
    public static void Main (string[] args)
    {
        if (args.Length == 1) {
            bridgeFilePath = args[0];
            
            FileSystemWatcher fw = new FileSystemWatcher();
            fw.Path = Path.GetDirectoryName(bridgeFilePath);
            fw.NotifyFilter = NotifyFilters.LastWrite;
            fw.Filter = Path.GetFileName(bridgeFilePath);
            
            fw.Changed += new FileSystemEventHandler(OnFileChanged);
            fw.EnableRaisingEvents = true;
            
            Console.ReadLine();
            CleanAudioResource();
        }
    }
    
    private static void OnFileChanged (object source, FileSystemEventArgs e)
    {
        CleanAudioResource();
        
        int retry = fileReaderRetry;
        string readText = "";
        
        do {
            try {
                readText = File.ReadAllText(bridgeFilePath);
                break;
            }
            catch (IOException) {
                retry--;
                System.Threading.Thread.Sleep(fileReaderSleep);
            }
        } while (retry > 0);
        
        string[] textArgs = readText.Trim().Split(new string[] { "\r\n", "\n" }, StringSplitOptions.None);
        if (textArgs.Length == 3) {
            waveOutDevice = new WaveOut();
            
            string deviceName = textArgs[0].Trim();
            string audioPath = textArgs[1].Trim();
            float audioVolume = float.Parse(textArgs[2].Trim(), System.Globalization.CultureInfo.InvariantCulture);
            
            for (int i=0; i<WaveOut.DeviceCount; i++)
            {
                var woc = WaveOut.GetCapabilities(i);
                if (deviceName.StartsWith(woc.ProductName)) {
                    waveOutDevice.DeviceNumber = i;
                    break;
                }
            }
            
            audioFileReader = new AudioFileReader(audioPath);
            audioFileReader.Volume = audioVolume;
            waveOutDevice.Init(audioFileReader);
            waveOutDevice.Play();
        }
        
    }
    
    private static void CleanAudioResource () {
        if (waveOutDevice != null) {
            waveOutDevice.Stop();
            waveOutDevice.Dispose();
        }
        
        if (audioFileReader != null) {
            audioFileReader.Dispose();
        }
        
    }
    
}
