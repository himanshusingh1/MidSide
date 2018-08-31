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
    
    
    func setNewSong(_ withUrl:URL){
        song = SongUnit()
        song.delegate = self
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
        guard let playingSong = song else {
            print("Cannot Play or pause song because it is nil")
            return
        }
        if playingSong.isPlaying {
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
    
   @objc func progressUpdate(){
        print("XHC playing song at ",song.currentTime)
        print("XHC totalDuration of song ",song.totalDuration)
    }
    
}

extension playingLayer:nodeDelegates{
    func ReachedEnd() {
        print("END")
    }
    
    func ErrorOccured() {
        print("EROOR")
        stop()
    }
}
