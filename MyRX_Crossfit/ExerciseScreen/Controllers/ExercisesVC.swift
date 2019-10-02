//
//  ViewController.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 01/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit
import CoreData

class ExercisesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let cellID = "EXERCISE_CELL_ID"
    private let segueID = "GO_TO_EXERCISE_DETAILS"

    private var isEditMode = false
    private var exercises = [Exercise]()
    private var cellIndex = 0
        
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    @IBOutlet weak var editBarBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        loadExercisesFromDB()
    }
    
    //MARK: - TABLEVIEW METHODS -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ExerciseCell else { return UITableViewCell() }
        cell.deleteBtn.isHidden = !isEditMode
        cell.nameLabel.text = exercises[indexPath.row].name
        cell.cellIndex = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditMode {
            showEditExerciseNameAlert(exerciseIndex: indexPath.row)
        }
        else {
            cellIndex = indexPath.row
            performSegue(withIdentifier: segueID, sender: self)
        }
    }
    
    //MARK: - ALERT METHODS -
    private func showAddNewRowAlert() {

        let alert = UIAlertController(title: "Add New Exercise", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Exerice Name" }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in

            guard let exercise = alert.textFields?.first?.text else { return }

            if self.exercises.contains(where: { $0.name == exercise }) {
                self.showExerciseAlreadyExistsAlert()
            }
            else {
                self.save(exercisee: exercise)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showEditExerciseNameAlert(exerciseIndex index : Int) {
        let alert = UIAlertController(title: "Change Exercise Name", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Exerice Name" }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { (_) in
            
            guard let exercise = alert.textFields?.first?.text else { return }
            self.edit(exercise: exercise, atIndex: index)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteExerciseAlert(exerciseIndex index : Int) {
        let alert = UIAlertController(title: "Uh - Oh!", message: "You are about to delete an exercise", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            
            self.delete(exercise: self.exercises[index].name!)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func showExerciseAlreadyExistsAlert() {
        let alert = UIAlertController(title: "Uh - Oh!", message: "Exercise already exists!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    //MARK: - NAV BAR METHODS -
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        
        isEditMode = isEditMode ? false : true
        addBarBtn.isEnabled = !isEditMode
        editBarBtn.title = isEditMode ? "Save" : "Edit"
        
        tableView.reloadData()
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        showAddNewRowAlert()
    }
    
    //MARK: - CORE DATA -
    func save(exercisee : String) {
    
        let context = AppDelegate.viewContext
        let exercise = Exercise(context: context)
        exercise.name = exercisee
        
        do { try context.save() }
        catch { print(error.localizedDescription) }
        
        loadExercisesFromDB()
    }
    
    func loadExercisesFromDB() {
        
        let request : NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: "name",
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare(_:))
        )]
        let context = AppDelegate.viewContext
        do {
            exercises = try context.fetch(request)
        }
        catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func edit(exercise exerciseName : String, atIndex index : Int) {
        let request : NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let context = AppDelegate.viewContext
        let exercisesDB = try? context.fetch(request)
        for exercise in exercisesDB! {
            if exercise.name == exercises[index].name {
                exercise.name = exerciseName
            }
        }
        
        do { try context.save() }
        catch { print(error.localizedDescription) }
        
        loadExercisesFromDB()

    }
    
    func delete(exercise exerciseName : String) {
        let request : NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let context = AppDelegate.viewContext
        let exercisesDB = try? context.fetch(request)
        for exercise in exercisesDB! {
            if exercise.name == exerciseName {
                context.delete(exercise)
            }
        }
        loadExercisesFromDB()
    }
    
    //MARK: - SEGUE METHODS -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ExerciseDetailsVC else { return }
        destinationVC.exercise = exercises[cellIndex]
        
    }
}

extension ExercisesVC : ExerciseCellDelegate {
    
    //MARK: - CELL DELEGATE -
    func deleteBtnTapped(cellIndex: Int) {
        showDeleteExerciseAlert(exerciseIndex: cellIndex)
    }
}
