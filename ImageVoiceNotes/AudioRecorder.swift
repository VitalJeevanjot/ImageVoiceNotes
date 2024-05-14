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
                    Label("Request permission", systemImage: "mic.fill")
                        .foregroundStyle(.black)
                }
                .buttonStyle(.borderedProminent)
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
        print("checking")
//        print(AVAudioApplication.shared.recordPermission)
        if await AVAudioApplication.requestRecordPermission() {
            canRecord = true
            print("Preparing recording")
            prepareRecordingFile()
        } else {
            print("false")
            canRecord = false
        }
    }
    
    func prepareRecordingFile() {
//
        
        let audioPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileName = audioPath.appendingPathComponent("temp.m4a")
        
        
//        let x = NSError(domain: NSOSStatusErrorDomain, code:1718449215, userInfo: .none)
//        print(x)
//        print(SecCopyErrorMessageString(1718449215, nil))
//
//        print(String(kAudioFormatMPEG4AAC))
        
        let settings : [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1
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
            print(".......Started.......")
            isRecording = true
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
            audioRecording!.stop()
//            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Audio seesion cannot of deactivated err is: \(error)")
        }
        isPaused = true
        isRecording = false
        currentTime = TimeInterval(0)
        // hide presentor, prepare the file, copy to data to publicproperties audioplayer, delete the file(also on dissapear check if file exists then delete it and recordingStarted = false)
    }
    
    func updateTiming() {
        if isRecording && !isPaused {
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
    AudioRecorder()
}
