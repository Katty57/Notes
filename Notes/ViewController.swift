//
//  ViewController.swift
//  Notes
//
//  Created by  User on 16.12.2021.
//  Copyright © 2021 abr. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!

    private var model: [MyNote] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        title = "Notes"
        loadNotes()
    }

    @IBAction func didTapNote () {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else { return }
        
        vc.title = "New Note"
        vc.completion = { title, text in
            self.navigationController?.popToRootViewController(animated: true)
            
            let myNote = MyNote(context: context)
            myNote.title = title
            myNote.note = text
            myNote.time = Date()
            ad.saveContext()
            self.loadNotes()
            self.table.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: - Table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = model[indexPath.row].title
        cell?.detailTextLabel?.text = model[indexPath.row].note
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else{
        return }
        
        vc.titleNote = model[indexPath.row].title ?? ""
        vc.note = model[indexPath.row].note ?? ""

        navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] action, view, completionHandler in
            context.delete(self.model[indexPath.row])
            self.model.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
            
            ad.saveContext()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func loadNotes () {
        let fetchRequest: NSFetchRequest<MyNote> = MyNote.fetchRequest()
        
        do {
            self.model = try context.fetch(fetchRequest)
            self.model.sort(by: {firstNote, secondNote in  
                if let firstTime = firstNote.time, let secondTime = secondNote.time {
                    return firstTime > secondTime
                } else {
                    return firstNote.time == nil && secondNote.time == nil
                }})
            if self.model.count > 0 {
                self.label.isHidden = true
                self.table.isHidden = false
            }
        } catch {
            print("Cannot access to data base")
        }
    }
}

