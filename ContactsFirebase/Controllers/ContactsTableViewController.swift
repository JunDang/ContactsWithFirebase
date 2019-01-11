//
//  ContactsTableViewController.swift
//  ContactsFirebase
//
//  Created by Jun Dang on 2019-01-03.
//  Copyright © 2019 Jun Dang. All rights reserved.
//
import UIKit
import Firebase

protocol HandleButtonDelegate: class {
    func handleFavoriteMark(cell: UITableViewCell)
}

class ContactsTableViewController: UITableViewController, HandleButtonDelegate {
    
    let cellId = "cellId"
    let uniqueHeaderSectionTag: Int = 7000
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    var contactsDictionary = [String: Names]()
    var familyArray = [String]()
    var familyKeys = [String]()
    var showIndexPath = false
    var favoritableContacts = [FavoritableContact]()
    
    private func fetchUsers() {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      
            var familyKeysWithDuplicates = [String]()
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let contact = Contact(dictionary: dictionary)
                self.familyArray.append(contact.lastName)
                familyKeysWithDuplicates = (self.familyArray.map{String($0.prefix(1))}).sorted()
                self.favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                for familyKey in familyKeysWithDuplicates {
                    var newFavoritableContacts = [FavoritableContact]()
                    for favoritableContact in self.favoritableContacts {
                        let lastName = favoritableContact.contact.lastName
                        if lastName.prefix(1) == familyKey {
                               newFavoritableContacts.append(favoritableContact)
                            }
                            let contacts = Names(isExpanded: true, names: newFavoritableContacts)
                            self.contactsDictionary[familyKey] = contacts
                         }
                  
                }
                self.familyKeys = [String](self.contactsDictionary.keys).sorted()
 
                DispatchQueue.main.async(execute: {
                   self.tableView.reloadData()
                })
            }
            
        }, withCancel: nil)
     
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        fetchUsers()
       
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = .lavenderGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(handleShowIndexPath))
         navigationItem.rightBarButtonItem?.tintColor = .lavenderGray
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
  
    }
    
  
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print("snapshot: \(snapshot)")
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let lastName = dictionary["last name"] as! String
                    let firstName = dictionary["first name"] as! String
                    self.navigationItem.title = firstName + " " + lastName + "'s contacts"
                }
                
            }, withCancel: nil)
        }
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            disPlayError(logoutError as! String)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
     }
    
    @objc func handleShowIndexPath() {
        
        var indexPathsToReload = [IndexPath]()
        
        for section in familyKeys.indices {
            if let expandableNames = contactsDictionary[familyKeys[section]] {
                if expandableNames.isExpanded {
                    for row in expandableNames.names.indices {
                        let indexPath = IndexPath(row: row, section: section)
                        indexPathsToReload.append(indexPath)
                    }
                }
            }
        }
        
        showIndexPath = !showIndexPath
        let animationStyle = showIndexPath ? UITableView.RowAnimation.right : .left
        
        tableView.reloadRows(at: indexPathsToReload, with: animationStyle)
    }
    
     @objc func handleExpandClose(_ sender: UITapGestureRecognizer) {
        
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let imageView = headerView.viewWithTag(uniqueHeaderSectionTag + section) as? UIImageView
        var indexPaths = [IndexPath]()
        guard let expandableNames = contactsDictionary[familyKeys[section]] else {
            return
        }
        
        for row in expandableNames.names.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isExpanded = expandableNames.isExpanded
        expandableNames.isExpanded = !isExpanded
        
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
            UIView.animate(withDuration: 0.4, animations: {
                imageView?.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
            UIView.animate(withDuration: 0.4, animations: {
                imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
   override func numberOfSections(in tableView: UITableView) -> Int {
        return contactsDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .babyBlue
        header.textLabel?.textColor = .white
        
        if let viewWithTag = self.view.viewWithTag(uniqueHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "arrow")
        theImageView.tag = uniqueHeaderSectionTag + section
        header.addSubview(theImageView)
        
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ContactsTableViewController.handleExpandClose(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
    guard let expandableNames = contactsDictionary[familyKeys[section]] else {
            return 0
        }
        if expandableNames.isExpanded == false {
            return 0
        }
        let count = expandableNames.names.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return familyKeys.sorted()[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        cell.delegate = self
        let favoritableContact = contactsDictionary[familyKeys[indexPath.section]]?.names[indexPath.row]
        if let favoritableContact = favoritableContact {
            cell.textLabel?.text = favoritableContact.contact.firstName + " " + favoritableContact.contact.lastName
            cell.detailTextLabel?.text = favoritableContact.contact.email
            cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? .blue : .lightGray
            if showIndexPath {
                cell.textLabel?.text = favoritableContact.contact.firstName + " " + favoritableContact.contact.lastName
            }
        }
        return cell
    }
    
    func handleFavoriteMark(cell: UITableViewCell) {
  
        guard  let indexPathTapped = tableView.indexPath(for: cell) else {
            return
        }
        guard let expandableNames = contactsDictionary[familyKeys[indexPathTapped.section]] else {
            return
        }
        let favoritableContact = expandableNames.names[indexPathTapped.row]
        
        let hasFavorited = favoritableContact.hasFavorited
        favoritableContact.hasFavorited = !hasFavorited
        cell.accessoryView?.tintColor = hasFavorited ? .lightGray : .blue
    }
}




