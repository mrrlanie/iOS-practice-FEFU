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
    var currentName = "Велосипед"
    
    
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
            pauseAction.setImage(UIImage(named: "play"), for: .normal)
            activityDuration += currentDuration
            currentDuration = TimeInterval()
            timer?.invalidate()
            locationManager.stopUpdatingLocation()
        } else {
            pauseAction.setImage(UIImage(named: "pause.fill"), for: .normal)
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
        let nextView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyActivityViewController") as! MyActivityViewController
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @objc func timerUpd() {
        let time = Date().timeIntervalSince(startTimer!)
        let timeFormat = DateComponentsFormatter()
        timeFormat.allowedUnits = [.hour, .minute, .second]
        timeFormat.zeroFormattingBehavior = .pad
        activityTimeInButtons.text = timeFormat.string(from: time + activityDuration)
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
        
        startTimer = Date()
        activityDate = Date()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        for i in 0...1 {
            let image = UIImage(named: "image\(i)")!
            images.append(image)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
}

private let userLocationIdentifier = "user_icon"

extension NewActivityViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityTypes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Coolection", for: indexPath) as! CollectionCellView
        let img = images[indexPath.row]
        cell.activityPic.image = img
        let label = activityTypes[indexPath.row]
        cell.activityName.text = label
        activityList.append(label)
        return cell
        }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            currentName = activityList[indexPath.row]
            self.activityNameInButtons.text = currentName
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
    
