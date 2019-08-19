//
//  BridgeSelectionVC.swift
//  HueProject
//
//  Created by dope on 17/08/2019.
//  Copyright © 2019 dope. All rights reserved.
//

import UIKit

var selectedBridge: PHBridgeInfo? = nil

class BridgeSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var bridges: [PHBridgeInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        discoverBridges()

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bridges.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BridgeCell", for: indexPath)
        
        let bridge = bridges[indexPath.row]
        
        cell.textLabel?.text = bridge.ipAddress
        cell.detailTextLabel?.text = bridge.uniqueID
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedBridge = bridges[indexPath.row]
        self.dismiss(animated: true, completion: nil)
        
        //
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBAction func reload(_ sender: UIBarButtonItem) {
        
        discoverBridges()
        
    }

    func discoverBridges() {

        let options: PHSBridgeDiscoveryOption = .discoveryOptionUPNP
        let bridgeDiscovery = PHSBridgeDiscovery()
        
        self.spinner.startAnimating()
        self.spinner.isHidden = false

        bridgeDiscovery.search(options) { (result, returnCode) in
            if returnCode == .success {
                self.bridges.removeAll()
                
                for (_, value) in result! {
                    
                    let bridgeinfo = PHBridgeInfo(ipAddress: value.ipAddress, uniqueID: value.uniqueId)
                    self.bridges.append(bridgeinfo)
                }
                
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                
                self.tableView.reloadData()
                
            }
        }
    }
}



