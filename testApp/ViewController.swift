//
//  ViewController.swift
//  testApp
//
//  Created by Himanshu on 20/08/18.
//  Copyright © 2018 craterZone. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    let pl = playingLayer.shared
    override func viewDidLoad() {
        super.viewDidLoad()

    pl.makeSong()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapPlay(_ sender: Any) {
        pl.togglePlayPause()
    }
    
}

