import UIKit
import MapKit

protocol TodoViewControllerProtocol {
    func didAddNewTodo()
}

class TodoViewController: UIViewController {

    var delegate: TodoViewControllerProtocol?
    
    var locationManager = LocationManager()
    var todo: Todo?
    var annotationLocation: Location?
    var currentTextField: UITextField?
    
    @IBOutlet weak var addLocation: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField! {
        didSet { titleTextField.delegate = self }
    }

    @IBAction func didPress(sender: AnyObject) {
        datePicker.hidden = false
        
    }
    
    @IBAction func didChangeDatePickerValue(sender: AnyObject) {
        todo?.date = datePicker.date
        datePicker.hidden = true
    }
    
    @IBOutlet weak var descriptionTextfield: UITextField! {
        didSet { descriptionTextfield.delegate = self }
    }
    
    @IBAction func didPressSave(sender: AnyObject) {
        let title = titleTextField.text!
        let todoDescription = descriptionTextfield.text!.characters.count > 0 ? descriptionTextfield.text! : ""
        let location = annotationLocation!
        
        let newTodo = Todo(id: NSUUID().UUIDString, title: title, details: todoDescription, location: location, date: NSDate())
        if !isValidTodo(newTodo) { return }
        
        let todos = Todos.get()
        
        if let _ = self.todo {
            todos.todos = updateOldTodo(newTodo, todos: todos)
        } else {
            todos.todos.append(newTodo)
        }
        
        Todos.save(todos)
        delegate?.didAddNewTodo()
    }
    
    @IBAction func didPressAddLocation(sender: UIButton) {
        mapView.hidden = false
        sender.hidden = true
        currentTextField?.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var shouldUpdateLocation = true
        locationManager.delegate = self
        mapView.delegate = self
        
        if let todo = todo {
            title = todo.title
            titleTextField.text = todo.title
            descriptionTextfield.text = todo.details
            
            if let location = todo.location {
                mapView.hidden = false
                addLocation.hidden = true
                updateLocation(location)
                shouldUpdateLocation = false
            }
        }
        if shouldUpdateLocation {
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateOldTodo(newTodo: Todo, todos: Todos) -> [Todo] {
        var counter = 0
        var todoList = todos.todos
        
        for todo in todoList {
            if todo.id == self.todo!.id {
                newTodo.id = todo.id
                break
            }
            counter++
        }
        todoList[counter] = newTodo
        return todoList
    }
    
    func isValidTodo(todo: Todo) -> Bool {
        if todo.title.characters.count < 1 {
            displayAlert(NSLocalizedString("titleToShort", comment: ""), descriptionAlert: NSLocalizedString("titleToShortDescription", comment: ""))
            return false
        }
        
        return true
    }
    
    func displayAlert(titleAlert: String, descriptionAlert: String) {
        let alert = UIAlertController(title: titleAlert, message: descriptionAlert, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateLocation(location: Location) {
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)

        let point = MKPointAnnotation()
        point.coordinate = center
        point.title = "Todo location"
        annotationLocation = location
        self.mapView.addAnnotation(point)
    }
}

extension TodoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TodoViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationView")
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
            view!.draggable = true
            view!.annotation = annotation
        } else {
            view!.annotation = annotation
        }
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.Ending {
            annotationLocation = Location(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
        }
    }
}

extension TodoViewController: LocationManagerProtocol {
    func locationManager(didUpdateLocation location: Location) {
        locationManager.stopUpdatingLocation()
        
        dispatch_async(dispatch_get_main_queue(),{
            self.updateLocation(location)
        })
    }
}
