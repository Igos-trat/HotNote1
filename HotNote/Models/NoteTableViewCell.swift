//
//  NoteTableViewCell.swift
//  HotNote
//
//  Created by Игорь Ущин on 06.07.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    static let identifier = "NoteTableViewCell"
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    
   func setup(note: Note) {
        titleLabel.text = note.title
        descriptLabel.text = note.desc
    }
}
