//
//  FirebaseStorageViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 04/03/22.
//

import UIKit

class FirebaseStorageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageCollectionViewModel : ValidationFields?
     
    @IBOutlet weak var collectionView: UICollectionView!
    
    var width = UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionViewModel = ValidationFields()
        imageCollectionViewModel?.delegate = self
        imageCollectionViewModel?.dwnloadImgFrmStorage()
    }
    @IBAction func uploadToCStorage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
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


extension FirebaseStorageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(imageCollectionViewModel?.imageArr.count)
        return imageCollectionViewModel?.imageArr.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imgData = imageCollectionViewModel?.imageArr[indexPath.row] else { return UICollectionViewCell()}
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorageCollectionViewCell", for: indexPath) as? StorageCollectionViewCell {
            cell.img.widthAnchor.constraint(equalToConstant: ( width/2-10)).isActive = true
            cell.img.heightAnchor.constraint(equalToConstant:( width/2-10)).isActive = true
            
            cell.img.image = UIImage(data: imgData)
            return cell
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
