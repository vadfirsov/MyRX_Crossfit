//
//  WorkoutsVC.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 06/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit


class WorkoutsVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let segueID = "ADD_MEW_WORKOUT_ID"
    private let cellID = "WORKOUT_CELL_ID"
    private var workouts = [Workout]()
    private let dbManager = CoreDataManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workouts = dbManager.workoutsFromDB()
        
    }
    
    //MARK: - ADD BUTTON -
    @IBAction func addWorkoutTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AddWorkoutVC {
            destinationVC.delegate = self
        }
    }
    
    //MARK: - TABLEVIEW METHODS -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? WorkoutCell else { return UITableViewCell() }
        cell.moreDetailsView.isHidden = !workouts[indexPath.row].shouldShowDetails
        return cell
    }
    let context = AppDelegate.viewContext

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showDetails = workouts[indexPath.row].shouldShowDetails
        workouts[indexPath.row].shouldShowDetails = showDetails ? false : true
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if workouts[indexPath.row].shouldShowDetails {
            return 400
        }
        return 100
    }
}

extension WorkoutsVC : AddWorkoutDelegate {
    func received(workouts: [Workout]) {
        self.workouts = workouts
        tableView.reloadData()
    }
}
//let workout = Workout(context: context)
//workout.details = "habjjs sjdgfnakj df akg skdg sdkg akrhjg khsg dskfg dskgfhds gsd"
//workout.time = "20:20"
//workout.weights = "90kg"
//workouts = dbManager.save(workout: workout)
