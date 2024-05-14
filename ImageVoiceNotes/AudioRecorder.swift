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
    
    @State private var audioRecording = AVAudioRecorder()
    let componentFormatter = DateComponentsFormatter()
    
    @State private var recordingStarted = true
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
                        print("Record/Pause")
                    } label: {
                        Label("Record or Pause", systemImage: isPaused ? "recordingtape.circle.fill" : "pause.rectangle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.black)
                            .labelStyle(.iconOnly)
                    }
                    
                    Group {
                        if recordingStarted {
                            Button {
                                print("Stop")
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
//            print("Running task")
            await checkForRecordingPermission()
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
//            prepareRecordingFile()
        } else {
            print("false")
            canRecord = false
        }
    }
    
    func prepareRecordingFile() {
//
        
        let audioPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileName = audioPath.appendingPathComponent("sampleAudio.m4a")
        
//        let x = NSError(domain: NSOSStatusErrorDomain, code:1718449215, userInfo: .none)
//        print(x)
//        print(SecCopyErrorMessageString(1718449215, nil))
//
//        print(String(kAudioFormatMPEG4AAC))
        
        let settings : [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        print(fileName)
        do {
            audioRecording = try AVAudioRecorder(url: fileName, settings: settings)
            print("Prepared.")
        } catch {
            print("err on setup of recording is: \(error) and \(Date.now)")
        }
        audioRecording.delegate = AudioRecorderDelegatee.shared
        audioRecording.prepareToRecord()
        print("Prepared 2.")
    }
    
    func startStopPauseRecording() {
        audioRecording.record()
        updateTiming()
    }
    
    func updateTiming() {
        if recordingStarted {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                currentTime = audioRecording.currentTime
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
