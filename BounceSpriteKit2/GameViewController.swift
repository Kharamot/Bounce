//
//  GameViewController.swift
//  BounceSpriteKit2
//
//  Created by Larry Holder on 4/4/17.
//  Copyright © 2017 Larry Holder. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let prefs = UserDefaults.standard
    var soundOn = true
    var BGMusicOn = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (prefs.string(forKey: "FirstTime") != nil)
        {
            print ("UserDefault Sound is defined")
            soundOn = prefs.bool(forKey: "Sound")
            BGMusicOn = prefs.bool(forKey: "BGMusic")
        } else{
            prefs.set(true, forKey: "Sound")
            prefs.set(true, forKey: "BGMusic")
            prefs.set("NO", forKey: "FirstTime")
            prefs.synchronize()
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                //scene.userData?.setObject(sound ?? true, forKey: "sound" as NSCopying)
                //scene.userData?.setObject(BG ?? true, forKey: "BG" as NSCopying)
                // Present the scene
                view.presentScene(scene)
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotosettings"){
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.soundEffectOn = self.soundOn
            settingsVC.backgroundMusicOn = self.BGMusicOn
        }
    }
    @IBAction func unwindFromSettings(sender: UIStoryboardSegue) {
        let sv = sender.source as! SettingsViewController
        soundOn = sv.soundEffectOn
        BGMusicOn = sv.backgroundMusicOn
    }
}
