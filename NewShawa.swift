//
//  NewShawa.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 28.03.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class NewShawa: UITableViewController {
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var locationTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    @IBOutlet weak var imgOfShawa: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var imageIsChange = false
    var currentPlace: Place?
    
    var currentRating = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.tableFooterView = UIView(frame: CGRect(
            x: 0, y: 0, width: tableView.frame.size.width, height: 1)
        )
        priceTxtField?.addDoneButtonOnKeyboard()
        
        saveButton.isEnabled = false
        
        nameTxtField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        setupEditScreen()
     
    }
    //MARK: - Table ViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let albumIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImgPicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImgPicker(source: .photoLibrary)
            }
            photo.setValue(albumIcon, forKey: "image")
            let cancle = UIAlertAction(title: "Cancle", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancle)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let mapVC = segue.destination as? MapVC
            else {return}
        
        mapVC.incomeSegueIdentifire = identifier
        mapVC.mapVCDelegate = self
        
        if identifier == "showShawa" {
        mapVC.place.name = nameTxtField.text!
        mapVC.place.location = locationTxtField.text
        mapVC.place.price = priceTxtField.text
        mapVC.place.imgData = imgOfShawa.image?.pngData()
        }
    }
    
    func savePlace () {
        
        let image =  imageIsChange ? imgOfShawa.image : #imageLiteral(resourceName: "imagePlaceholder")
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: nameTxtField.text!,
                             location: locationTxtField.text,
                             price: priceTxtField.text,
                             imgData: imageData,
                             rating: Double(ratingControl.rating))
        
        if currentPlace != nil {
            try! realm.write{
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.price = newPlace.price
                currentPlace?.imgData = newPlace.imgData
                currentPlace?.rating = newPlace.rating
            }
        } else {
        StorageManager.saveObject(newPlace)
        }
    }
    
    @IBAction func CancleButton (_ sender: UIBarButtonItem?) {
        dismiss(animated: true)
    }
    
    private func setupEditScreen () {
        if currentPlace != nil {
            setupNavBar()
            imageIsChange = true
            
            guard let data = currentPlace?.imgData else {return}
            let img = UIImage(data: data)
            
            imgOfShawa.image = img
            imgOfShawa.contentMode = .scaleAspectFill
            nameTxtField.text = currentPlace?.name
            locationTxtField.text = currentPlace?.location
            priceTxtField.text = currentPlace?.price
            ratingControl.rating = Int(currentPlace!.rating)
        }
    }
    
    private func setupNavBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
}

//MARK: - TxtField Delegate
extension NewShawa: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if nameTxtField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: - Image Changing
extension NewShawa: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImgPicker (source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imgPicker = UIImagePickerController()
            
            imgPicker.delegate = self
            
            imgPicker.allowsEditing = true
            imgPicker.sourceType = source
            present(imgPicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgOfShawa.image = info[.editedImage] as? UIImage
        imgOfShawa.contentMode = .scaleAspectFill
        
        imageIsChange = true
        
        dismiss(animated: true)
    }
}

extension NewShawa: MapVCDelegate {
    func getAddress(_ addres: String?) {
        locationTxtField.text = addres
    }
    
    
}
