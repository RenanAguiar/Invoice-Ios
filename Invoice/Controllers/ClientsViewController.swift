
import UIKit
import Foundation

class ClientsViewController:  UITableViewController {
    
    var sortedFirstLetters: [String] = []
    var sections: [[Client]] = [[]]
    //  var tableArray = [Client]()
    var clients : [Client] = [Client]()
    var client: Client?
    var wasDeleted: Bool?
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var noClientsLabel: UILabel!
    @IBOutlet var noClientsView: UIView!
    
    @IBAction func unwindToClients(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ClientViewController,
            let client = sourceViewController.client,
            let wasDeleted = sourceViewController.wasDeleted {
            
            if(wasDeleted) {
                if let index = self.clients.index(where: { (item) -> Bool in
                    item.client_id == client.client_id
                }) {
                    self.clients.remove(at: index)
                    print("Delteted")
                }
                
            }
            else {
                if self.clients.contains(where: { (item) -> Bool in
                    item.client_id == client.client_id
                }) {
                    if let index = self.clients.index(where: { (item) -> Bool in
                        item.client_id == client.client_id
                    }) {
                        self.clients[index] = client
                        print("update")
                    }
                }
                else {
                    // Add a client.
                    clients.append(client)
                    print("add")
                }
            }
            
            self.prepareData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let clientViewController = segue.destination as! ClientViewController
        if segue.identifier == "ShowDetail", let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedClient = sections[indexPath.section][indexPath.row]
            clientViewController.client = selectedClient
        }
        else if segue.identifier == "AddItem" {
            print("add")
        }
        else {
            fatalError("The selected cell is not being displayed by the table")
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getClients()
    }
    
}

extension ClientsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(ClientsViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.backgroundView = nil
        noClientsLabel.text = ""
        getClients() //for only the 1st time ==> when view is created ==> ok ish
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(self.clients.count > 0) {
            return sortedFirstLetters[section]
        }
        else {
            return ""
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedFirstLetters
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath)
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.city + " - " + item.province
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func getClients() {
        print("called server")
        self.refreshControl?.beginRefreshing()
        self.tableView.setContentOffset(CGPoint(x:0, y:-100), animated: true)
        
        makeRequest(endpoint: "api/clients/all",
                    parameters: [:],
                    completionHandler: { (container : ApiContainer<Client>?, error : Error?) in
                        if let error = error {
                            print("error calling POST on /getClients")
                            print(error)
                            return
                        }
                        self.clients = (container?.result)!
                        
                        self.prepareData()
                        DispatchQueue.main.async {
                            if(self.clients.isEmpty)
                            {
                                self.noClientsLabel.text = "bNo Clients"
                                self.tableView.backgroundView?.isHidden = false
                                self.noClientsLabel.text = ""
                                print("all")
                            }
                            else{
                                print("nothing")
                            }
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
        } )
    }
    
    //sorts and makes the index
    func prepareData() {
        let firstLetters = self.clients.map { $0.nameFirstLetter }
        let uniqueFirstLetters = Array(Set(firstLetters))
        
        self.sortedFirstLetters = uniqueFirstLetters.sorted()
        self.sections = self.sortedFirstLetters.map { firstLetter in
            return self.clients
                .filter { $0.nameFirstLetter == firstLetter }
                .sorted { $0.name < $1.name }
        }
    }
    
}
