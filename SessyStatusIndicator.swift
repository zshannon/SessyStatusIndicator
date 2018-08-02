//
//  SessyStatusIndicator.swift
//  SessyStatusIndicator
//
//  Created by Zane Shannon on 8/1/18.
//  Copyright © 2018 Zane Shannon. All rights reserved.
//

import Charts
import UIKit

enum SessyStatusIndicatorError: Error {
  case valueTooLarge
}

public class SessyStatusIndicator: UIView {
  
  public typealias SessyStatusIndicatorCallbackClosure = (Bool) -> Void
  
  public var borderRadius = CGFloat(20.0) // iPhone X Notch Radius
  public var iconSize = CGFloat(36.0)
  
  @IBOutlet weak public var bottomConstraint: NSLayoutConstraint?
  @IBOutlet weak public var leadingConstraint: NSLayoutConstraint?
  @IBOutlet weak public var widthConstraint: NSLayoutConstraint?
  
  private lazy var pieChart: PieChartView = {
    let p = PieChartView()
    p.translatesAutoresizingMaskIntoConstraints = false
    p.legend.enabled = false
    p.drawHoleEnabled = false
    p.drawEntryLabelsEnabled = false
    p.drawCenterTextEnabled = false
    p.chartDescription?.text = nil
    return p
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    if self.leadingConstraintConstant == nil {
      self.leadingConstraintConstant = self.leadingConstraint?.constant
    }
    guard let leadingConstraintConstant = self.leadingConstraintConstant else {
      return
    }
    self.leadingConstraint?.constant = CGFloat((-1 * leadingConstraintConstant)) - self.frame.width
  }
  
  public func set(_ value: Double, _ completion: SessyStatusIndicatorCallbackClosure? = nil) throws {
    guard let leadingConstraintConstant = self.leadingConstraintConstant, value <= 1.0 else {
      completion?(false)
      throw SessyStatusIndicatorError.valueTooLarge
    }
    self.renderChart(value)
    if value == 1.0 {
      self.leadingConstraint?.constant = CGFloat((-1 * leadingConstraintConstant)) - self.frame.width
      UIView.animate(withDuration: 0.30, animations: {
        self.alpha = 0.0
        self.superview?.layoutIfNeeded()
      }) { (_) in
        completion?(true)
      }
    }
    else {
      if self.leadingConstraint?.constant != CGFloat(leadingConstraintConstant) {
        self.leadingConstraint?.constant = CGFloat(leadingConstraintConstant)
        UIView.animate(withDuration: 0.30, animations: {
          self.alpha = 1.0
          self.superview?.layoutIfNeeded()
        }) { (_) in
          completion?(true)
        }
      }
      else {
        completion?(true)
      }
    }
  }
  
  private var isSetup = false
  private var leadingConstraintConstant: CGFloat?
  private func setup() {
    if self.isSetup {
      return
    }
    if !UIAccessibilityIsReduceTransparencyEnabled() {
      let blurEffect = UIBlurEffect(style: .light)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.frame = bounds
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      blurEffectView.isUserInteractionEnabled = false
      self.addSubview(blurEffectView)
    }
    self.alpha = 0.0
    self.clipsToBounds = true
    self.layer.cornerRadius = self.borderRadius
    self.leadingConstraint?.constant = -1 * self.frame.width
    self.addSubview(pieChart)
    pieChart.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
    pieChart.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
    pieChart.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3).isActive = true
    pieChart.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3).isActive = true
    self.isSetup = true
    renderChart(0.0)
  }
  
  private func renderChart(_ value: Double = 0.0) {
    let dataEntries = [PieChartDataEntry(value: 1.0 - value), PieChartDataEntry(value: value)]
    let chartDataSet = PieChartDataSet(values: dataEntries, label: nil)
    chartDataSet.colors = [self.backgroundColor!, self.tintColor]
    chartDataSet.drawValuesEnabled = false
    chartDataSet.drawIconsEnabled = false

    let chartData = PieChartData(dataSet: chartDataSet)
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 0
    chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
    chartData.setDrawValues(false)
    pieChart.data = chartData
  }
  
}
