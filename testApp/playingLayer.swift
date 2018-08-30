//
//  playingLayer.swift
//  testApp
//
//  Created by Himanshu on 30/08/18.
//  Copyright © 2018 craterZone. All rights reserved.
//

import UIKit
import AVKit

class playingLayer: NSObject ,nodeDelegates{
    func didStop() {
        stop()
    }
    
   
    private var engine: AVAudioEngine!
    private var tone: SongUnit!
    static let shared = playingLayer()
    
    
    func makeSong(){
        tone = SongUnit()
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 2)
        print(format?.sampleRate ?? "format nil")
        engine = AVAudioEngine()
        engine.attach(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func togglePlayPause(){
        if tone.isPlaying {
            engine.mainMixerNode.volume = 0.0
            tone.stop()
            engine.reset()
        } else {
            tone.preparePlaying()
            tone.play()
            engine.mainMixerNode.volume = 1.0
        }
    }
    
    func play(){
        tone.preparePlaying()
        tone.play()
        engine.mainMixerNode.volume = 1.0
    }
    
    func pause(){
        engine.mainMixerNode.volume = 0.0
        tone.pause()
    }
    
    func stop(){
        engine.mainMixerNode.volume = 0.0
        tone.stop()
        engine.reset()
    }
}
