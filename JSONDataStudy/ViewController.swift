//
//  ViewController.swift
//  JSONDataStudy
//
//  Created by Ömer Faruk Kılıçaslan on 6.07.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var heroesArray = [HeroModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJSON {
            print("successfull")
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func downloadJSON(completed: @escaping () -> ()) {
        
        guard let url = URL(string: "https://api.opendota.com/api/heroStats") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }
            else{
                guard let data = data else {
                    return
                }

                //No error
                do {
                    self.heroesArray = try JSONDecoder().decode([HeroModel].self, from: data)
                    DispatchQueue.main.async {
                        completed()
                    }
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                
            }
        }
        .resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetails" {
            if let destinationVC = segue.destination as? HeroViewController {
                destinationVC.hero = heroesArray[(tableView.indexPathForSelectedRow?.row)!]
            }
            
        }
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HeroCell
        cell.heroNameLabel.text = heroesArray[indexPath.row].localized_name.capitalized
        cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.imageView?.downloaded(from: URL(string: "https://api.opendota.com\(heroesArray[indexPath.row].img)")!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetails", sender:  nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}



