//
//  NewActivityViewController.swift
//  fefuactivity
//
//  Created by students on 26.05.2022.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

class NewActivityViewController: UIViewController {
    

    @IBOutlet weak var viewWithButtons: UIView!
    @IBOutlet weak var viewWithChoice: UIView!
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityNameInButtons: UILabel!
    @IBOutlet weak var activityKMInButtons: UILabel!
    @IBOutlet weak var activityTimeInButtons: UILabel!
    @IBOutlet weak var pauseAction: UIButton!
    @IBOutlet weak var finishAction: UIButton!
    
    var activityTypes = ["Велосипед", "Бег"]
    
    private var coreContainer = CoreContainer.instance
    
    private var activityDistance: CLLocationDistance = CLLocationDistance()
    private let userLocationIdentifier = "user_icon"
    private var startTimer: Date?
    private var activityDuration: TimeInterval = TimeInterval()
    private var timer: Timer?
    private var currentDuration: TimeInterval = TimeInterval()
    private var pauseFlag: Bool = true
    private var activityDate: Date?
    
    var images = [UIImage]()
    var activityList = [String]()
    var currentName = ""
    
    
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return manager
    }()
    
    fileprivate var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else {
                return
            }
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            
            if oldValue != nil {
                activityDistance += userLocation.distance(from: oldValue!)
            }
            userLocHistory.append(userLocation)
            activityKMInButtons.text = String(format: "%.2f км", activityDistance/1000)
        }
    }
    
    fileprivate var userLocHistory: [CLLocation] = [] {
        didSet {
            let coordinates = userLocHistory.map { $0.coordinate }
            let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(route)
        }
    }
    @IBAction func pause(_ sender: Any) {
        userLocHistory = []
        userLocation = nil
        
        if pauseFlag == true {
            activityDuration += currentDuration
            currentDuration = TimeInterval()
            timer?.invalidate()
            locationManager.stopUpdatingLocation()
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpd), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
        }
        
        pauseFlag = !pauseFlag
        activityDate = Date()
    }
    
    @IBAction func finish(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        let context = coreContainer.context
        let activity = ActivityData(context: context)
        
        activityDuration += currentDuration
        timer?.invalidate()
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm"
        let activityStart = dateFormat.string(from: activityDate!)
        let activityEnd = dateFormat.string(from: activityDate! + activityDuration)
        
        activity.date = activityDate
        activity.distance = activityDistance
        activity.start = activityStart
        activity.end = activityEnd
        activity.name = currentName
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func timerUpd() {
        let timeformat = DateComponentsFormatter()
        timeformat.allowedUnits = [.hour, .minute, .second]
        timeformat.zeroFormattingBehavior = .pad
        activityTimeInButtons.text = timeformat.string(from: activityDuration)
        activityDuration += 1
    }
    
    private var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    private var shortTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    @IBAction func start(_ sender: Any) {
        viewWithButtons.isHidden = false
        viewWithChoice.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpd), userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
            	
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseAction.setTitle("", for: .normal)
        pauseAction.clipsToBounds = true
        pauseAction.layer.cornerRadius = 0.5 * pauseAction.bounds.size.width
        finishAction.clipsToBounds = true
        finishAction.setTitle("", for: .normal)
        finishAction.layer.cornerRadius = 0.5 * finishAction.bounds.size.width
        
        startTimer = Date()
        activityDate = Date()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout()
        collectionView.dataSource = self
        collectionView.register(CompositionalLayoutCell.nib(), forCellWithReuseIdentifier: CompositionalLayoutCell.reuseId)
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
                
        for i in 0...1 {
            let image = UIImage(named: "image\(i)")!
            images.append(image)
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout { (sectionNumber, env ) -> NSCollectionLayoutSection in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets.trailing = 16
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(99))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            section.contentInsets.leading = 16
            return section
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
}

private let userLocationIdentifier = "user_icon"

extension NewActivityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalLayoutCell.reuseId, for: indexPath) as? CompositionalLayoutCell else {
            return UICollectionViewCell()
        }
        let img = images[indexPath.row]
        let label = activityTypes[indexPath.row]
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.purple.cgColor
        cell.configure(title: label, image: img)
        activityNameInButtons.text = label
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
}


extension NewActivityViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.first else {
                return
            }
            userLocation = currentLocation
        }
}

extension NewActivityViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.fillColor = UIColor.purple
            renderer.strokeColor = UIColor.purple
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKUserLocation {
            let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: userLocationIdentifier)
            
            let view = dequeuedView ?? MKAnnotationView(annotation: annotation, reuseIdentifier: userLocationIdentifier)
            view.image = UIImage(named: "ic_UL")
            return view
        }
        return nil
    }
}
    
