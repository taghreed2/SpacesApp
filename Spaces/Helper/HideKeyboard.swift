//
//  HideKeyboard.swift
//  Spaces
//
//  Created by TAGHREED on 16/06/1443 AH.
//

import Foundation
import UIKit
func hideKeyboard(view:UIView){
    
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
    
}
