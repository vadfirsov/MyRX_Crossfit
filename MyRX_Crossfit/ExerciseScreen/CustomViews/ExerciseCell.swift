//
//  ExerciseCell.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 01/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol ExerciseCellDelegate {
    func deleteBtnTapped(cellIndex : Int)
}

class ExerciseCell: UITableViewCell {
    
    var cellIndex = 0
    var delegate : ExerciseCellDelegate?
    var weightMeasurementUnit = "kg"
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var repsAndWeightLabel: UILabel!
    
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        delegate?.deleteBtnTapped(cellIndex: cellIndex)
    }
    
    func setLabel(withReps reps : Int, weight : Double, unit : WeightMeasurmentUnits) {
        var weightStr              = "\(weight) reps"
        if weight == 0 { weightStr = "no weight!" }
        repsAndWeightLabel.text    = "\(reps) reps w/ " + weightStr
    }
}

enum WeightMeasurmentUnits {
    case kg, lbs
}
