//
//  ViewController.swift
//  AudioInterfaces
//
//  Created by Alessandro Manni on 12/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var padView: PadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        padView.buttonAction = {
            self.padView.button.setTitle("Test action", for: UIControlState())
            self.padView.setNeedsLayout()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
