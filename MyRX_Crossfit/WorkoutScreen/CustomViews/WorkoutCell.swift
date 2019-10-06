//
//  WorkoutCell.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 06/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {

    @IBOutlet weak var moreDetailsView: UIView!
    @IBOutlet weak var workoutView: UIView!
    //    var showMoreDetails = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        moreDetailsView.isHidden = !showMoreDetails
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

