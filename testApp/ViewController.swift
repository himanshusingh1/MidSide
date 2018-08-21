//
//  ViewController.swift
//  testApp
//
//  Created by Himanshu on 20/08/18.
//  Copyright © 2018 craterZone. All rights reserved.
//

import UIKit
import AudioKit
class ViewController: UIViewController {
    let ap = AudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapPlay(_ sender: Any) {
       ap.loadSong()
    }
    
}

