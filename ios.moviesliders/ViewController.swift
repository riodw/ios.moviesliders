//
//  ViewController.swift
//  ios.moviesliders
//
//  Created by Riorden Weber on 12/29/17.
//  Copyright © 2017 Riorden Weber. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import LBTAComponents



class ViewController: DatasourceController {
    
    let step: Float = 2 // UISlider to snap to steps
//    var roundedStepValue: Float = 0
    var timer = Timer()
    let mySlider = UISlider(frame:CGRect(x: 0, y: 0, width: 340, height: 30))
    let mySlider2 = UISlider(frame:CGRect(x: 10, y: 200, width: 300, height: 20))
    let btn = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
    let btn2 = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 50))
    /* FIREBASE */
    var ref: DatabaseReference!
    
    var start: Bool = false
    var pause: Bool = false
    
    var w: CGFloat = 0
    var y: CGFloat = 0
    
    
    /* MAIN */
    override func viewDidLoad() {
        super.viewDidLoad()
        /* UI */
        collectionView?.backgroundColor = .white
        

        
        
        /* INIT OBJECTS */
        
        self.w = view.bounds.width
        self.y = view.bounds.height
        
        self.view.frame =  CGRect(x:0, y: 0, width: 100, height: y)
        
        
        mySlider.minimumValue = 0
        mySlider.maximumValue = 100
        mySlider.isContinuous = true
        mySlider.tintColor = UIColor.green
        mySlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        // width (height)
        mySlider.bounds.size.width = y-150
        mySlider.center = CGPoint(x: w/2-25, y: y/2+10)
        mySlider.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi / 2))
        
        mySlider2.minimumValue = 0
        mySlider2.maximumValue = 100
        mySlider2.isContinuous = true
        mySlider2.tintColor = UIColor.green
        mySlider2.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        // width (height)
        mySlider2.bounds.size.width = y-150
        mySlider2.center = CGPoint(x: w/2+25, y: y/2+10)
        mySlider2.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi / 2))
        
        
        btn.backgroundColor = UIColor.green
        btn.setTitle("START", for: .normal)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn.tag = 1
        btn.frame.origin = CGPoint(x: 0, y: y-10)
        
        
        btn2.backgroundColor = UIColor.green
        btn2.setTitle("Play", for: .normal)
        btn2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        btn2.tag = 1
        btn2.frame.origin = CGPoint(x: w-100, y: y-10)
        
        // Swipe
        
        
//        let gesture = UISwipeGestureRecognizer()
//        gesture.addTarget(self, action: #selector(handleSwipe(_:)))
//        gesture.direction = .up
//        self.view.addGestureRecognizer(gesture)
        
        
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer()
            gesture.addTarget(self, action: #selector(handleSwipe(_:)))
            
//            let gesture = UISwipeGestureRecognizer(target: self, action: Selector(("handleSwipe:")))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        
        
        // clich
        // interest
        
        /* ADD OBJECTS */
        self.view.addSubview(mySlider)
        self.view.addSubview(mySlider2)
        self.view.addSubview(btn)
        self.view.addSubview(btn2)
        
        
        
        /* FIREBASE */
        FirebaseApp.configure()
        //        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        Auth.auth().signIn(withEmail: "riodweber@gmail.com", password: "asdfasdf") { (user, error) in
            self.ref.child("users").setValue(["username": "Weber"])
            self.ref.child("last_sign_in").setValue(["time": NSDate().timeIntervalSince1970])
            
            let userID = Auth.auth().currentUser?.uid
            print("USERID: " + userID!)
        }
        
        /* LOGIC */
        scheduledTimerWithTimeInterval()
        
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer!) {
//        print(sender.direction)
        
        if (sender.direction == UISwipeGestureRecognizerDirection.up) {
            self.btn.frame.origin = CGPoint(x: 0, y: y-50)
            self.btn2.frame.origin = CGPoint(x: w-100, y: y-50)
        }
        if (sender.direction == UISwipeGestureRecognizerDirection.down) {
            self.btn.frame.origin = CGPoint(x: 0, y: y-10)
            self.btn2.frame.origin = CGPoint(x: w-100, y: y-10)
        }
        
    }
    
    
    
   
    @objc func sliderValueDidChange(_ sender2:UISlider!) {
//        print("Slider value changed")
        
        // Use this code below only if you want UISlider to snap to values step by step
//        roundedStepValue = round(sender2.value / step) * step
//        sender2.value = roundedStepValue
        
//        print("Slider step value \(Int(roundedStepValue))")
    }
    
    /* START UPDATE */
    func scheduledTimerWithTimeInterval() {
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        let interval: Double = 2
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
    }
    
    /* RUN EVERY 2 SECONDS */
    @objc func updateCounting() {
//        NSLog("counting...")
        
        if (self.start && self.pause) {
            let roundedStepValue: Float = round(self.mySlider.value / step) * step
            let roundedStepValue2: Float = round(self.mySlider2.value / step) * step
            
//            self.mySlider.value = roundedStepValue
            print("Slider 1 value \(Int(roundedStepValue))")
            print("Slider 2 value \(Int(roundedStepValue2))")
            
            // push change
            self.ref.child("value").childByAutoId().setValue(roundedStepValue)
            self.ref.child("value2").childByAutoId().setValue(roundedStepValue2)
        } else {
            print("OFF")
        }
        
    }
    
    /* BUTTON (Start, Stop) */
    @objc func buttonAction(sender: UIButton!) {
//        let btnsendtag: UIButton = sender
        
//        print("CLICKED")
//        print(btnsendtag.tag)
//        if btnsendtag.tag == 1 {
//            dismiss(animated: true, completion: nil)
//        }
        if (self.start == false) {
            self.start = true
            self.btn.backgroundColor = UIColor.red
            self.btn.setTitle("STOP", for: .normal)
        } else {
            self.start = false
            self.btn.backgroundColor = UIColor.green
            self.btn.setTitle("START", for: .normal)
        }
    }
    
    /* BUTTON (Play, Pause) */
    @objc func buttonAction2(sender: UIButton!) {
//        let btnsendtag: UIButton = sender
        
                print("CLICKED")
        //        print(btnsendtag.tag)
        //        if btnsendtag.tag == 1 {
        //            dismiss(animated: true, completion: nil)
        //        }
        if (self.pause == false) {
            self.pause = true
            self.btn2.backgroundColor = UIColor.blue
            self.btn2.setTitle("Pause", for: .normal)
        } else {
            self.pause = false
            self.btn2.backgroundColor = UIColor.green
            self.btn2.setTitle("Play", for: .normal)
        }
    }
    
    
    // OTHER
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
