//
//  playingLayer.swift
//  testApp
//
//  Created by Himanshu on 30/08/18.
//  Copyright © 2018 craterZone. All rights reserved.
//

import UIKit
import AVKit

class playingLayer: NSObject {

    
    private var engine: AVAudioEngine!
    private var song: SongUnit!
    static let shared = playingLayer()
    
    func setSong(_ withUrl:URL){
        
        song = SongUnit()
        song.setSong(withUrl)
        initilizeEngine()
        play()
    }
    
    private func initilizeEngine(){
        let format = AVAudioFormat(standardFormatWithSampleRate: song.sampleRate, channels: 2)
        print(format?.sampleRate ?? "format nil")
        engine = AVAudioEngine()
        engine.attach(song)
        let mixer = engine.mainMixerNode
        engine.connect(song, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func togglePlayPause(){
        if song.isPlaying {
            stop()
        } else {
            play()
        }
    }
    
    func play(){
        song.preparePlaying()
        song.play()
        engine.mainMixerNode.volume = 1.0
    }
    
    func pause(){
        engine.mainMixerNode.volume = 0.0
        song.pause()
    }
    
    func stop(){
        engine.mainMixerNode.volume = 0.0
        song.stop()
        engine.reset()
    }
    
    func seekToTime(_ percent:Double){
        stop()
        song.seekToTime(percent)
        play()
    }
    
    func setProcessingMechanism(_ method:processingMethod){
        song.processingMethodology = method
    }
    
}
