//
//  AVTonePlayerUnit.swift
//  ToneGenerator
//
//  Created by OOPer in cooperation with shlab.jp, on 2015/3/22.
//  See LICENSE.txt .
//

import Foundation
import AVFoundation

protocol nodeDelegates {
    func ReachedEnd()
}

enum processingMethod{
    case none,leftSolo,rightSolo,midSolo,sideSolo,swapLeftRightChannel
}

class SongUnit: AVAudioPlayerNode {
    var delegate:nodeDelegates?
    var processingMethodology:processingMethod = .none
    var bufferCapacity: AVAudioFrameCount {
        get{
            return (AVAudioFrameCount((file?.sampleRate)!))
        }
    }
    
    var sampleRate: Double{
        get{
            return (file?.sampleRate)!
        }
    }
    
    var channelCount:Int32{
        get{
            return Int32((file?.channelCount)!)
        }
    }
   
    var currentTime:Double{
        get{
            return Double((file?.framePosition)!)/(file?.sampleRate)!
        }
    }
    
    var totalDuration:Double{
        get{
            return (file?.duration)!
        }
    }
    
    private var audioFormat: AVAudioFormat{
        get{
            return AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: AVAudioChannelCount(channelCount))!
        }
    }
    
    private var file : AVAudioFile?

    func setSong(_ withUrl:URL){
        do{
            file = try AVAudioFile(forReading: withUrl)
        }catch{
            print("Something Went Wrong")
        }
    }
    
    func prepareBuffer() -> AVAudioPCMBuffer {
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: bufferCapacity)!
        fillBuffer(buffer)
        return buffer
    }
    
    func fillBuffer(_ buffer: AVAudioPCMBuffer) {
        doProcessing(buffer)
    }
    
    func scheduleBuffer() {
        let buffer = prepareBuffer()
        self.scheduleBuffer(buffer) {
            if self.isPlaying {
                self.scheduleBuffer()
            }
        }
    }
    
    func preparePlaying() {
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
    }
    
    
    func seekToTime(_ percentage:Double){
       
        file?.framePosition =  AVAudioFramePosition(( (file?.duration)! * percentage )*(file?.sampleRate)!)

    }
    
    //MARK:= processing block
    private func doProcessing(_ buffer: AVAudioPCMBuffer){
        do{
        try file?.read(into: buffer)
        }catch{
            delegate?.ReachedEnd()
            return;
        }
        let left = buffer.floatChannelData?[0]
        let right = buffer.floatChannelData?[1]
        switch processingMethodology {
        case .leftSolo:
            leftMonoChannel(left: left, right: right)
        case .rightSolo:
            rightMonoChannel(left: left, right: right)
        case .midSolo:
            midSolo(left: left, right: right)
        case .sideSolo:
            sideSolo(left: left, right: right)
        case .swapLeftRightChannel:
            swapLeftRightChannel(left: left, right: right )
        default:
            print("none")
        }
        buffer.frameLength = bufferCapacity
    }
    
    private func swapLeftRightChannel(left : UnsafeMutablePointer<Float>? , right : UnsafeMutablePointer<Float>?){
                for frame in 0..<Int(bufferCapacity) {
                    let temp = left?[frame]
                    left?[frame] = (right?[frame])!
                    right?[frame] = temp!
                }
    }
    
    
    private func leftMonoChannel(left : UnsafeMutablePointer<Float>? , right : UnsafeMutablePointer<Float>?){
        for frame in 0..<Int(bufferCapacity) {
            right?[frame] = (left?[frame])!
        }
    }
    
    private func rightMonoChannel(left : UnsafeMutablePointer<Float>? , right : UnsafeMutablePointer<Float>? ){
        for frame in 0..<Int(bufferCapacity) {
            left?[frame] = (right?[frame])!
        }
    }
    
    private func midSolo(left : UnsafeMutablePointer<Float>? , right : UnsafeMutablePointer<Float>?){
        for frame in 0..<Int(bufferCapacity) {
            let temporaryRightData = right?[frame]
            let temporaryLeftData = left?[frame]
            let mid = 0.5 * (temporaryLeftData! + temporaryRightData!)
            left?[frame] = mid
            right?[frame] = mid
        }
    }
    
    private func sideSolo(left : UnsafeMutablePointer<Float>? , right : UnsafeMutablePointer<Float>?){
        for frame in 0..<Int(bufferCapacity) {
            let temporaryRightData = right?[frame]
            let temporaryLeftData = left?[frame]
            let side =  (temporaryLeftData! - temporaryRightData!)
            left?[frame] = side
            right?[frame] = side
        }
    }
    

}
