//
//  ViewController.swift
//  HotNote
//
//  Created by Игорь Ущин on 05.07.2022.
//

import UIKit

protocol NoteDelegate: AnyObject {
    func refreshNotes()
    func deleteNote(with id: UUID)
}

class NoteController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    private var allNotes: [Note] = [] {
        didSet {
            filteredNotes = allNotes
        }
    }

    private let searchController = UISearchController()
    private var filteredNotes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        navigationItem.backButtonTitle = "Назад"
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Заметки"
        tableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        configureSearchBar()
        fetchNotesFromStorage()
    }
    
    private func indexForNote(id: UUID, in list: [Note]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.showsCancelButton = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.sizeToFit()
        
        if let cancelButton = searchController.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Отмена", for: .normal)
            
        }
    }

    @IBAction func createNewNote(_ sender: UIButton) {
        goToEditNote(createNote())
    }
    
    private func goToEditNote(_ note: Note) {
        let controller = storyboard?.instantiateViewController(identifier: EditNoteController.identifier) as! EditNoteController
        controller.note = note
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Methods
    private func createNote() -> Note {
        let note = CoreDataManager.shared.createNote()
        
        allNotes.insert(note, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        return note
    }
    
    private func fetchNotesFromStorage() {
      allNotes = CoreDataManager.shared.fetchNotes()
    }
    
    private func deleteNoteFromStorage(_ note: Note) {
        deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
        
    }
    
    private func searchNotesFromStorage(_ text: String) {
        allNotes = CoreDataManager.shared.fetchNotes(filter: text)
        tableView.reloadData()
    }
}

// MARK: - TableView
extension NoteController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier) as! NoteTableViewCell
        cell.setup(note: filteredNotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditNote(filteredNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNoteFromStorage(filteredNotes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

 // MARK: - Search Controller
extension NoteController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        search("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchNotesFromStorage(query)
    }
    
    func search(_ query: String) {
        if query.count >= 1 {
            filteredNotes = allNotes.filter { $0.text.lowercased().contains(query.lowercased()) }
        } else {
            filteredNotes = allNotes
        }
        
        tableView.reloadData()
    }
}

// MARK: - ListNotes Delegate
extension NoteController: NoteDelegate {
    
    func refreshNotes() {
        allNotes = allNotes.sorted { $0.lastUpdated > $1.lastUpdated }
        tableView.reloadData()
    }
    
    func deleteNote(with id: UUID) {
        let indexPath = indexForNote(id: id, in: filteredNotes)
        filteredNotes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        allNotes.remove(at: indexForNote(id: id, in: allNotes).row)
    }
}
