//
//  CustomAlert.swift
//  gadsfgasdfds
//
//  Created by VADIM FIRSOV on 10/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol CustomAlertProtocol {
    func firstBtnTapped()
    func secondBtnTapped()
}

extension CustomAlertProtocol {
    func firstBtnTapped() {}
    func secondBtnTapped() {}
}

class CustomAlert: UIViewController {

    var delegate : CustomAlertProtocol?
    
    @IBOutlet weak var alertView: CustomView!
    
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var message:    UILabel!
    @IBOutlet weak var firstTF:    UITextField!
    @IBOutlet weak var secondTF:   UITextField!
    @IBOutlet weak var firstBtn:   CustomButton!
    @IBOutlet weak var secondBtn:  CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstBtn.isHidden = true
        secondBtn.isHidden = true
        firstTF.isHidden = true
        secondTF.isHidden = true
        alertView.setDesign()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !alertView.frame.contains(location) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setAlertProperties(title : String, body : String) {
        alertTitle.text = title
        message.text = body
    }
    
    func addFirstBtn(withTitle btnTitle : String, design : CustomButtonBorderColor) {
        firstBtn.isHidden = false
        firstBtn.setTitle(btnTitle, for: .normal)
        firstBtn.setDesign(withColor: design)
    }
    
    func addSecondBtn(withTitle btnTitle : String, design : CustomButtonBorderColor) {
        secondBtn.isHidden = false
        secondBtn.setTitle(btnTitle, for: .normal)
        secondBtn.setDesign(withColor: design)
    }
    
    @IBAction func firstBtnTapped(_ sender: CustomButton) {
        delegate?.firstBtnTapped()
    }
    
    @IBAction func secondBtnTapped(_ sender: CustomButton) {
        delegate?.secondBtnTapped()
    }
    
    
}
