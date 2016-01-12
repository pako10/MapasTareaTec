//
//  ViewController.swift
//  MapasTareaTec
//
//  Created by Francisco Humberto Andrade Gonzalez on 10/01/16.
//  Copyright © 2016 Francisco Humberto Andrade Gonzalez. All rights reserved.
//
import MapKit
import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    
    private let manejador = CLLocationManager()
    var posicionInicial: CLLocation!
    var punto : CLLocationCoordinate2D!
    var distanciaRecorrida : Double!
    var pin : MKPointAnnotation!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        posicionInicial = nil
        punto = CLLocationCoordinate2D()
        distanciaRecorrida = 0.0
        pin = nil
    }

   
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let posicionActual : CLLocation = locations.last!
        
        let ultimaPosicion: CLLocation = locations[locations.count - 1]
        
        if posicionInicial == nil {
            posicionInicial = ultimaPosicion
            
        }
        
        let distancia: CLLocationDistance =
        ultimaPosicion.distanceFromLocation(posicionInicial)
        
        if distancia >= 50.0 {
            
            distanciaRecorrida = distanciaRecorrida + distancia
            punto = CLLocationCoordinate2D()
            punto.latitude = ultimaPosicion.coordinate.latitude
            punto.longitude = ultimaPosicion.coordinate.longitude
            pin = MKPointAnnotation()
            let longitudFormat = NSString(format:"%.3f", punto.longitude)
            let latitudFormat = NSString(format:"%.3f", punto.latitude)
            pin.title = "(Long: \(longitudFormat), Lat: \(latitudFormat))"
            let distanciaRecorridaFormat = NSString(format:"%.3f", distanciaRecorrida)
            pin.subtitle = "Dist. recorrida: \(distanciaRecorridaFormat) metros"
            pin.coordinate = punto
            mapa.addAnnotation(pin)
            posicionInicial = nil
            
        }
        
        let center = CLLocationCoordinate2D(latitude: posicionActual.coordinate.latitude, longitude: posicionActual.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapa.setRegion(region, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        let alerta = UIAlertController(title: "Error", message: "error \(error.code)", preferredStyle: .Alert)
        
        let accionOK = UIAlertAction(title: "no", style: .Default, handler: {accion in
            
        })
        
        alerta.addAction(accionOK)
        
        self.presentViewController(alerta, animated: true, completion: nil)
    }

    @IBAction func didChangeValueControl(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
            
        case 0:
            mapa.mapType = MKMapType.Standard
            break
            
        case 1:
            mapa.mapType = MKMapType.Satellite
            break
            
        case 2:
            mapa.mapType = MKMapType.Hybrid
            break
            
        default:
            mapa.mapType = MKMapType.Standard
            break
        }
    }

}

