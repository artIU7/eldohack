//
//  TaskemployControllerTableViewController.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 22.06.2021.
//

import UIKit

class TaskEmployeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tabBarTag: Bool = true
    
    private let contacts = ProductAPI.getContacts() // model
    let contactsTableView = UITableView() // view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Задачи"
        view.backgroundColor = .white
               
               view.addSubview(contactsTableView)
               
               contactsTableView.translatesAutoresizingMaskIntoConstraints = false
               
               contactsTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
               contactsTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
               contactsTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
               contactsTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
               
               contactsTableView.dataSource = self
               contactsTableView.delegate = self

               
       //      contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "contactCell")
               contactsTableView.register(ProductClassCell.self, forCellReuseIdentifier: "contactCell")


           

               navigationItem.title = "Contacts"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
          return contacts.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Проверка ценников товаров"
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.red

        return vw
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 100
      }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //      let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
                let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ProductClassCell

        //      cell.textLabel?.text = contacts[indexPath.row].name
                cell.product = contacts[indexPath.row]

                return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index path\(indexPath.row)")
        let scanQR = ScannerController()
        //startTest.modalTransitionStyle = .flipHorizontal
        scanQR.modalPresentationStyle = .fullScreen
        scanQR.modalTransitionStyle = .crossDissolve
        show(scanQR, sender: self)
        //present(startTest, animated: true, completion: nil)
        print("Launch second controller")
        //let destination = TimeViewController()
      //navigationController?.pushViewController(destination, animated: true)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          
           if tabBarTag == true {
            self.tabBarController?.tabBar.tintColor =  #colorLiteral(red: 0.2088217232, green: 0.8087635632, blue: 0.364161254, alpha: 1)//UIColor.blue
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)//UIColor.cyan
           } else {
               self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           }
    }
}
