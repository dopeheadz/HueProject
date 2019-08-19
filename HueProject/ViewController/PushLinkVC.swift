//
//  PushLinkVC.swift
//  HueProject
//
//  Created by dope on 17/08/2019.
//  Copyright © 2019 dope. All rights reserved.
//

import UIKit

class PushLinkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        countdownUntilTimeout()
    }

    @IBOutlet weak var pregressView: UIProgressView!

    func countdownUntilTimeout() {
        let timeout: Float = 30

        var timeLeft = timeout

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in

            timeLeft -= 1
            let progress = timeLeft / timeout
            self.pregressView.progress = progress

            if timeLeft == 0 {
                self.timeoutAlert()
                timer.invalidate()
            }


        }
    }

    func timeoutAlert() {
        let alertController = UIAlertController(title: "Timeout", message: "제한시간내에 버튼을 클릭하지 않았습니다.", preferredStyle: .alert)

        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            //
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)

    }

}
