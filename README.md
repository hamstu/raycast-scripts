# raycast-scripts

My custom [Raycast](raycast.com) scripts for macOS.

See: https://www.raycast.com/blog/getting-started-with-script-commands

## macOS Audio Recording (+Anki)

These scripts allow easy recording of system audio, specifically for mining audio to add to Anki cards. (Although one of the scripts simply records and saves the file.)

Both scripts require some setup before they'll work.

1. Install `sox` (`brew install sox`)
2. Install and confgigure [AnkiConnect](https://ankiweb.net/shared/info/2055492159) (for Anki integration only)
3. Install and configure [BlackHole](https://github.com/ExistentialAudio/BlackHole).
   - Once installed, you need to [set up a **Multi-Output Device**](https://github.com/ExistentialAudio/BlackHole/wiki/Multi-Output-Device). This will channel audio into BlackHole and allow these scripts (`sox`) to record audio.
   - You have to use the Multi-Output Device as your sound output for recording to work. This has a few drawbacks:
     - #1 - You can't your mac's volume buttons anymore, and instead have to adjust in the volume in the "Audio MIDI Setup" app (very annoying).
     - #2 - If you regularly use headphones, a single Multi-Output device won't work (e.g., you'll end up with sound coming out of your headphones AND Mac speakers).
   - To mitigate these issues, I've built the script to automatically switch to the correct Multi-Output Device for Headphones or Computer Speakers (fixes issue #2) and then back to the regular output device once recording is done (fixes issue #1).
     - For this to work, you need to create **two (2)** Multi-Output Devices, one for yout speakers, and one for your headphones. Use the same names as pictured below:
![CleanShot 2024-04-24 at 06 57 48](https://github.com/hamstu/raycast-scripts/assets/809093/10d75e95-4994-4b6d-acb3-b160143f1c62)
![CleanShot 2024-04-24 at 07 10 08](https://github.com/hamstu/raycast-scripts/assets/809093/2d57ed98-ae33-431d-aa3a-9609961f0fdb)
     - Make sure each device is named this way, and that they correct outputs are checked inside each.
     - You can leave your sound output set to your normal one (e.g., "MacBook Pro Speakers") as the scripts should switch for you. 🎉
    
Once configured this way, you should be able to trigger the recording in Raycast:

* Run the command once to start recording.
* Run the command again to stop the recording.
  
![CleanShot 2024-04-24 at 07 11 34](https://github.com/hamstu/raycast-scripts/assets/809093/78a9ea3f-0d9e-4acb-8ffa-284ed4c4e24b)
