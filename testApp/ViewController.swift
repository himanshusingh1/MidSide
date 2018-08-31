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
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.audio"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .overFullScreen
        self.present(importMenu, animated: true, completion: nil)
//        pl.setSong((mediaItems?[0].assetURL!)!)
        
//        let pickerController = MPMediaPickerController(mediaTypes: .music)
//        pickerController.prompt = NSLocalizedString("Add pieces to queue", comment:"");
//        pickerController.allowsPickingMultipleItems=true;
//        pickerController.delegate = self
//        self.present(pickerController, animated: true, completion: nil)
        
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
            pl.setNewSong((mediaItems?[currenttrack].assetURL!)!)
        }
        
    }
    @IBAction func next(_ sender: Any) {
        if currenttrack+1 < (mediaItems?.count)!{
            currenttrack = currenttrack + 1
            pl.setNewSong((mediaItems?[currenttrack].assetURL!)!)
        }

    }
}
extension ViewController: UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
       
        let myURL = url as URL
        print("import result : \(myURL)")
        pl.setNewSong(myURL)
        
        
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
extension ViewController:MPMediaPickerControllerDelegate{
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
       let url = mediaItemCollection.items[0].assetURL!
        pl.setNewSong(url)
        mediaPicker.dismiss(animated: true, completion: nil)
    }
}
