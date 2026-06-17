//
//  SettingsViewController.swift
//  ChallengeSwift
//
//  Created by Vibe Code on 2024.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var laps: UITextField!
    @IBOutlet weak var refLap: UITextField!
    @IBOutlet weak var boxTime: UITextField!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Aktuelle Werte laden
        laps.text = "\(TOTAL_LAP)"
        refLap.text = "\(REF_LAP)"
        boxTime.text = "\(BOX_TIME)"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Design-Größe (iPad-Portrait)
        let designWidth: CGFloat = 768.0
        let designHeight: CGFloat = 1024.0

        // Tatsächliche Bildschirmgröße
        let screenSize = self.view.bounds.size
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        if round(screenWidth) != round(designWidth) {
            // Einheitliche Skalierung berechnen
            let scaleX = screenWidth / designWidth
            let scaleY = screenHeight / designHeight
            let scale = min(scaleX, scaleY) // damit nichts rausfällt

            // Skalierung anwenden
            self.view.transform = CGAffineTransform(scaleX: scale, y: scale)

            // Nach Skalierung: neue Größe
            let scaledWidth = designWidth * scale
            let scaledHeight = designHeight * scale

            // Differenz berechnen, um zu zentrieren
            let dx = (screenWidth - scaledWidth) / 2.0
            let dy = (screenHeight - scaledHeight) / 2.0

            // Frame verschieben zur Zentrierung
            self.view.frame = CGRect(x: dx, y: dy, width: scaledWidth, height: scaledHeight)
        }
    }

    // MARK: - IBActions
    @IBAction func settingsDone(_ sender: Any) {
        if let lapsText = laps.text, let lapsValue = Int(lapsText) {
            TOTAL_LAP = lapsValue
        }
        if let refLapText = refLap.text, let refLapValue = Int(refLapText) {
            REF_LAP = refLapValue
        }
        if let boxTimeText = boxTime.text, let boxTimeValue = Int(boxTimeText) {
            BOX_TIME = boxTimeValue
        }
        dismiss(animated: true, completion: nil)
    }
}
