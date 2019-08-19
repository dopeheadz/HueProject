//
//  LampsVC.swift
//  HueProject
//
//  Created by dope on 17/08/2019.
//  Copyright © 2019 dope. All rights reserved.
//

import UIKit

class LampsVC: UIViewController {

    var bridge: PHSBridge! = nil

    var pushLinkVC: PushLinkVC? = nil

    var lastConnectedBridge: PHBridgeInfo? {

        get {

            if let lastConnectedBridge = PHSKnownBridge.lastConnectedBridge {
                let bridge = PHBridgeInfo(ipAddress: lastConnectedBridge.ipAddress, uniqueID: lastConnectedBridge.uniqueId)
                return bridge
            }
            return nil
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        guard selectedBridge == nil else {
            bridge = buildBridge(with: selectedBridge!)
            bridge.connect()
            return

        }

        guard lastConnectedBridge == nil else {
            bridge = buildBridge(with: lastConnectedBridge!)
            bridge.connect()
            return
        }

        self.performSegue(withIdentifier: "showBridgeSelection", sender: self)

    }

    func lightStateWithRandomColors() -> PHSLightState {
        let lightState = PHSLightState()
        lightState.on = true
        lightState.hue = Int(arc4random_uniform(UInt32(65535))) as NSNumber
        lightState.brightness = Int(arc4random_uniform(UInt32(254))) as NSNumber

        return lightState
    }

    @IBAction func randomizeLights(_ sender: UIButton) {

        if let devices = bridge.bridgeState.getDevicesOf(.light) as? [PHSDevice] {
            for device in devices {
                if let lightPoint = device as? PHSLightPoint {
                    let lightState = self.lightStateWithRandomColors()
                    lightPoint.update(lightState, allowedConnectionTypes: .local) { (response, errors, returnCode) in
                        if errors != nil {

                            for error in errors! {
                                print(error.debugDescription)
                            }

                        }
                    }
                }
            }
        }

    }

    func buildBridge(with info: PHBridgeInfo) -> PHSBridge {
        return PHSBridge.init(block: { (builder) in

            builder?.connectionTypes = .local
            builder?.ipAddress = info.ipAddress
            builder?.bridgeID = info.uniqueID

            builder?.bridgeConnectionObserver = self
            builder?.add(self)

        }, withAppName: "HueProject", withDeviceName: "iPhoneX")
    }


    func handleAutheticated() {

        if let pushVC = pushLinkVC {
            pushVC.dismiss(animated: true, completion: nil)
        }

    }

    func handleNotAutheticated() {
        pushLinkVC = storyboard?.instantiateViewController(withIdentifier: "PushLinkVCID") as? PushLinkVC
        self.present(pushLinkVC!, animated: true, completion: nil)

    }
}




extension LampsVC: PHSBridgeConnectionObserver {
    func bridgeConnection(_ bridgeConnection: PHSBridgeConnection!, handle connectionEvent: PHSBridgeConnectionEvent) {
        switch connectionEvent {

        case .authenticated:
            handleAutheticated()
            break
        case .connected:
            break
        case .linkButtonNotPressed:
            break
        case .notAuthenticated:
            handleNotAutheticated()
            break
        default:
            return
        }
    }

    func bridgeConnection(_ bridgeConnection: PHSBridgeConnection!, handleErrors connectionErrors: [PHSError]!) {

    }

}

extension LampsVC: PHSBridgeStateUpdateObserver {
    func bridge(_ bridge: PHSBridge!, handle updateEvent: PHSBridgeStateUpdatedEvent) {
        switch updateEvent {
        case .bridgeConfig:
            break
        case .fullConfig:
            break
        case .initialized:
            break

        default:
            return

        }

    }
}


extension PHSKnownBridge {

    class var lastConnectedBridge: PHSKnownBridge? {
        get {

            let knownBridges: [PHSKnownBridge] = PHSKnownBridges.getAll()
            let sortedKnownBridges: [PHSKnownBridge] = knownBridges.sorted { (bridge1, bridge2) -> Bool in
                return bridge1.lastConnected < bridge2.lastConnected
            }
            return sortedKnownBridges.first

        }
    }
}
