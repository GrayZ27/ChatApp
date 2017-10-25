//
//  AvatarPickerVC.swift
//  ChatApp
//
//  Created by Gray Zhen on 10/24/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //IBoutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    //variables
    var avatarType = AvatarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
       
    }
    
    //collection view functions
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 28
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.row, type: avatarType)
            
            return cell
        }else{
            return AvatarCell()
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if avatarType == AvatarType.dark {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.row)")
        }else{
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.row)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    //--//Change the cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfColumns: CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        
        let padding:CGFloat = 20
        let spaceBetweenCell:CGFloat = 10
        
        let cellDimension = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCell) / numberOfColumns
        
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    //IBActions
    @IBAction func segmentValueChanged(_ sender: Any) {
        if segment.selectedSegmentIndex == 0 {
            avatarType = AvatarType.dark
        }else {
            avatarType = AvatarType.light
            
        }
        collectionView.reloadData()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
