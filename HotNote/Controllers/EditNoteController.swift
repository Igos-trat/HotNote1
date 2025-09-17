//
//  EditNoteController.swift
//  HotNote
//
//  Created by Игорь Ущин on 06.07.2022.
//

import UIKit

class EditNoteController: UIViewController {
    
    static let identifier = "EditNoteController"
    
    var note: Note!
    weak var delegate: NoteDelegate?

    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = note?.text
        textView.resignFirstResponder()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Methods to implement
    private func updateNote() {
        note.lastUpdated = Date()
        CoreDataManager.shared.save()
        delegate?.refreshNotes()
    }
    
    private func deleteNote() {
        delegate?.deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
    }
}

// MARK: - UITextView Delegate
extension EditNoteController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note?.text = textView.text
        if note?.title.isEmpty ?? true {
            deleteNote()
        } else {
            updateNote()
    }
}
    
}
