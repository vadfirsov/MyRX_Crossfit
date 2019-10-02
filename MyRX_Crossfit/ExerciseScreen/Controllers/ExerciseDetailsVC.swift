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
    
    private let cellID = "RECORD_CELL_ID"
    var exercise = Exercise()
    private var recs = [ExerciseRec]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addRecordView: UIView!
    @IBOutlet weak var repsTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRecordView.isHidden = true
        self.title = exercise.name
//        if let records
        
//        if let records = exercise.exerciseRecs?.allObjects as? [ExerciseRec] { recs = records }
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    //MARK: - BUTTON FUNCS -
    @IBAction func saveNewRec(_ sender: UIButton) {
        addRecordView.isHidden = true
//        let rec = Exercis
        //save the rec and reload tableview
    }
    
    @IBAction func cancelSaveNewRec(_ sender: UIButton) {
        addRecordView.isHidden = true
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
         addRecordView.isHidden = false
     }
     
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
         
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
//        cell.delegate = self
        return cell
    }
}

//extension ExerciseDetailsVC : RecordCellDelegate {
//
//    func pickerWasChosen() {
//        tableView.reloadData()
//    }
//}
