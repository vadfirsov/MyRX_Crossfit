//
//  WorkoutsVC.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 06/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit


class WorkoutsVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let segueID =      "ADD_MEW_WORKOUT_ID"
    private let cellID =       "WORKOUT_CELL_ID"
    private var workouts =     [Workout]()
    private let dbManager =    CoreDataManager()
    private let alertManager = AlertManager()
    private var isEditMode =   false
    
    @IBOutlet weak var editBtn:   UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn:    UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
//    private var sortedWorkouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertManager.delegate = self
        workouts = dbManager.workoutsFromDB()
//        sortedWorkouts = workouts
    }
    
    //MARK: - ADD BUTTON -
    @IBAction func addWorkoutTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        addBtn.isEnabled = !isEditMode
        editBtn.title = isEditMode ? "Save" : "Edit"
        isEditMode = isEditMode ? false : true
        tableView.reloadData()
    }
    
    //MARK: - TABLEVIEW METHODS -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellID, for: indexPath) as? WorkoutCell else { return UITableViewCell() }
        cell.delegate =        self
        cell.cellIndex =       indexPath.row
        cell.titleLabel.text = workouts[indexPath.row].title ?? "No Date Selected"
        cell.dateLabel.text =  workouts[indexPath.row].dateString ?? "No Label For Workout"
        cell.showDeleteButton(ifEditMode: isEditMode)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - SEGUE -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AddWorkoutVC {
            destinationVC.delegate = self
        }
    }
}

extension WorkoutsVC : AddWorkoutDelegate, WorkoutCellDelegate, AlertManagerDelegate, UISearchBarDelegate {
    //MARK: - CELL DELEGATE -
    func deleteWorkoutAt(index: Int) {
        alertManager.showDeleteAlert(in: self, itemIndex: index)
    }
    
    //MARK: - ADD WORKOUT DELEGATE -
    func received(workouts: [Workout]) {
        searchBar.text = ""
        self.workouts = workouts
        tableView.reloadData()
    }
    
    //MARK: - ALERT DELEGATE -
    func received(indexToDelete index: Int) {
        workouts = dbManager.delete(workout: workouts[index])
        tableView.reloadData()
    }
    
    //MARK: - SEARCHBAR -
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        workouts = []
        for workout in dbManager.workoutsFromDB() {
            if workout.title!.localizedStandardContains(searchBar.text!) {
                workouts.append(workout)
            }
        }
        if searchBar.text!.isEmpty {
            workouts = dbManager.workoutsFromDB()
        }
        
        tableView.reloadData()
    }
}
