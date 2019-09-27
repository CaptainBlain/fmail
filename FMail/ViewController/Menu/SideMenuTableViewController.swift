//
//  SideMenuTableViewController.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        self.tableView.register(UINib(nibName: "MenuHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: MenuHeaderTableViewCell.identifier)
        self.tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: MenuTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh cell blur effect in case it changed
        tableView.reloadData()
        
        guard let menu = navigationController as? UISideMenuNavigationController, menu.blurEffectStyle == nil else {
            return
        }
        
        // Set up a cool background image for demo purposes
        /*let imageView = UIImageView(image: #imageLiteral(resourceName: "saturn"))
         imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.backgroundView = imageView*/
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 0
        switch indexPath.section {
        case 0:
            height = 130
        default:
            height = 60
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
         let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.height, height: 30))
        view.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 12, y: 0, width: view.frame.size.width - 12, height: view.frame.size.height))
        label.font = UIFont.robotoBold(size: 14.0)
        view.addSubview(label)
        switch section {
        case 1:
            label.text = "Username"
        case 2:
            label.text = "Inboxes"
        default:
           label.text = ""
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        switch section {
        case 0:
            height = 0
        default:
            height = 30
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows = 0
        switch section {
        case 0:
            rows = 1
        case 1:
            rows = 1
        case 2:
            rows = 3
        case 3:
            rows = 3
        default:
            rows = 0
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: MenuHeaderTableViewCell.identifier, for: indexPath) as! MenuHeaderTableViewCell
                return cell
            default:
                return tableView.dequeueReusableCell(withIdentifier: MenuHeaderTableViewCell.identifier, for: indexPath) as! MenuHeaderTableViewCell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
            if let user = User.getUser(context: DatabaseController.shared.persistentContainer.viewContext) {
                cell.titleString = user.username ?? "Username currently unavailable"
            }
            cell.showArrowImage = false
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
            switch indexPath.row {
            case 0:
                cell.titleString = "Home"
            case 1:
                cell.titleString = "Starred"
            case 2:
                cell.titleString = "Your Mail"
            default:
                cell.titleString = ""
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
            switch indexPath.row {
            case 0:
                cell.titleString = "Settings"
            case 1:
                cell.titleString = "Terms & Conditions"
            case 2:
                cell.titleString = "Help"
            default:
                cell.titleString = ""
            }
            return cell
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {

        case 2:
            
            switch indexPath.row {
            case 0:
                let vc = PresentedViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
               let vc = PresentedViewController()
               self.navigationController?.pushViewController(vc, animated: true)
            case 2:
               let vc = PresentedViewController()
               self.navigationController?.pushViewController(vc, animated: true)
            default:
              print("Nah")
            }
           
            
        default:
             print("Nah")
        }
    }

}
