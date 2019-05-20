import Foundation
import UIKit

class GeocodeAlertController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var queryField: UITextField!
    @IBOutlet weak var cultureField: UITextField!
    @IBOutlet weak var regionField: UITextField!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var boundingBoxSwitch: UISwitch!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    var delegate: GeocodeAlertDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        queryField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }

    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }

    func clear() {
        queryField.text! = ""
        cultureField.text! = ""
        regionField.text! = ""
        locationSwitch.isOn = false
        boundingBoxSwitch.isOn = false
    }

    @IBAction func onTapCancelButton(_ sender: Any) {
        queryField.resignFirstResponder()
        self.clear()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onTapOkButton(_ sender: Any) {
        queryField.resignFirstResponder()
        delegate?.searchButtonTapped(query: queryField.text!, culture: cultureField.text!, region: regionField.text!, useLocation: locationSwitch.isOn, useBoundingBox: boundingBoxSwitch.isOn)
        self.clear()
        self.dismiss(animated: true, completion: nil)
    }
}
