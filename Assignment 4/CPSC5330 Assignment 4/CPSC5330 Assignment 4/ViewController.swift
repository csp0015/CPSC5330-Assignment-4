//
//  ViewController.swift
//  CPSC5330 Assignment 4
//
//  Created by Christian Polka on 6/15/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    var timer = Timer()
    var countTime: Int = 0
    var countdownTimer = Timer()
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label2.text = ""
        datePicker.datePickerMode = .countDownTimer
        getCurrentTime()
    }
    
    func getCurrentTime() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.currentTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func timeSelection(_ sender: UIDatePicker) {
        countTime = Int(sender.countDownDuration)
    }
    
    @IBAction func countdownButton(_ sender: UIButton) {
        if startButton.title(for: .normal) == "Stop Music" {
            stopMusic()
            return
        }
        
        countTime = Int(datePicker.countDownDuration)
        countdownTimer.invalidate()
        
        if countTime > 0 {
            startCountDown()
        }
    }
    
    func startCountDown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        startButton.setTitle("Stop Timer", for: .normal)
    }
    
    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let currentTime = formatter.string(from: Date())
        label1.text = currentTime
        
        let hour = Calendar.current.component(.hour, from: Date())
        updateBackgroundImage(hour: hour)
    }
    
    func updateBackgroundImage(hour: Int) {
        if hour < 12 {
            backgroundImageView.image = UIImage(named: "AM_Image")
        } else {
            backgroundImageView.image = UIImage(named: "PM_Image")
        }
    }
    
    @objc func countDown() {
        if countTime > 0 {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            let formattedString = formatter.string(from: TimeInterval(countTime))!
            
            label2.text = ("Time Remaining: \(formattedString)")
            countTime -= 1
        } else {
            countdownTimer.invalidate()
            startButton.setTitle("Stop Music", for: .normal)
            label2.text = "Playing Music"
            playSong()
        }
    }
    
    func playSong() {
        let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let url = url else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("error while trying to play audio")
        }
    }
    
    func stopMusic() {
        player?.stop()
        startButton.setTitle("Start Timer", for: .normal)
        label2.text = ""
    }
}
