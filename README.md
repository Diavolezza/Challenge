# ChallengeSwift

ChallengeSwift ist eine Swift-Implementierung der ursprünglichen Challenge-App für iOS/iPadOS. Die App dient zur Protokollierung von Rundenzeiten, insbesondere für die Langstrecke-Challenge des Porsche Club Cup.

## Funktionalität

Die App bietet folgende Funktionen:

- **Rundenzeitmessung**: Manuelles Stoppen jeder Runde
- **Echtzeit-Berechnungen**: 
  - Restliche Gesamtzeit
  - Zielrundenzeit für Folgerunden
  - Dynamische Neuberechnung nach jedem Durchlauf
- **Referenzrunden-Funktion**: Festlegung einer Referenzrunde zur Berechnung der Zielzeiten
- **Boxenstop-Verwaltung**: Berücksichtigung der Boxenstop-Zeit
- **Akustische Signale**: 
  - Klick-Sound bei Bedienung
  - Niedriger Ton 5 Sekunden vor Ende
  - Hoher Ton am Ende

## Einstellungen

Auf der Einstellungsseite können folgende Parameter konfiguriert werden:
- Anzahl der Zielrunden
- Nummer der Referenzrunde
- Länge des Boxenstopps (in Sekunden)

## Technische Details

- **Sprache**: Swift 5+
- **Zielplattform**: iOS 13.0+ / iPadOS 13.0+
- **Architektur**: MVC (Model-View-Controller)
- **Sound**: AVAudioPlayer für Sound-Wiedergabe
- **UI**: Storyboard-basiert mit Auto Layout

## Projektstruktur

```
ChallengeSwift/
├── AppDelegate.swift          # App-Delegat
├── SceneDelegate.swift        # Szene-Delegat für iOS 13+
├── ViewController.swift       # Haupt-ViewController
├── SettingsViewController.swift # Einstellungen
├── Constants.swift            # Globale Konstanten
├── SoundManager.swift         # Sound-Verwaltung
├── Info.plist                 # Projekt-Info
├── Main.storyboard            # Storyboard
├── Images.xcassets            # Bild-Assets
└── *.wav                      # Sound-Dateien
```

## Installation

1. Projekt in Xcode öffnen
2. Sound-Dateien und Bilder sind bereits enthalten
3. Build und Run auf einem iPad oder iPhone

## Ursprüngliches Projekt

Das ursprüngliche Projekt wurde in Objective-C entwickelt und ist unter [Diavolezza/Challenge](https://github.com/Diavolezza/Challenge) verfügbar.

## Lizenz

Siehe LICENSE-Datei im ursprünglichen Projekt.
