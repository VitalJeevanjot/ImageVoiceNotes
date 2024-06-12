//
//  AudioRecorder.swift
//  ImageVoiceNotes
//
//  Created by Jeevanjot Singh on 13/05/24.
//

import SwiftUI
import AVFAudio

struct AudioRecorder: View {
    @State private var publicProperties = PublicAudioImageProperties.shared
    
    @State private var audioRecording: AVAudioRecorder?
    let componentFormatter = DateComponentsFormatter()
    
    @State private var isRecording = false
    @State private var canRecord = false
    @State private var isPaused = true
    @State private var currentTime = TimeInterval(0)
    
    @State private var fileName = URL(string: "hi")!
    
    @State private var manualDisappear = false
    
    
    var body: some View {
        componentFormatter.unitsStyle = .positional
        componentFormatter.allowedUnits = [.minute, .second]
        componentFormatter.zeroFormattingBehavior = .pad
        
        
        return VStack {
            
            if canRecord {
                Text("\(componentFormatter.string(from: currentTime) ?? "00:00")")
                    .padding()
                
                HStack {
                    Button {
                        manualDisappear = false
                        startPauseRecording()
                    } label: {
                        Label("Record or Pause", systemImage: isPaused ? "recordingtape.circle.fill" : "pause.rectangle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.black)
                            .labelStyle(.iconOnly)
                    }
                    
                    Group {
                        if isRecording {
                            Button {
                                manualDisappear = true
                                stopRecording()
                            }label: {
                                Label("Record or Pause", systemImage: "stop.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.red)
                                    .labelStyle(.iconOnly)
                                
                            }
                            
                        }
                    }
                }
            } else {
                Button {
                    Task {
                        await checkForRecordingPermission()
                    }
                } label: {
                    Label("Enable Microphone Permission", systemImage: "mic.fill")
                        .foregroundStyle(.white)
                }
                .tint(.black)
                .buttonStyle(.borderedProminent)
            }
        }
        .onDisappear {
            if isRecording {
                stopRecording()
            }
            if manualDisappear == false {
                publicProperties.audioPlayer.stop()
                publicProperties.isPlaying = false
                publicProperties.audioFileSelectedAndAdded = false
                publicProperties.isReadyToPlayFull = false
                publicProperties.showRecordingUI = false
//                print("Disappeared without stopping audio in AudioRecorder...")
            }
        }
        .task {
            let audioPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            let fileName = audioPath.appendingPathComponent("temp.m4a")
            
            do {
                if FileManager.default.fileExists(atPath: fileName.path()) {
                    try FileManager.default.removeItem(at: fileName)
                }
            } catch {
                print("error while delete audio file if exist: \(error)")
            }
            
            await checkForRecordingPermission()

//            print("Running task")
//            do {
//                    try
//                audioSession.setCategory(.playAndRecord, mode: .default)
//                try audioSession.setActive(true)
//                audioSession.requestRecordPermission() { [unowned self] allowed in
//                        DispatchQueue.main.async {
//                            if allowed {
//                                self.loadRecordingUI()
//                            } else {
//                                self.loadFailUI()
//                            }
//                        }
//                    }
//                } catch {
//                    self.loadFailUI()
//                }
            
        }
        
    }
    
    func checkForRecordingPermission() async {
//        print("checking")
//        print(AVAudioApplication.shared.recordPermission)
        if await AVAudioApplication.requestRecordPermission() {
            canRecord = true
//            print("Preparing recording")
            prepareRecordingFile()
        } else {
//            print("false")
            canRecord = false
            openSettingsURLForPicMik()
        }
    }
    
    func openSettingsURLForPicMik() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func prepareRecordingFile() {
//
        
        let audioPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        fileName = audioPath.appendingPathComponent("temp.m4a")
        
        
//        let x = NSError(domain: NSOSStatusErrorDomain, code:1718449215, userInfo: .none)
//        print(x)
//        print(SecCopyErrorMessageString(1718449215, nil))
//
//        print(String(kAudioFormatMPEG4AAC))
        
        let settings : [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderBitRateKey: 320000
        ]
        print(fileName)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
//            try AVAudioSession.sharedInstance().setActive(true)
            audioRecording = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecording!.delegate = AudioRecorderDelegatee.shared
            print(try FileManager.default.contentsOfDirectory(atPath: audioPath.path()))
            
            print("Prepared.")
        } catch {
            print("err on setup of recording is: \(error) and \(Date.now)")
        }
        print("Prepared 2.")
    }
    
    func startPauseRecording() {
        if isPaused {
            print("Started.......")
            print(audioRecording!.record())
            isRecording = true
            print(".......Started.......")
            isPaused = false
            print("Started recording")
            updateTiming()
        } else {
            audioRecording!.pause()
            isPaused = true
        }
    }
    
    func stopRecording() {
        do {
            publicProperties.showRecordingUI = false
            audioRecording!.stop()
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("Audio seesion cannot of deactivated err is: \(error)")
        }
        isPaused = true
        isRecording = false
        currentTime = TimeInterval(0)
        
        publicProperties.isLoading = true
        do {
            publicProperties.pickedAudioData = try Data(contentsOf: fileName)
            
            publicProperties.audioPlayer = try AVAudioPlayer(data: publicProperties.pickedAudioData)
            
            audioRecording!.deleteRecording()
        } catch {
            print("err is on copying recorded audio to data: \(error)")
        }
        print("FINISHED RECORDING>>>>>>")
        publicProperties.audioFileSelectedAndAdded = true
        publicProperties.isPlaying = false
        publicProperties.isReadyToPlayFull = true
        publicProperties.isLoading = false
        
        publicProperties.durationTime = publicProperties.audioPlayer.duration
        publicProperties.setUpTimer()
        //            print(
        publicProperties.audioPlayer.delegate = publicProperties
        
        print("FINISHED RECORDING>>>>>>2")
        
        // hide presentor, prepare the file, copy to data to publicproperties audioplayer, delete the file(also on dissapear check if file exists then delete it and recordingStarted = false)
    }
    
    func updateTiming() {
        if isRecording && !isPaused && publicProperties.showRecordingUI {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                currentTime = audioRecording!.currentTime
                print("Updaing")
                print(audioRecording!.currentTime)
                updateTiming()
            }
        }
    }
}



class AudioRecorderDelegatee: NSObject, AVAudioRecorderDelegate {
    static let shared = AudioRecorderDelegatee()
    
    override init() {
        super.init()
    }
    
    
}

#Preview {
    @State var publicProperties = PublicAudioImageProperties.shared

    return AudioRecorder()
}
