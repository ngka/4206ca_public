import UIKit
import CoreData
import CoreLocation
import MapKit

class AddEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    var theDevice: Info_image?
    @IBOutlet weak var TitleTF: UITextField!
    @IBOutlet weak var ContentTF: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var LocationMap: MKMapView!

    var locationManager: CLLocationManager!
    var context: NSManagedObjectContext?

    var managedObjectContext: NSManagedObjectContext? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate.persistentContainer.viewContext
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        } else {
            print("Location services are not enabled")
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let device = theDevice {
            TitleTF.text = device.title
            ContentTF.text = device.content
        }
    }

    @IBAction func cancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(sender: AnyObject) {
        if let context = managedObjectContext {
            do {
                if let device = theDevice {
                    device.title = TitleTF.text
                    device.content = ContentTF.text

                    if let image = imageview.image {
                        device.image = image.pngData()
                    }

                    device.date = Date()
                } else if let newDevice = NSEntityDescription.insertNewObject(forEntityName: "Info_image", into: context) as? Info_image {
                    newDevice.title = TitleTF.text
                    newDevice.content = ContentTF.text

                    if let image = imageview.image {
                        newDevice.image = image.pngData()
                    }

                    newDevice.date = Date()
                }

                if let location = locationManager.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location

                    LocationMap.addAnnotation(annotation)

                    if let device = theDevice {
                        device.latitude = location.latitude
                        device.longitude = location.longitude
                    } else if let newDevice = NSEntityDescription.insertNewObject(forEntityName: "Info_image", into: context) as? Info_image {
                        newDevice.latitude = location.latitude
                        newDevice.longitude = location.longitude
                    }
                }

                try context.save()
            } catch let error as NSError {
                print("Error saving context: \(error.localizedDescription)")
            }
        }

        dismiss(animated: true, completion: nil)
    }

    @IBAction func ImageBT(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func locationButtonTapped(_ sender: Any) {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let city = placemarks?.first?.locality {
                    print("Current City: \(city)")

                    if let device = self.theDevice {
                        device.location = city
                    } else if let context = self.context, let newDevice = NSEntityDescription.insertNewObject(forEntityName: "Info_image", into: context) as? Info_image {
                        newDevice.location = city

                        newDevice.latitude = latitude
                        newDevice.longitude = longitude

                        do {
                            try context.save()
                        } catch let error as NSError {
                            print("Error saving context: \(error.localizedDescription)")
                        }
                    }
                }
            }

            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 500, longitudinalMeters: 500)
            LocationMap.setRegion(region, animated: true)
        }
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }

        imageview.image = image
        dismiss(animated: true)
    }
}
