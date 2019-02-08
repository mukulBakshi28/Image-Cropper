//
//  ViewController.swift
//  MaskingImage
//
//  Created by MUKUL on 07/02/19.
//  Copyright © 2019 CoderWork. All rights reserved.
//

import UIKit

let initialWidth:CGFloat = 20.0
let initialHeight:CGFloat = 20.0

class ViewController: UIViewController {

     var oldTouch:CGPoint!
     var redView:DrawView!
     var currentWidth:CGFloat!
     var currentHeight:CGFloat!
 
    override func viewDidLoad() {
        super.viewDidLoad()
     }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        let touchPoint = touches.first?.location(in: self.view)
         oldTouch  = touchPoint
        if redView != nil {
            currentWidth = redView.frame.size.width
            currentHeight =  redView.frame.size.height
            return
         }
        redView = DrawView(point: touchPoint!)
        redView.layer.cornerRadius = redView.frame.size.height / 2
        redView.backgroundColor = UIColor.clear
        currentWidth = redView.frame.size.width
        currentHeight =  redView.frame.size.height
        self.view.addSubview(redView)
        self.addPanToView()
     }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self.view)
        let translationVectorX = touchPoint!.x - oldTouch.x
        let translationVectorY = touchPoint!.y - oldTouch.y
         if translationVectorX < 0 {return}
        if translationVectorY < 0 {return}
        
         if redView.frame.contains(touchPoint!) {
      redView.frame.size = CGSize(width: currentWidth + translationVectorX, height: currentHeight + translationVectorY)
            redView.setNeedsDisplay()
         }
      }
    
    func addPanToView() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panAction))
        redView.isUserInteractionEnabled = true
        redView.addGestureRecognizer(pan)
    }
 
    @objc func panAction(sender:UIPanGestureRecognizer) {
          let movement = sender.translation(in: self.view)
         if sender.state == .began {
            currentWidth = redView.frame.size.width
            currentHeight =  redView.frame.size.height
        }
        else if sender.state == .changed {
            if redView.frame.width < initialWidth {return}
            if redView.frame.height < initialHeight {return}
            redView.frame.size = CGSize(width: currentWidth + movement.x, height: currentHeight + movement.y)
            redView.setNeedsDisplay()
         }
      }
}

class DrawView:UIView  {
    init(point: CGPoint) {
    super.init(frame: CGRect(x: point.x, y: point.y, width: initialWidth, height: initialHeight))
     }
     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
     self.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
    let bPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 10, height: 10))
    let sLayer = CAShapeLayer()
    sLayer.path = bPath.cgPath
    sLayer.lineCap  = .butt
    sLayer.lineWidth  = 3
    sLayer.lineDashPattern = [7,3]
    sLayer.strokeColor = UIColor.green.cgColor
    sLayer.fillColor = UIColor.clear.cgColor
    self.layer.masksToBounds = true
    self.layer.addSublayer(sLayer)
    }
}
