//
//  FirebaseStorageViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 04/03/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class FirebaseStorageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageCollectionViewModel : ValidationFields!
    
    @IBOutlet weak var selectionSegCntrol: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var width = UIScreen.main.bounds.size.width
    
    var url: [URL] = [URL](){
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionViewModel = ValidationFields()
        imageCollectionViewModel?.delegate = self
        imageCollectionViewModel?.dwnloadImgFrmStorage()
        
        selectionSegCntrol.selectedSegmentIndex = 0
        
        imageCollectionViewModel.downloadingPdf { url in // Downloading file
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
            clickFunction()
            
            //collectionView.reloadData()
        }
        
        
        
    }
    
    @IBAction func segTappedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //collectionView.reloadData()
        } else if sender.selectedSegmentIndex == 1 {
            collectionView.reloadData()
        }
    }
    
    // Picking Imgage from Mobile Gallery
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        guard let data = image.pngData() else { return }
        
        imageCollectionViewModel?.storageRefernce.child("Image").child(UUID().uuidString + ".jpg").putData(data, metadata: nil) {
            [weak self] storageData, error in
            self?.imageCollectionViewModel!.imageArr.append(data)
        }
        print("//////////////", info.values)
        dismiss(animated: true, completion: nil)
        
    }
    
}


// MARK : UIDocumentPickerDelegate, UIDocumentMenuDelegate


extension FirebaseStorageViewController: UIDocumentPickerDelegate, UIDocumentMenuDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        let last = myURL.pathExtension
        self.url.append(myURL)
        if last == "pdf"  {
            imageCollectionViewModel.uploadLocalData(path: myURL, extensionString: ".pdf")
        }
        else if last == "doc"{
            imageCollectionViewModel.uploadLocalData(path: myURL, extensionString: ".doc")
        }
        else if last == "docx"{
            imageCollectionViewModel.uploadLocalData(path: myURL, extensionString: ".docx")
            
        } else if last == "xlsx"{
            imageCollectionViewModel.uploadLocalData(path: myURL, extensionString: ".xlsx")
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
    
    func clickFunction(){
        
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
}

// MARK : UICollectionViewDelegate & UICollectionViewDataSource

extension FirebaseStorageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectionSegCntrol.selectedSegmentIndex == 0 {
            return imageCollectionViewModel?.imageArr.count ?? 0
        } else {
            return url.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectionSegCntrol.selectedSegmentIndex == 0 {
            guard let imgData = imageCollectionViewModel?.imageArr[indexPath.row] else { return UICollectionViewCell()}
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorageCollectionViewCell", for: indexPath) as? StorageCollectionViewCell {
                cell.img.widthAnchor.constraint(equalToConstant: ( width/2-10)).isActive = true
                cell.img.heightAnchor.constraint(equalToConstant:( width/2-10)).isActive = true
                
                cell.img.image = UIImage(data: imgData)
                return cell
            }
        }
        else {
            let xibCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            let url = url[indexPath.row]
            xibCell.collectionCellImgView.widthAnchor.constraint(equalToConstant: ( width/2-10)).isActive = true
            xibCell.collectionCellImgView.heightAnchor.constraint(equalToConstant:( width/2-10)).isActive = true
            switch url.pathExtension{
            case "pdf" :
                xibCell.collectionCellImgView.image = UIImage(named: "pdf")
            case "doc" :
                xibCell.collectionCellImgView.image = UIImage(named: "doc")
            case "docx" :
                xibCell.collectionCellImgView.image = UIImage(named: "docx")
            case "xlsx" :
                xibCell.collectionCellImgView.image = UIImage(named: "xlsx")
            default :
                break
            }
            return xibCell
        }
        return UICollectionViewCell()
    }
}


extension FirebaseStorageViewController : GetImage {
    func updateCollection() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
