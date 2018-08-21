//
//  AudioPlayer.swift
//  testApp
//
//  Created by Himanshu on 20/08/18.
//  Copyright © 2018 craterZone. All rights reserved.
//

import UIKit
import AVKit
import AudioKit

protocol songProtoCol {
    func isReadyToPlay()
}
class Queue{
  private var file = try! AKAudioFile()
    var player:AKAudioPlayer?
    var start:Int64 = 0
    var end:Int64 = 0
    
    var token: Int = 0
    
    var currentPossition: Int{
        get{
            if start > 0{
                return Int( start / Int64(file.sampleRate) )
            }
            return 0
        }
    }
    var items:[([Float],[Float])] = []
    var delegate:songProtoCol!
    func setSong(file:AKAudioFile){
        self.file = file
        start = 0
        end = 0
        self.items = []
      _ = dequeue()
    }
    func enqueue(element: ([Float],[Float]) )
    {
        items.append(element)
        let file = try! AKAudioFile(createFileFromFloats: [element.0,element.1])
        self.player?.audioFile.appendAsynchronously(file: file, baseDir: AKAudioFile.BaseDirectory.temp, name: "a", completionHandler: { (a, v) in
            
        });
        if items.count > 0 {
            if token == 0{
                token = 90
        AudioKit.output = player
        try? AudioKit.start()
        self.player?.play()
        }
        }
        
        player?.resume()
        delegate.isReadyToPlay()
    }
    
    func dequeue() -> ([Float],[Float])?
    {
        
            if (self.end < self.self.file.length){
                self.start = self.end;
                self.end = self.end + Int64(self.file.sampleRate);
                let buf = AVAudioPCMBuffer.init(pcmFormat: AVAudioFormat.init(standardFormatWithSampleRate: self.file.sampleRate, channels: 2)!, frameCapacity: AVAudioFrameCount(self.file.sampleRate))
                try! (self.file as AVAudioFile).read(into: buf!, frameCount: AVAudioFrameCount(self.self.file.sampleRate))
                let arrary = Array(UnsafeBufferPointer(start: buf?.floatChannelData![0], count: Int(self.file.sampleRate)))
            self.enqueue(element: (arrary,arrary))
        }
            if self.items.isEmpty {
            return nil
        }
        else{
            let tempElement = items.first
            items.remove(at: 0)
            return tempElement
        }
        
        
    }
    
}

import Foundation
import MediaPlayer
import AVFoundation
import AudioKit

class AudioPlayer: songProtoCol {
    
    var que = Queue()
    func loadSong(){
        que.delegate = self
        que.items = []
        let url = Bundle.main.path(forResource: "LR", ofType: ".mp3")
        startQueuingSong(songurl: url)
        
    }
    
    
    
    func startQueuingSong(songurl:String?){
        
        print("Entered Func",Date().timeIntervalSince1970)

        let url = URL(fileURLWithPath:songurl!)
        let file = try! AKAudioFile(forReading: url)
        print("starting Buffer",Date().timeIntervalSince1970)
        que.setSong(file: file)
       
    }
    func isReadyToPlay() {
        print("PLAYING")
        print("start from ",que.start)
        print("end AT",que.end)
//        if (que.items.count > 0){
//        let file = try! AKAudioFile(createFileFromFloats: [ que.items[0].0,que.items[0].1])
//            self.player = try? AKAudioPlayer(file: file )
//            AudioKit.output = player
//            try? AudioKit.start()
//            self.player?.play()
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            _ = self.que.dequeue()
        }
    }
    
}
