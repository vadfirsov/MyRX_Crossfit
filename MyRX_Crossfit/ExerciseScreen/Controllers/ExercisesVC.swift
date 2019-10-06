//
//  ViewController.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 01/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import CoreData

//TODO: need to change name of class
class ExercisesVC: UIViewController {

    private let cellID =  "EXERCISE_CELL_ID"
    private let segueID = "GO_TO_EXERCISE_DETAILS"
    private let exerciseSegmentIndex = 0
    
    private var isEditMode = false
    private var exercises =  [Exercise]()
    private var cellIndex =  0
    
    @IBOutlet weak var addBarBtn:  UIBarButtonItem!
    @IBOutlet weak var editBarBtn: UIBarButtonItem!
    @IBOutlet weak var tableView:  UITableView!
    @IBOutlet weak var segment:    UISegmentedControl!

    private let dbManager =    CoreDataManager()
    private let alertManager = AlertManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertManager.delegate = self
        exercises = dbManager.exercisesFromDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //MARK: - NAV BAR BUTTONS -
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        isEditMode = isEditMode ? false : true
        addBarBtn.isEnabled = !isEditMode
        editBarBtn.title = isEditMode ? "Save" : "Edit"
        tableView.reloadData()
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        alertManager.showAddNewRowAlert(inVC: self, andUpdate: exercises)
    }
    
    //MARK: - SEGUE METHODS -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ExerciseDetailsVC else { return }
        destinationVC.exercise = exercises[cellIndex]
    }
    //MARK: - SEGMENT METHODS -
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        
        self.title = segment.titleForSegment(at: segment.selectedSegmentIndex)
        tableView.reloadData()
    }
    
}

extension ExercisesVC : ExerciseCellDelegate, AlertManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - CUSTOM ALERT DELEGATE -
    func received(indexToDelete index: Int) {
        exercises = dbManager.delete(exercise: exercises[index])
        tableView.reloadData()
    }
    
    func received(editedExerciseName name: String, atIndex index: Int) {
        if exercises.contains(where: { $0.name == name }) { alertManager.showExerciseAlreadyExistsAlert(in: self)
            
        }
        else {
            exercises = dbManager.edit(exercise: exercises[index], newName: name)
            tableView.reloadData()
        }
    }
    func received(newEntityName name: String) {
        exercises = dbManager.save(exerciseName: name)
        tableView.reloadData()
    }
    
    //MARK: - CELL DELEGATE -
    func deleteBtnTapped(cellIndex: Int) {
        alertManager.showDeleteAlert(in: self, exerciseIndex: cellIndex)
    }
    
    //MARK: - TABLEVIEW METHODS -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ExerciseCell else { return UITableViewCell() }
            cell.delegate           = self
            cell.deleteBtn.isHidden = !isEditMode
            cell.nameLabel.text     = exercises[indexPath.row].name
            cell.cellIndex          = indexPath.row
            
            let repsAndWeight       = dbManager.lastRecordedRepsAndWeightOf(exercise: exercises[indexPath.row])

            cell.setLabel(withReps: repsAndWeight.0, weight: repsAndWeight.1, unit: .kg)
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditMode {
            alertManager.showEditExerciseNameAlert(in: self, exerciseIndex: indexPath.row)
        }
        else {
            cellIndex = indexPath.row
            performSegue(withIdentifier: segueID, sender: self)
        }
    }
}
