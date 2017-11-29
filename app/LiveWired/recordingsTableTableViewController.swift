//
//  recordingsTableTableViewController.swift
//  LiveWired
//
//  Created by Mostafa Hakam on 2017-10-16.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import Firebase

class recordingsTableTableViewController: UITableViewController {

    var samples = [String]()
    var done = false
    
    let cellReuseIdentifier = "cell"

    struct User: Decodable {
        let id: Int
        let script: String
        let user_id: String
    }
    
    @objc func loadTable() {
        tableView.beginUpdates()
        print("samples:" + String(describing: samples))
        tableView.insertRows(at: [IndexPath(row: samples.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        getRecordings(userID: uid)
        
        
        while !done {
        }
        navigationItem.title = "My Recordings"
        tableView.separatorColor = UIColor(r: 200, g: 200, b: 200)
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        loadTable()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return samples.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            deleteScript(userID: uid, script: samples[indexPath.row])
            
            samples.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


    
    func getRecordings(userID: String){
        print("Getting recordings for: " + userID)
        guard let url = URL(string: "http://35.199.154.5:5000/api/v1/transcript/" + userID) else { return }
        
        //print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let usersData = try JSONDecoder().decode([User].self, from: data)
                
                for user in usersData{
                    print(user.script)
                    if(!user.script.isEmpty){
                        self.samples.append(user.script)
                    }
                }
                
                self.done = true
                
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //let destination = TranscriptViewController()
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = samples[indexPath.row]

        return cell
    }
    
    @objc func handleBack() {
        let newController = ViewController()
        present(newController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: samples[indexPath.row], message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel)
        self.present(alertController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        alertController.addAction(cancelAction)
        print(samples[indexPath.row])
        //print("row: " + String(indexPath.row)  xx)
    }
    
    func actionRefresh(sender: UIBarButtonItem)
    {
        print("The action button is refreshed")
    }
    
    func deleteScript(userID: String, script: String){
        guard let url = URL(string: "http://35.199.154.5:5000/api/v1/delete/transcript/" + userID) else { return }
        var request = URLRequest(url: url)
        print(userID)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let putDict = ["script" : script]
        
        do {
            let jsonBody = try JSONSerialization.data(withJSONObject: putDict, options: [])
            request.httpBody = jsonBody
        } catch {}
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, _,_) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {}
        }
        task.resume()
    }
}
