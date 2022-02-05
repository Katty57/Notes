//
//  NoteViewController.swift
//  Notes
//
//  Created by  User on 16.12.2021.
//  Copyright © 2021 abr. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteText: UITextView!
    
    var titleNote: String  = ""
    var note: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleNote
        noteText.text = note
        noteText.isEditable = false
        // Do any additional setup after loading the view.
    }

}
