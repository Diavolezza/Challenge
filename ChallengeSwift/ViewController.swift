//
//  ViewController.swift
//  ChallengeSwift
//
//  Created by Vibe Code on 2024.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var totalTime: UITextField!
    @IBOutlet weak var lapTime: UITextField!
    @IBOutlet weak var lastLapTime: UITextField!
    @IBOutlet weak var refLapTime: UITextField!
    @IBOutlet weak var targetLapTime: UITextField!
    @IBOutlet weak var targetTotalTime: UITextField!
    @IBOutlet weak var boxButton: UIButton!
    @IBOutlet weak var incButton: UIButton!
    @IBOutlet weak var decButton: UIButton!
    @IBOutlet weak var refPlusHButton: UIButton!
    @IBOutlet weak var refMinusHButton: UIButton!
    @IBOutlet weak var refPlusZButton: UIButton!
    @IBOutlet weak var refMinusZButton: UIButton!

    // MARK: - Properties
    private var mLap: Int = -1                      // Rundenanzahl
    private var running: Bool = false               // Gibt an, ob die Stopuhr läuft
    private var inBox: Bool = false                 // Gibt an, ob der Boxenstop bereits erfolgt ist
    private var timer: Timer?                     // Timer für die asynchrone Zeitanzeige
    
    private var startTime: Date?                  // Startzeit der Messung
    private var startLapTime: Date?               // Startzeit der aktuellen Runde
    private var startRefTime: Date?               // Startzeit der Referenzrunde
    private var endRefTime: Date?                 // Endzeit der Referenzrunde
    
    // Referenzrunde
    private var refLapTimeInterval: TimeInterval = 0  // Zeit der Referenzrunde

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sound-Manager initialisieren
        _ = SoundManager.shared
        
        // Timer zurücksetzen
        resetTimer()
        
        // Bildschirm-Sperre deaktivieren
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Button-States initialisieren
        incButton.isEnabled = false
        decButton.isEnabled = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Sound-Manager bereinigen
        SoundManager.shared.dispose()
        UIApplication.shared.isIdleTimerDisabled = false
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
    @IBAction func lap(_ sender: Any) {
        if !running {
            running = true
            startTime = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.displayTimerTimes()
            }
        }
        mLap += 1
        if mLap == REF_LAP - 1 {
            // Referenzrunde
            startRefTime = Date()
        }
        if mLap == REF_LAP {
            endRefTime = Date()
            calculateRefTime()
            displayRefTime()
            incButton.isEnabled = true
            decButton.isEnabled = true
        }
        displayCounter()
        displayLastLapTime()
        displayTargetLapTime()
        startLapTime = Date()
        SoundManager.shared.playClick()
    }

    @IBAction func box(_ sender: Any) {
        SoundManager.shared.playClick()
        let alert = UIAlertController(title: "Box", message: "Boxenstop?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { [weak self] _ in
            self?.inBox = true
            self?.boxButton.isEnabled = false
        }))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func reset(_ sender: Any) {
        let alert = UIAlertController(title: "Reset", message: "Rundenzähler und Timer zurücksetzen?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { [weak self] _ in
            self?.reset()
        }))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func inc(_ sender: Any) {
        mLap += 1
        displayCounter()
        displayTargetLapTime()
        SoundManager.shared.playClick()
    }

    @IBAction func dec(_ sender: Any) {
        mLap -= 1
        displayCounter()
        displayTargetLapTime()
        SoundManager.shared.playClick()
    }

    @IBAction func refPlusH(_ sender: Any) {
        refLapTimeInterval += 0.01
        displayNewRefTime()
    }

    @IBAction func refMinusH(_ sender: Any) {
        refLapTimeInterval -= 0.01
        displayNewRefTime()
    }

    @IBAction func refPlusZ(_ sender: Any) {
        refLapTimeInterval += 0.1
        displayNewRefTime()
    }

    @IBAction func refMinusZ(_ sender: Any) {
        refLapTimeInterval -= 0.1
        displayNewRefTime()
    }

    // MARK: - Display Methods
    private func displayNewRefTime() {
        SoundManager.shared.playClick()
        displayRefTime()
        displayCounter()
        displayTargetLapTime()
        displayTargetTotalTime()
    }

    private func displayCounter() {
        let lap = mLap == -1 ? 0 : mLap
        counter.text = "\(lap)"
    }

    private func displayLapTime() {
        var timeString = ""
        if startTime != nil, let currentDate = startLapTime {
            let timeInterval = Date().timeIntervalSince(currentDate)
            let timerDate = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "m:ss.S"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            timeString = dateFormatter.string(from: timerDate)
        }
        lapTime.text = timeString
    }

    private func displayLastLapTime() {
        var timeString = ""
        if let currentDate = startLapTime {
            let timeInterval = Date().timeIntervalSince(currentDate)
            let timerDate = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "m:ss.S"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            timeString = dateFormatter.string(from: timerDate)
        }
        lastLapTime.text = timeString
    }

    private func calculateRefTime() {
        if let start = startRefTime, let end = endRefTime {
            refLapTimeInterval = end.timeIntervalSince(start)
        }
    }

    private func displayRefTime() {
        var timeString = ""
        if refLapTimeInterval != 0 {
            let timerDate = Date(timeIntervalSince1970: refLapTimeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "m:ss.SS"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            timeString = dateFormatter.string(from: timerDate)
        }
        refLapTime.text = timeString
    }

    private func displayTimerTimes() {
        displayTotalTime()
        displayTargetTotalTime()
        displayLapTime()
    }

    private func displayTotalTime() {
        var timeString = "0:00.0"
        if let start = startTime {
            let timeInterval = Date().timeIntervalSince(start)
            let timerDate = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "m:ss.S"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            timeString = dateFormatter.string(from: timerDate)
        }
        totalTime.text = timeString
    }

    private func displayTargetLapTime() {
        var timeString = ""
        
        if mLap >= REF_LAP {
            // Gesamtzeit Wertungsprüfung auf Basis der Referenzrunde
            var timeInterval = TimeInterval((TOTAL_LAP - REF_LAP) * Int(refLapTimeInterval))
            // Zeit seit Ende der Referenzrunde abziehen
            if let endRef = endRefTime {
                timeInterval -= Date().timeIntervalSince(endRef)
            }
            // Vor Boxenstopp? --> Boxenzeit abziehen
            if !inBox {
                timeInterval -= TimeInterval(BOX_TIME)
            }
            // Durch die Anzahl verbleibender Runden teilen
            timeInterval = timeInterval / TimeInterval((TOTAL_LAP - mLap))
            let timerDate = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "m:ss.S"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            timeString = dateFormatter.string(from: timerDate)
        }
        targetLapTime.text = timeString
    }

    private func displayTargetTotalTime() {
        var timeString = ""
        
        if mLap >= TOTAL_LAP {
            return
        }
        if mLap >= REF_LAP {
            // Gesamtzeit Wertungsprüfung auf Basis der Referenzrunde
            var timeInterval = TimeInterval((TOTAL_LAP - REF_LAP) * Int(refLapTimeInterval))
            // Zeit seit Ende der Referenzrunde abziehen
            if let endRef = endRefTime {
                timeInterval -= Date().timeIntervalSince(endRef)
            }
            
            // Niedriger Ton 5 Sekunden vor Ende
            let beepTimes = [5.0, 4.0, 3.0, 2.0, 1.0]
            for beepTime in beepTimes {
                if timeInterval < beepTime + 0.05 && timeInterval > beepTime - 0.05 {
                    SoundManager.shared.playBeepLow()
                    break
                }
            }
            
            // Hoher Ton am Ende
            if timeInterval < 0.05 && timeInterval > -0.05 {
                SoundManager.shared.playBeepHigh()
            }
            
            // Wieder hochzählen
            let dateFormatter = DateFormatter()
            if timeInterval < 0 {
                timeInterval = -timeInterval
                dateFormatter.dateFormat = "-m:ss.S"
            } else {
                dateFormatter.dateFormat = "m:ss.S"
            }
            let timerDate = Date(timeIntervalSince1970: timeInterval)
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            timeString = dateFormatter.string(from: timerDate)
        }
        targetTotalTime.text = timeString
    }

    // MARK: - Reset Methods
    private func reset() {
        running = false
        inBox = false
        boxButton.isEnabled = true
        resetCounter()
        resetTimer()
        incButton.isEnabled = false
        decButton.isEnabled = false
    }

    private func resetCounter() {
        mLap = -1
        displayCounter()
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        startRefTime = nil
        endRefTime = nil
        startLapTime = nil
        refLapTimeInterval = 0
        displayTotalTime()
        displayLapTime()
        displayRefTime()
        displayLastLapTime()
        displayTargetLapTime()
        displayTargetTotalTime()
    }
}
