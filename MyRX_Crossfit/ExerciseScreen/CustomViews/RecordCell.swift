//
//  RecordCell.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 01/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol RecordCellDelegate {
//    func pickerWasChosen()
//    func addNewRecordTapped()
    func deleteRow(atIndex index : Int)
}

class RecordCell: UITableViewCell {

    var delegate : RecordCellDelegate?
    
    private var isPickersAvailable = false
    private var componentNum = 1
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightAndRepsLabel: UILabel!
    
    override func awakeFromNib() {

        
    }
    
    private func newCellAllowEditing() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func deleteTapped(_ sender: UIButton) {
    
    }

    
    
}
