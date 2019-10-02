//
//  AlertManager.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 02/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol AlertManagerDelegate {
    func received(newExerciseName name : String)
    func received(editedExerciseName name : String, atIndex index : Int)
    func received(indexToDelete index : Int)
}

class AlertManager {
    
    var delegate : AlertManagerDelegate?
    
    func showAddNewRowAlert(inVC vc : UIViewController, andUpdate exercises : [Exercise]) {

        let alert = UIAlertController(title: "Add New Exercise", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Exerice Name" }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in

        guard let exerciseName = alert.textFields?.first?.text else { return }
            if exercises.contains(where: { $0.name == exerciseName }) {
                self.showExerciseAlreadyExistsAlert(in: vc)
            }
            else {
                self.delegate?.received(newExerciseName: exerciseName)
            }
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showExerciseAlreadyExistsAlert(in vc : UIViewController) {
        let alert = UIAlertController(title: "Uh - Oh!", message: "Exercise already exists!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

    func showEditExerciseNameAlert(in vc: UIViewController, exerciseIndex index : Int) {
        let alert = UIAlertController(title: "Change Exercise Name", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Exerice Name" }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { (_) in

            guard let exerciseName = alert.textFields?.first?.text else { return }
            self.delegate?.received(editedExerciseName: exerciseName, atIndex: index)

            
        }))

        vc.present(alert, animated: true, completion: nil)
    }

    func showDeleteExerciseAlert(in vc : UIViewController, exerciseIndex index : Int) {
        let alert = UIAlertController(title: "Uh - Oh!", message: "You are about to delete an exercise", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
//            self.exercises = self.dbManager.delete(exercise: self.exercises[index])
//            self.tableView.reloadData()
            self.delegate?.received(indexToDelete: index)
        }))

        vc.present(alert, animated: true, completion: nil)
    }
    

}
