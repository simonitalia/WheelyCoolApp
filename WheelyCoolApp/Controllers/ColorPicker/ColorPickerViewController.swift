//
//  ViewController.swift
//  WheelyCoolApp
//
//  Created by Simon Italia on 7/2/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    //MARK: - Storyboard Connections
    
    @IBOutlet weak var colorPickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    //MARK: - Class Properties
    
    enum Identifier {
        enum Segue {
            static let toColorsVC = "segueToColorsVC"
            static let toColorWheelVC = "segueToColorWheelVC"
        }
    }

    private weak var childVC: ColorsViewController?
    private lazy var allColors = [Color]()
    private lazy var selectedColors = [Color]()
 
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    
    //MARK: - ViewController Configuration
    
    private func configureVC() {
        let primaryColors = createColorSet(for: .primary)
        allColors.append(contentsOf: primaryColors)
        
        let secondaryColors = createColorSet(for: .secondary)
        allColors.append(contentsOf: secondaryColors)
        
        configurePickerView()
    }
    
    
    private func configurePickerView() {
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
    }
}


//MARK: - ColorPicker Delegate

extension ColorPickerViewController: UIPickerViewDelegate {

    //pass selected color to tableview
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row != 0 else { return }
        let color = allColors[row - 1]  //deduct 1 to compensate for header row
        let hasColor = selectedColors.contains { $0.name == color.name }
        guard !hasColor else { return }
        
        selectedColors.append(color)
        childVC?.updateColors(with: color)
    }
}


//MARK: - ColorPicker DataSource

extension ColorPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allColors.count + 1 //allow for header row
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard !allColors.isEmpty else { fatalError("PickerRowTitle should not be nil") }
        
        if row == 0 {
            return "SELECT 3 OR MORE COLORS:"
            
        } else {
            return allColors[row - 1].name.uppercased()
        }
    }
}


//MARK: - Setup DestinationVCs Data Communication

extension ColorPickerViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //childVC / ColorsVC Communication
        if let destinationVC = segue.destination as? ColorsViewController, segue.identifier == Identifier.Segue.toColorsVC {
            self.childVC = destinationVC
            destinationVC.delegate = self
        }
        
        //childVC / ColorsVC Communication
        if let destinationVC = segue.destination as? ColorWheelViewController, segue.identifier == Identifier.Segue.toColorWheelVC {
            destinationVC.colors = self.selectedColors
        }
    }
}


//MARK: - ColorsViewController Delegate

extension ColorPickerViewController: ColorsViewControllerDelegate {
    func updateSelectedColors(to colors: [Color]) {
        selectedColors.removeAll()
        selectedColors = colors
    }
    
    func doneButtonState(enabled: Bool) {
        guard enabled != doneButton.isEnabled else { return }
        
        doneButton.isEnabled = enabled
        DispatchQueue.main.async {
            enabled ? (self.doneButton.backgroundColor = .systemBlue) : (self.doneButton.backgroundColor = .systemGray)
        }
    }
}
