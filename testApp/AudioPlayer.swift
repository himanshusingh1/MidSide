////
////  AudioPlayer.swift
////  testApp
////
////  Created by Himanshu on 20/08/18.
////  Copyright © 2018 craterZone. All rights reserved.
////
//
//import UIKit
//import AVKit
////import AudioKit
//
//protocol songProtoCol {
//    func isReadyToPlay()
//}
//struct Constants {
//    static let timePeriod = 5
//}
//class Queue{
//    private var file = try! AKAudioFile()
//    var player:AKAudioPlayer?
//    var start:Int64 = 0
//    var end:Int64 = 0
//    
//    var token: Int = 0
//    
//    private var duration = 0
//    private var sampleRate = 0
//    var currentPossition: Int{
//        get{
//            if start > 0{
//                return Int( start / Int64(file.sampleRate) )
//            }
//            return 0
//        }
//    }
//    var items:[([Float],[Float])] = []
//    var delegate:songProtoCol!
//    func setSong(file:AKAudioFile){
//        self.kill()
//        self.file = file
//        start = 0
//        end = 0
//        self.items = []
//        fillBuffer()
//    }
//    func enqueue(element: ([Float],[Float]) )
//    {
//        items.append(element)
//        delegate.isReadyToPlay()
//    }
//    func fillBuffer(){
//        if (self.end < self.file.length){
//            self.start = self.end;
//            self.end = self.end + Int64(self.file.sampleRate);
//            do{
//                let buf = AVAudioPCMBuffer.init(pcmFormat: AVAudioFormat.init(standardFormatWithSampleRate: self.file.sampleRate, channels: 2)!, frameCapacity: AVAudioFrameCount(self.file.sampleRate))
//                try! (self.file as AVAudioFile).read(into: buf!, frameCount: AVAudioFrameCount(self.self.file.sampleRate))
//                let left = Array(UnsafeBufferPointer(start: buf?.floatChannelData![0], count: Int(self.file.sampleRate)))
//                let right = Array(UnsafeBufferPointer(start: buf?.floatChannelData![1], count: Int(self.file.sampleRate)))
//                self.enqueue(element: (left,right))
//            }
//        }else{
//            self.kill()
//        }
//    }
//    
//    func dequeue() -> ([Float],[Float])?
//    {
//        if self.items.isEmpty {
//            return nil
//        }
//        else{
//            
//            return doSomething()
//        }
//        
//        
//    }
//    private func doSomething()-> ([Float],[Float])?{
//        let tempElement = items.first
//        items.remove(at: 0)
//        return (tempElement?.0,tempElement?.1) as? ([Float], [Float])
//    }
//    
//    private func kill(){
//        try! AudioKit.stop()
//        self.player = nil
//        self.items = []
//        self.file = try! AKAudioFile()
//        start = 0
//        end = 0
//    }
//}
//
//import Foundation
//import MediaPlayer
//import AVFoundation
////import AudioKit
//
//class AudioPlayer: songProtoCol {
//    var player:AKAudioPlayer!
//    var que: Queue!
//    init() {
//        que = nil
//        que = Queue()
//        justForFun()
//    }
//    func loadSong(){
//        que.delegate = self
//        que.items = []
//        let url = Bundle.main.path(forResource: "LR", ofType: ".mp3")
//        
//        //        startQueuingSong(songurl: url)
//        
//    }
//    
//    
//    
//    func startQueuingSong(songurl:String?){
//        
//        print("Entered Func",Date().timeIntervalSince1970)
//        
//        let url = URL(fileURLWithPath:songurl!)
//        let file = try! AKAudioFile(forReading: url)
//        print("starting Buffer",Date().timeIntervalSince1970)
//        que.setSong(file: file)
//        
//    }
//    func isReadyToPlay() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//            self.que.fillBuffer()
//        }
//        return;
//        print("PLAYING")
//        print("start from ",self.que.start)
//        print("end AT",self.que.end)
//        do{
//            if let que = self.que.dequeue(){
//                let file = try AKAudioFile(createFileFromFloats: [que.0,que.1])
//                
//                do{
//                    self.player = try AKAudioPlayer(file: file)
//                }catch{
//                    print("player cannot be invoked")
//                }
//            }
//        }catch{
//            print("file cannot be created")
//        }
//        AudioKit.output = self.player
//        AKSettings.playbackWhileMuted = true
//        try? AudioKit.start()
//        self.player?.play()
//    }
//    
//    func justForFun(){
//        
//        print("PLAYING")
//        print("start from ",self.que.start)
//        print("end AT",self.que.end)
//        print("himanshuTime Start",Date().timeIntervalSince1970)
//        do{
//            if let que = self.que.dequeue(){
//                let file = try AKAudioFile(createFileFromFloats: [que.0,que.1])
//                
//                do{
//                    self.player = try AKAudioPlayer(file: file)
//                }catch{
//                    print("player cannot be invoked")
//                }
//            }
//        }catch{
//            print("file cannot be created")
//        }
//        
//        AudioKit.output = self.player
//        AKSettings.playbackWhileMuted = true
//        try? AudioKit.start()
//        self.player?.play()
//        print("himanshuTime END",Date().timeIntervalSince1970)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.justForFun()
//        }
//    }
//    func queueNextFile(){
//        
//    }
//    func playSong(){
//    }
//}
