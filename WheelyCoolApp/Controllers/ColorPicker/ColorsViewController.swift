//
//  ColorsViewController.swift
//  WheelyCoolApp
//
//  Created by Simon Italia on 7/2/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit


//MARK: - Communication with parentVC / ColorPickerVC

protocol ColorsViewControllerDelegate: AnyObject {
    func doneButtonState(enabled: Bool)
    func updateSelectedColors(to colors: [Color])
}


class ColorsViewController: UIViewController {
    
    //MARK: - Storyboard Connections
    
    @IBOutlet weak var colorsTableView: UITableView!
    

    //MARK: - Class Properties
    
    weak var delegate: ColorsViewControllerDelegate?
    
    private let cellIdentifier = "colorCell"
    private var colors = [Color]() {
        didSet {
            DispatchQueue.main.async {
                self.colorsTableView.reloadData()
            }
            
            //save colors to user defaults
            DataPersistenceController.shared.save(colors: colors)
            
            //update button state
            if colors.count > 2 {
                delegate?.doneButtonState(enabled: true)
            
            } else {
                delegate?.doneButtonState(enabled: false)
            }
            
            delegate?.updateSelectedColors(to: colors)
        }
    }

    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    
    //MARK: - ViewController Configuration
    
    private func configureVC() {
        configureTableView()
        
        //load saved data (if any)
        if let colors = DataPersistenceController.shared.loadColors() {
            self.colors = colors
        }
    }
    
    
    private func configureTableView()  {
        colorsTableView.dataSource = self
        colorsTableView.tableFooterView = UIView() //draw empty view insetad of empty rows / row seperators
    }
}


//MARK: - UITableViewDataSource

extension ColorsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let color = colors[indexPath.row]
        let swatch = UIImage(systemName: "circle.fill")

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.imageView?.image = swatch
        cell.imageView?.tintColor = color.shade
        cell.textLabel?.text = color.name.uppercased()
        
        return cell
    }
}


//MARK: - UITableViewDelegate

extension ColorsViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            colors.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


//MARK: - ColorPickerViewControllerDelegate

extension ColorsViewController {
    
    func updateColors(with color: Color) {

        //avoid duplicate colors populating table view
        let hasColor = colors.contains {
            $0.name == color.name ? true : false
        }

        guard !hasColor else { return }
        colors.append(color)
    }
}
