//
//  FirebaseStorageViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 04/03/22.
//

import UIKit
import Firebase
import MobileCoreServices
import UniformTypeIdentifiers

class FirebaseStorageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var collectionViewModel : ValidationFields!
    
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    @IBOutlet weak var selectionSegCntrol: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var width = UIScreen.main.bounds.size.width
    
    var url: [URL] = [URL](){
        didSet {
            self.activitiIndicator.stopAnimating()
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.isHidden = true
        
        // For Image
        collectionViewModel = ValidationFields()
        collectionViewModel?.delegate = self
        collectionViewModel?.dwnloadImgFrmStorage()
        
        // For Segmet Control
        selectionSegCntrol.selectedSegmentIndex = 0
        
        // For FIle Downloading
        collectionViewModel.downloadingPdf { url in // Downloading file
            self.activitiIndicator.stopAnimating()
            self.collectionView.isHidden = false
            self.url = url
            print(url)
            //            self.collectionView.reloadData()
        }
        // Register Collection Nib file
        let nibCell = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    // Image and Segment Control
    @IBAction func uploadToCStorage(_ sender: Any) {
        if selectionSegCntrol.selectedSegmentIndex == 0 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else if selectionSegCntrol.selectedSegmentIndex == 1 {
            fileFormatUpload()
            //collectionView.reloadData()
        }
    }
    
    @IBAction func segTappedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            collectionView.reloadData()
        } else if sender.selectedSegmentIndex == 1 {
            collectionView.reloadData()
        }
    }
    
    // Picking Imgage from Mobile Gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageUpUserName = UserDefaults.standard.string(forKey: "userName")
        guard let image = info[.editedImage] as? UIImage else { return }
        guard let data = image.pngData() else { return }
        collectionViewModel?.storageRefernce.child("Image").child(UUID().uuidString + ".jpg").putData(data, metadata: nil) {
            [unowned self] storageData, error in
            Analytics.logEvent("ImageUploadedInFBase", parameters: [
                AnalyticsParameterSuccess : "Image_Uploded Successfully by\(imageUpUserName!)"])
            self.collectionViewModel.dwnloadImgFrmStorage()
            //self?.collectionViewModel!.imageArr.append(data)
        }
        print("//////////////", info.values)
        dismiss(animated: true, completion: nil)
    }
}

// MARK : UIDocumentPickerDelegate, UIDocumentMenuDelegate

extension FirebaseStorageViewController: UIDocumentPickerDelegate, UIDocumentMenuDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else { return }
        let last = myURL.pathExtension
        //self.url.append(myURL)   // append data first then uploads to data base for running this remove success protocol
        self.activitiIndicator.startAnimating()
        self.collectionView.isHidden = true
        if last == "pdf"  {
            collectionViewModel.uploadLocalData(path: myURL, extensionString: ".pdf")
        }
        else if last == "doc"{
            collectionViewModel.uploadLocalData(path: myURL, extensionString: ".doc")
        }
        else if last == "docx"{
            collectionViewModel.uploadLocalData(path: myURL, extensionString: ".docx")
            
        } else if last == "xlsx"{
            collectionViewModel.uploadLocalData(path: myURL, extensionString: ".xlsx")
        }
        
        func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
            if controller.documentPickerMode == UIDocumentPickerMode.import {
            }
        }
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController){
            print("view was cancelled")
            dismiss(animated: true, completion: nil)
        }
    }
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func fileFormatUpload(){
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .open)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}

// MARK : UICollectionViewDelegate & UICollectionViewDataSource

extension FirebaseStorageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectionSegCntrol.selectedSegmentIndex == 0 {
            return collectionViewModel?.imageArr.count ?? 0
        } else {
            return url.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectionSegCntrol.selectedSegmentIndex == 0 {
            guard let imgData = collectionViewModel?.imageArr[indexPath.row] else { return UICollectionViewCell()}
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorageCollectionViewCell", for: indexPath) as? StorageCollectionViewCell {
                cell.imgView.widthAnchor.constraint(equalToConstant: ( width/2-10)).isActive = true
                cell.imgView.heightAnchor.constraint(equalToConstant:( width/2-10)).isActive = true
                cell.imgView.image = UIImage(data: imgData)
                return cell
            }
        }
        else {
            let xibCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            let url = url[indexPath.row]
            xibCell.imgView_CollectionCell.widthAnchor.constraint(equalToConstant: ( width/2-10)).isActive = true
            xibCell.imgView_CollectionCell.heightAnchor.constraint(equalToConstant:( width/2-10)).isActive = true
            switch url.pathExtension{
            case "pdf" :
                xibCell.imgView_CollectionCell.image = UIImage(named: "pdf")
            case "doc" :
                xibCell.imgView_CollectionCell.image = UIImage(named: "doc")
            case "docx" :
                xibCell.imgView_CollectionCell.image = UIImage(named: "docx")
            case "xlsx" :
                xibCell.imgView_CollectionCell.image = UIImage(named: "xlsx")
            default :
                break
            }
            return xibCell
        }
        return UICollectionViewCell()
    }
}

extension FirebaseStorageViewController : GetImage {
    func uploadSuccess() {
        self.url.removeAll()
        self.collectionViewModel.downloadingPdf { url in
            self.url = url
        }
    }
    
    func updateCollection() {
        DispatchQueue.main.async {
            self.activitiIndicator.stopAnimating()
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }
    }
}
