//
//  ExerciseDetailsVC.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 01/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import CoreData

class ExerciseDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var isEditingNow = false
    private let cellID = "RECORD_CELL_ID"
    var exercise = Exercise()
    private var recs = [ExerciseRec]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addRecordView: UIView!
    @IBOutlet weak var repsTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRecordView.isHidden = true
        self.title = exercise.name
//        if let records
//        if let records = exercise.exerciseRecs?.allObjects as? [ExerciseRec] { recs = records }
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        loadExerciseRecsFromDB()
    }

    
    //MARK: - BUTTON FUNCS -
    @IBAction func saveNewRec(_ sender: UIButton) {
        addRecordView.isHidden = true
        saveNewRecord()
    }
    
    @IBAction func cancelSaveNewRec(_ sender: UIButton) {
        addRecordView.isHidden = true
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
         addRecordView.isHidden = false
     }
     
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        isEditingNow = isEditingNow ? false : true
        editBtn.title = isEditingNow ? "Save" : "Edit"

        tableView.reloadData()
    }
    
    //MARK: - CORE DATA -
    private func saveNewRecord() {
    
        let context = AppDelegate.viewContext
        let rec = ExerciseRec(context: context)
            
        rec.date = dateTF.text
        
        if let reps = Double(repsTF.text!) { rec.reps = reps }
        else { }//alert
    
        if let weight = Double(weightTF.text!) { rec.weight = weight }
        else { } //show alert
            
        rec.exercise = exercise
        
        do { try context.save() }
        catch { print(error.localizedDescription) }
        
        loadExerciseRecsFromDB()
    }
    
    private func loadExerciseRecsFromDB() {
        
        let request : NSFetchRequest<ExerciseRec> = ExerciseRec.fetchRequest()
        let context = AppDelegate.viewContext
        
        do {
            let exerciseRecs = try context.fetch(request)
            recs = []
            for rec in exerciseRecs {
                if rec.exercise == exercise {
                    recs.append(rec)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
//    private func edit(exercise exerciseName : String, atIndex index : Int) {
//        let request : NSFetchRequest<Exercise> = Exercise.fetchRequest()
//        let context = AppDelegate.viewContext
//        let exercisesDB = try? context.fetch(request)
//        for exercise in exercisesDB! {
//            if exercise.name == exercises[index].name {
//                exercise.name = exerciseName
//            }
//        }
//
//        do { try context.save() }
//        catch { print(error.localizedDescription) }
//
//        loadExercisesFromDB()
//
//    }
    
    func delete(exercise : Exercise) {
        let request : NSFetchRequest<ExerciseRec> = ExerciseRec.fetchRequest()
        let context = AppDelegate.viewContext
        let recs = try? context.fetch(request)
        for rec in recs! {
            if rec.exercise == exercise {
                context.delete(rec)
            }
        }
//        loadExercisesFromDB()
    }
    
    //MARK: - DATE METHODS -
    private func stringDateFrom(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        let dateString = formatter.string(from: date)

        return dateString
    }
    
    @objc func dateChanged() {
        let dateString = stringDateFrom(date: datePicker.date)
        dateTF.text = dateString
    }
    
    //MARK: - TABLEVIEW -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? RecordCell else { return UITableViewCell() }
        
        let weightAndReps = "You've done \(Int(recs[indexPath.row].reps)) reps with \(recs[indexPath.row].weight) kg!"
        cell.weightAndRepsLabel.text = weightAndReps
        cell.dateLabel.text = recs[indexPath.row].date
        cell.delegate = self
        cell.delBtn.isHidden = !isEditingNow
        cell.cellIndex = indexPath.row
        return cell
    }
    
    //MARK: - ALERT METHODS -
    private func showDeleteExerciseAlert(recIndex index : Int) {
        let alert = UIAlertController(title: "Uh - Oh!", message: "You are about to delete a record!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            let context = AppDelegate.viewContext
            context.delete(self.recs[index])
            self.loadExerciseRecsFromDB()
//            self.delete(exercise: self.recs[index].name!)
        }))

        self.present(alert, animated: true, completion: nil)
    }
}

extension ExerciseDetailsVC : RecordCellDelegate {
    func deleteRow(atIndex index: Int) {
        showDeleteExerciseAlert(recIndex: index)
//        recs.remove(at: index)
//        let request : NSFetchRequest<ExerciseRec> = ExerciseRec.fetchRequest()
  
    
    }

}
