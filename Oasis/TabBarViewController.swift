//
//  TabBarViewController.swift
//  Oasis
//  TabBarViewController to provide flat relationship between View Controllers for the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source:
//
//  Created by Greeley Lindberg and William Parlan on 12/2/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import UIKit
import AVFoundation

class TabBarViewController: UITabBarController {
    // MARK: - Local Variables
    let musicPlayer = MusicPlayer()
    var music: Bool = true
    
    // MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectedIndex = 2
        loadMusic()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadMusic()
    }
    
    // MARK: - Music Helper Functions
    func loadMusic(){
        music = UserDefaults.standard.bool(forKey: "Music")
        print("restoring music settings")
        print(music)
        if music{
            startMusic()
        }
        else{
            stopMusic()
        }
    }
    func startMusic(){
        musicPlayer.startBackgroundMusic()
        music = true
        UserDefaults.standard.setValue(true, forKey: "Music")
    }
    func stopMusic(){
        musicPlayer.stopBackgroundMusic()
        music = false
        UserDefaults.standard.setValue(false, forKey: "Music")
        print("Default set to false")
    }
    func toggleMusic(){
        if music{
            stopMusic()
        }
        else{
            startMusic()
        }
    }
}
