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
    let sliderMinimumValue: Float = 0
    let sliderMaximumValue: Float = 100
    
//    var roundedStepValue: Float = 0
    var timer = Timer()
    // Sliders
    let interest = UISlider()
    let cliche = UISlider()
    let funny = UISlider()
    let dumb = UISlider()
    let wtf = UISlider()
    // Buttons
    let btnStart = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
    let btnPlay = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 50))
    
    let movieTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    
    var movie_name = "test"
    
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
        
        // Interest
        interest.minimumValue = sliderMinimumValue
        interest.maximumValue = sliderMaximumValue
        interest.isContinuous = true
        interest.tintColor = UIColor.red
        interest.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        // width (height)
        interest.bounds.size.width = y-150
        interest.center = CGPoint(x: w/2-((20*5)-(0*50)), y: y/2+10)
        interest.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi / 2))
        
        // Cliche
        cliche.minimumValue = sliderMinimumValue
        cliche.maximumValue = sliderMaximumValue
        cliche.isContinuous = true
        cliche.tintColor = UIColor.green
        cliche.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        cliche.bounds.size.width = y-150
        cliche.center = CGPoint(x: w/2-((20*5)-(1*50)), y: y/2+10)
        cliche.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi / 2))
        
        // Funny
        funny.minimumValue = sliderMinimumValue
        funny.maximumValue = sliderMaximumValue
        funny.isContinuous = true
        funny.tintColor = UIColor.blue
        funny.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        funny.bounds.size.width = y-150
        funny.center = CGPoint(x: w/2-((20*5)-(2*50)), y: y/2+10)
        funny.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi / 2))
        
        // Dumb
        dumb.minimumValue = sliderMinimumValue
        dumb.maximumValue = sliderMaximumValue
        dumb.isContinuous = true
        dumb.tintColor = UIColor.purple
        dumb.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        dumb.bounds.size.width = y-150
        dumb.center = CGPoint(x: w/2-((20*5)-(3*50)), y: y/2+10)
        dumb.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi / 2))

        // WTF
        wtf.minimumValue = sliderMinimumValue
        wtf.maximumValue = sliderMaximumValue
        wtf.isContinuous = true
        wtf.tintColor = UIColor.yellow
        wtf.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        wtf.bounds.size.width = y-150
        wtf.center = CGPoint(x: w/2-((20*5)-(4*50)), y: y/2+10)
        wtf.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi / 2))

        
        // BUTTONS
        // Start / Stop
        btnStart.backgroundColor = UIColor.green
        btnStart.setTitle("START", for: .normal)
        btnStart.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btnStart.tag = 1
        btnStart.frame.origin = CGPoint(x: 0, y: y-10)
        // Play / Pause
        btnPlay.backgroundColor = UIColor.green
        btnPlay.setTitle("Play", for: .normal)
        btnPlay.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        btnPlay.tag = 1
        btnPlay.frame.origin = CGPoint(x: w-100, y: y-10)
        
        
        movieTextField.placeholder = self.movie_name
        movieTextField.font = UIFont.systemFont(ofSize: 15)
        movieTextField.borderStyle = UITextBorderStyle.roundedRect
        movieTextField.autocorrectionType = UITextAutocorrectionType.no
        
        movieTextField.keyboardType = UIKeyboardType.default
        movieTextField.returnKeyType = UIReturnKeyType.done
        movieTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        movieTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        movieTextField.frame.origin = CGPoint(x: w/2-75, y: y-10-40-10)
        // movieTextField.delegate = self
        movieTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        // Swipe
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer()
            gesture.addTarget(self, action: #selector(handleSwipe(_:)))
            
            // let gesture = UISwipeGestureRecognizer(target: self, action: Selector(("handleSwipe:")))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        
        
        
        // Interest
        // c62928
        // Cliche
        // 01e675
        // Funny
        // 2ab6f6
        // Dumb
        // bd00ff
        // WTF
        // fdff00

        // https://www.charted.co/c/0d5349f
        
        /* ADD OBJECTS */
        // Sliders
        self.view.addSubview(interest)
        self.view.addSubview(cliche)
        self.view.addSubview(funny)
        self.view.addSubview(dumb)
        self.view.addSubview(wtf)
        // Buttons
        self.view.addSubview(btnStart)
        self.view.addSubview(btnPlay)
        // Text Field
        self.view.addSubview(movieTextField)
        // Show Hide Buttons
        self.view.addGestureRecognizer(tap)
        
        
        
        /* FIREBASE */
        FirebaseApp.configure()
        //        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        Auth.auth().signIn(withEmail: "riodweber@gmail.com", password: "asdfasdf") { (user, error) in
            let userID = Auth.auth().currentUser?.uid
            print("USERID: " + userID!)
            
            self.ref.child("users").child(userID!).setValue(["last_sign_in_time": NSDate().timeIntervalSince1970])
        }
        
        /* LOGIC */
        scheduledTimerWithTimeInterval()
        
    }
    
    // Text Field (Movie Name)
    @objc func textFieldDidChange(_ textField: UITextField) {
        if ((textField.text) != nil && (textField.text) != "") {
            if (textField.text?.last! == " ") {
                
                var name = textField.text!
                name.remove(at: name.index(before: name.endIndex))
                self.movie_name = name
                // Hide Keyboard
                textField.resignFirstResponder()
            }
        }
        
    }
    
    // Swipe Up/Down
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer!) {
        // SHOW
        if (sender.direction == UISwipeGestureRecognizerDirection.up) {
            self.btnStart.frame.origin = CGPoint(x: 0, y: y-50)
            self.btnPlay.frame.origin = CGPoint(x: w-100, y: y-50)
            movieTextField.frame.origin = CGPoint(x: w/2-75, y: y-10-40-10)
            
            // SLIDERS
            // interest
            self.interest.bounds.size.width = y-150
            interest.center = CGPoint(x: w/2-((20*5)-(0*50)), y: y/2+10)
            // cliche
            self.cliche.bounds.size.width = y-150
            cliche.center = CGPoint(x: w/2-((20*5)-(1*50)), y: y/2+10)
            // funny
            self.funny.bounds.size.width = y-150
            funny.center = CGPoint(x: w/2-((20*5)-(2*50)), y: y/2+10)
            // dumb
            self.dumb.bounds.size.width = y-150
            dumb.center = CGPoint(x: w/2-((20*5)-(3*50)), y: y/2+10)
            // wtf
            self.wtf.bounds.size.width = y-150
            wtf.center = CGPoint(x: w/2-((20*5)-(4*50)), y: y/2+10)
        }
        // HIDE
        if (sender.direction == UISwipeGestureRecognizerDirection.down) {
            self.btnStart.frame.origin = CGPoint(x: 0, y: y-10)
            self.btnPlay.frame.origin = CGPoint(x: w-100, y: y-10)
            movieTextField.frame.origin = CGPoint(x: w/2-75, y: y-10)
            
            // SLIDERS
            // interest
            self.interest.bounds.size.width = y-100
            interest.center = CGPoint(x: w/2-((20*5)-(0*50)), y: y/2+30)
            // cliche
            self.cliche.bounds.size.width = y-100
            cliche.center = CGPoint(x: w/2-((20*5)-(1*50)), y: y/2+30)
            // funny
            self.funny.bounds.size.width = y-100
            funny.center = CGPoint(x: w/2-((20*5)-(2*50)), y: y/2+30)
            // dumb
            self.dumb.bounds.size.width = y-100
            dumb.center = CGPoint(x: w/2-((20*5)-(3*50)), y: y/2+30)
            // wtf
            self.wtf.bounds.size.width = y-100
            wtf.center = CGPoint(x: w/2-((20*5)-(4*50)), y: y/2+30)
        }
    }
    
    
    
   // SLIDER CHANGED
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
            let interestValue: Float = round(self.interest.value / step) * step
            let clicheValue: Float = round(self.cliche.value / step) * step
            let funnyValue: Float = round(self.funny.value / step) * step
            let dumbValue: Float = round(self.dumb.value / step) * step
            let wtfValue: Float = round(self.wtf.value / step) * step
            
            // self.mySlider.value = roundedStepValue
            // print("Slider 1 value \(Int(interestValue))")
            // print("Slider 2 value \(Int(clicheValue))")
            
            // push change
            self.ref.child("movies").child(self.movie_name).child("interest").childByAutoId().setValue(interestValue)
            self.ref.child("movies").child(self.movie_name).child("cliche").childByAutoId().setValue(clicheValue)
            self.ref.child("movies").child(self.movie_name).child("funny").childByAutoId().setValue(funnyValue)
            self.ref.child("movies").child(self.movie_name).child("dumb").childByAutoId().setValue(dumbValue)
            self.ref.child("movies").child(self.movie_name).child("wtf").childByAutoId().setValue(wtfValue)
        } else {
            // Not On
            print("OFF")
        }
        
    }
    
    /* BUTTON (START, STOP) */
    @objc func buttonAction(sender: UIButton!) {
//        let btnsendtag: UIButton = sender
        
//        print("CLICKED")
//        print(btnsendtag.tag)
//        if btnsendtag.tag == 1 {
//            dismiss(animated: true, completion: nil)
//        }
        if (self.start == false) {
            self.start = true
            self.btnStart.backgroundColor = UIColor.red
            self.btnStart.setTitle("STOP", for: .normal)
        } else {
            self.start = false
            self.btnStart.backgroundColor = UIColor.green
            self.btnStart.setTitle("START", for: .normal)
            
            // Reset Sliders
            self.interest.value = 0
            self.cliche.value = 0
            self.funny.value = 0
            self.dumb.value = 0
            self.wtf.value = 0
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
            self.btnPlay.backgroundColor = UIColor.blue
            self.btnPlay.setTitle("Pause", for: .normal)
        } else {
            self.pause = false
            self.btnPlay.backgroundColor = UIColor.green
            self.btnPlay.setTitle("Play", for: .normal)
        }
    }
    
    
    // OTHER
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
