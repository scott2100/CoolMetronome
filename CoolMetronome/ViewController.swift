//
//  ViewController.swift
//  CoolMetronome
//
//  Created by Scott Young on 5/22/21.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController, NSWindowDelegate {
    
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var bpm: NSTextField!

    private var playClicked: Bool = false
    private var clickBpm: Double = 60.0 / 150.0
    private var timer:Timer? = Timer()
    private var fileURL = Bundle.main.url(forResource: "click", withExtension: "wav")!
    private var soundID:SystemSoundID = 0
    
    @IBAction func playButton(_ sender: NSButton) {
        if playClicked == false {
            playClicked = true
            timer?.invalidate()
            timer = nil
            playClick()
        } else {
            playClicked = false
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func timerAction(){
        if playClicked {
            AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @IBAction func sliderChanged(_ sender: NSSlider)
    {
        let event = NSApplication.shared.currentEvent
        let sliderValue = sender.integerValue
        bpm.stringValue = String(sliderValue)
        clickBpm = 60.0 / (Double(bpm.stringValue) ?? 0.0)
        switch event?.type {
            case .leftMouseUp, .rightMouseUp:
                if playClicked {
                    print("slider value stopped changing: \(slider.doubleValue)")
                    timer?.invalidate()
                    timer = nil
                    playClick()
                }
            default:
                break
            }
   }
    
    func windowWillClose(_ aNotification: Notification) {
        timer?.invalidate()
        timer = nil
    }
    
    func playClick () {
        AudioServicesPlaySystemSound(soundID)
        timer = Timer.scheduledTimer(timeInterval: clickBpm, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        bpm.stringValue = slider.stringValue
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.styleMask.remove(.resizable)
        view.window?.delegate = self
    }
}
