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

class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /* UI */
        collectionView?.backgroundColor = .yellow
        
        /* FIREBASE */
        FirebaseApp.configure()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        Auth.auth().signIn(withEmail: "rioweber@gmail.com", password: "asdfasdf") { (user, error) in
            // ...
        }
        
        ref.child("users").setValue(["username": "u"])
        ref.child("users2").setValue(["username": "Weber"])
        ref.child("last_sign_in").setValue(["time": NSDate().timeIntervalSince1970])
        
        let userID = Auth.auth().currentUser?.uid
        print("USERID: " + userID!)
        
    }

    // OTHER
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

