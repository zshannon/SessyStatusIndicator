//
//  ViewController.swift
//  SessyStatusIndicator
//
//  Created by Zane Shannon on 8/1/18.
//  Copyright © 2018 Zane Shannon. All rights reserved.
//

import SessyStatusIndicator
import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel?
  @IBOutlet weak var statusIndicator: SessyStatusIndicator?
  var timer = Timer()
  var count = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Asset.one.color
    self.statusIndicator?.backgroundColor = Asset.two.color.withAlphaComponent(0.3)
    self.statusIndicator?.tintColor = Asset.four.color
    self.label?.alpha = 0.0
    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
      self.startTimer()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.timer.invalidate()
    self.label?.alpha = 0.0
    UIView.animate(withDuration: 0.15, animations: {
      self.view.backgroundColor = Asset.three.color
    })
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    UIView.animate(withDuration: 0.30, animations: {
      self.view.backgroundColor = Asset.one.color
    }) { (_) in
      self.startTimer()
    }
  }
  
  func startTimer() {
    self.count = 0
    self.timer = .scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.tick), userInfo: nil, repeats: true)
    self.label?.alpha = 0.0
  }
  
  func timerDoner() {
    self.timer.invalidate()
    UIView.animate(withDuration: 0.15, animations: {
      self.label?.alpha = 1.0
    })
  }
  
  @objc func tick() {
    self.count = min(self.count + (Double(arc4random_uniform(10)) / 100.0), 1.0)
    self.statusIndicator?.set(self.count)
    if self.count == 1.0 {
      self.timerDoner()
    }
  }

}

