//
//  ViewController.swift
//  CoreMotionExample
//
//  Created by Maxim Bilan on 1/21/16.
//  Copyright © 2016 Maxim Bilan. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {

	let motionManager = CMMotionManager()
	var timer: Timer!
    var engine = AVAudioEngine()
    var audioPlayer:AVAudioPlayerNode!
    var file : AVAudioFile!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        engine.stop()
        engine = AVAudioEngine()
        do{
            let url = Bundle.main.url(forResource:"Whip", withExtension:"wav")!
            file = try AVAudioFile(forReading: url)
            audioPlayer = AVAudioPlayerNode()
            engine.attach(audioPlayer)
            engine.connect(audioPlayer, to: engine.mainMixerNode, format: file.processingFormat)

            
            engine.prepare()
            try engine.start()

        }
        catch {
            print ("error")
        }


		motionManager.startAccelerometerUpdates()
		motionManager.startGyroUpdates()
		//motionManager.startMagnetometerUpdates()
		//motionManager.startDeviceMotionUpdates()
		
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
	}

	@objc func update() {
		if let accelerometerData = motionManager.accelerometerData {
            print("accel-> ", accelerometerData)

            if accelerometerData.acceleration.z > 0.9{
                audioPlayer.scheduleFile(file, at: nil)
                audioPlayer.play()
                print("accel-> ", accelerometerData)
            }
		}
		if let gyroData = motionManager.gyroData {
            if gyroData.rotationRate.x > 10 {
                //audioPlayer.scheduleFile(file, at: nil)

                //audioPlayer.play()
                print("gyro -> ", gyroData.rotationRate)
            }
			
		}
        
       
		/*if let magnetometerData = motionManager.magnetometerData {
			print("magneto-> ", magnetometerData)
		}
		if let deviceMotion = motionManager.deviceMotion {
			print("motion-> ", deviceMotion)
		}*/
        
        print("---------")
	}
	
}
