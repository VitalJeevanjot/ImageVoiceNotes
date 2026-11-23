# PicMik

An iPhone and iPad app that pairs a photo with sound. Pick a photo, then record a voice note or choose a music file, and PicMik keeps them together as one "creation" you can play back full screen or send to someone as a single file.

[Get it on the App Store](https://apps.apple.com/app/id6504264044)

A paid app ($1.99), sold since 2024. It also runs on Apple silicon Macs and Apple Vision Pro as an iPad app. Built with Swift, SwiftUI, SwiftData and AVFoundation, and maintained from April 2024 to July 2026.

## What it does

- **Makes a creation.** Choose a photo with the system photo picker, then record audio with the microphone or pick an audio file. Give it a name and save it.
- **Plays it back.** Each creation shows its photo with player controls, and can play full screen.
- **Shares it as one file.** PicMik exports a creation as a `.picmik` file, a document type the app declares (`com.jeevanjotsinghvital.picmik`, "Picture Miked"), and shares it through the share sheet.
- **Opens files from others.** Tapping a `.picmik` file someone sent opens it in PicMik, which saves it as an imported creation, marked with the date it arrived.

## How it works

- **Storage:** creations are a SwiftData model (`Models/AudioImageModel.swift`): name, photo, audio, created date, and whether and when it was imported.
- **The file format:** a `.picmik` file is the creation's name, photo data, audio data and date, encoded as JSON (`FileToSaveWith` in `TransferableItem.swift`). `TransferableItem` gives it a `FileRepresentation`, so `ShareLink` can send it and the app can receive it.
- **Opening files:** `Info.plist` exports the type and registers PicMik as its owner. `ContentView` handles the file in `onOpenURL`, decodes it and saves a new creation.
- **Audio:** `AudioRecorder.swift` records with `AVAudioRecorder`; `AudioPlayer.swift` plays with `AVAudioPlayer`.

## Building it

Open **`PicMik.xcodeproj`**. It's the current project. `ImageVoiceNotes.xcodeproj` is the original one and hasn't changed since June 2024. The app targets iOS 17.4 and later, for iPhone and iPad.

## License

No license is granted. The source is published so you can see how the app is built. It isn't licensed for reuse or redistribution.

Built by [Jeevanjot Singh Vital](https://jeevanjotsinghvital.com).
