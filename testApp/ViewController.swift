//
//  ViewController.swift
//  testApp
//
//  Created by Himanshu on 20/08/18.
//  Copyright © 2018 craterZone. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
class ViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    var currenttrack = 0;
    let pl = playingLayer.shared
    var mediaItems = MPMediaQuery.songs().items
    override func viewDidLoad() {
        super.viewDidLoad()
        
            switch MPMediaLibrary.authorizationStatus(){
            case .authorized:
                print("g")
            case .denied, .notDetermined, .restricted:
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            }
        
        pl.setSong((mediaItems?[0].assetURL!)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapPlay(_ sender: Any) {
        pl.togglePlayPause()
    }
    
    @IBAction func seeker(_ sender: UISlider) {
        pl.seekToTime(Double(sender.value))
    }
    
    @IBAction func previous(_ sender: Any) {
        if currenttrack > 0{
        pl.setProcessingMechanism(.swapLeftRightChannel)
        currenttrack = currenttrack - 1
            pl.setSong((mediaItems?[currenttrack].assetURL!)!)
        }
        
    }
    @IBAction func next(_ sender: Any) {
        if currenttrack < (mediaItems?.count)!{
            currenttrack = currenttrack + 1
            pl.setSong((mediaItems?[currenttrack].assetURL!)!)
        }

    }
}

