//
//  SettingsViewController.swift
//  BounceSpriteKit2
//
//  Created by Kameron Haramoto on 4/18/17.
//  Copyright © 2017 Larry Holder. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var soundEffectToggle: UISwitch!
    @IBOutlet weak var backgroundMusicToggle: UISwitch!
    var soundEffectOn = true
    var backgroundMusicOn = true
    let prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundEffectOn = prefs.bool(forKey: "Sound")
        backgroundMusicOn = prefs.bool(forKey: "BGMusic")
        // Do any additional setup after loading the view.
        if(soundEffectOn){
            soundEffectToggle.isOn = true
        }
        else{
            soundEffectToggle.isOn = false
        }
        if(backgroundMusicOn){
            backgroundMusicToggle.isOn = true
        }
        else{
            backgroundMusicToggle.isOn = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func soundEffectChanged(_ sender: UISwitch) {
        if soundEffectToggle.isOn{
            soundEffectOn = true
            prefs.set(true, forKey: "Sound")
        }
        else{
            soundEffectOn = false
            prefs.set(false, forKey: "Sound")
        }
        prefs.synchronize()
    }

    @IBAction func backgroundMusicChanged(_ sender: UISwitch) {
        if backgroundMusicToggle.isOn{
            backgroundMusicOn = true
            prefs.set(true, forKey: "BGMusic")
        }
        else{
            backgroundMusicOn = false
            prefs.set(false, forKey: "BGMusic")
        }
        prefs.synchronize()
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "UnwindFromSettings", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
