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
    private let dbManager = CoreDataManager()
    private let alertManager = AlertManager()
    
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

        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        alertManager.delegate = self
        dateTF.text = stringDateFrom(date: datePicker.date)
        recs = dbManager.recsOf(exercise: exercise)
    }
    
    //MARK: - BUTTON FUNCS -
    @IBAction func saveNewRec(_ sender: UIButton) {
        saveNewRecord()
    }
    
    @IBAction func cancelSaveNewRec(_ sender: UIButton) {
        addRecordView.isHidden = true
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
         addRecordView.isHidden = false
        dateTF.text = stringDateFrom(date: datePicker.date)
     }
     
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        isEditingNow = isEditingNow ? false : true
        editBtn.title = isEditingNow ? "Save" : "Edit"

        tableView.reloadData()
    }
    
    //MARK: - CORE DATA -
    private func saveNewRecord() {
        
        addRecordView.isHidden = true

        let reps = repsTF.text ?? ""
        let weight = weightTF.text ?? ""
        let dateStr = dateTF.text ?? ""
        let date = datePicker.date
        
        if reps.isNumeric && weight.isNumeric && dateStr != "" {
            recs = dbManager.saveNewRecord(toExercise: exercise, withReps: reps, dateStr: dateStr, weight: weight, date : date)
        }
        else {
            alertManager.showMissingParamAlert(in: self)
        }
        
        repsTF.text = ""
        weightTF.text = ""
        dateTF.text = ""

        tableView.reloadData()
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
    
    //MARK: - DATE METHODS -
    private func stringDateFrom(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        let dateString = formatter.string(from: date)

        return dateString
    }
    
    @objc func dateChanged() {
        dateTF.text = stringDateFrom(date: datePicker.date)
    }
    
    //MARK: - TABLEVIEW -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? RecordCell else { return UITableViewCell() }
        
        let weightAndReps = "You've done \(Int(recs[indexPath.row].reps)) reps with \(recs[indexPath.row].weight) kg!"
        cell.weightAndRepsLabel.text = weightAndReps
        cell.dateLabel.text = recs[indexPath.row].dateStr
        cell.delegate = self
        cell.delBtn.isHidden = !isEditingNow
        cell.cellIndex = indexPath.row
        return cell
    }
}

extension ExerciseDetailsVC : RecordCellDelegate, AlertManagerDelegate {
    //MARK: - CUSTOM ALERT DELEGATE -
    func received(indexToDelete index: Int) {
        recs = dbManager.delete(rec: recs[index], inEercise: exercise)
        tableView.reloadData()
    }
    
    //MARK: - CUSTOM CELL DELEGATE -
    func deleteRow(atIndex index: Int) {
        alertManager.showDeleteAlert(in: self, exerciseIndex: index)
    }
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
