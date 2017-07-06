//
//  HomeController.swift
//  HowlFireBaseLogin
//
//  Created by 유명식 on 2017. 6. 17..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var colleectView: UICollectionView!
    var array : [UserDTO] = []
    var uidKey : [String] = []
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return array.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowCell", for: indexPath) as! CustomCell
        
        cell.subject.text = array[indexPath.row].subject
        cell.explaination.text = array[indexPath.row].explaination
        
        
        let data = try? Data(contentsOf: URL(string: array[indexPath.row].imageUrl!)!)
        cell.imageView.image = UIImage(data: data!)
        
        cell.starButton.tag = indexPath.row
        cell.starButton.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        
        if let _ = self.array[indexPath.row].stars?[(FIRAuth.auth()?.currentUser?.uid)!] {
            //좋아요가 클릭도있을 경우
        cell.starButton.setImage(#imageLiteral(resourceName: "ic_favorite"), for: .normal)
        }else{
            cell.starButton.setImage(#imageLiteral(resourceName: "ic_favorite_border"), for: .normal)
        }
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
        
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.value, with: { (FIRDataSnapshot) in
            
            self.array.removeAll()
            self.uidKey.removeAll()
            
            for child in FIRDataSnapshot.children{
                let fchild = child as! FIRDataSnapshot
                let userDTO = UserDTO()
                let uidKey = fchild.key 
                userDTO.setValuesForKeys(fchild.value as! [String:Any])
                self.array.append(userDTO)
                self.uidKey.append(uidKey)
                
                DispatchQueue.main.async {
                    self.colleectView.reloadData()
                }
                
                
                
                
            }
            
            
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func like(_ sender : UIButton){
        
        if(sender.currentImage == #imageLiteral(resourceName: "ic_favorite")){
         sender.setImage(#imageLiteral(resourceName: "ic_favorite_border"), for: .normal)
        }else{
         sender.setImage(#imageLiteral(resourceName: "ic_favorite"), for: .normal)
        }
        
        
        FIRDatabase.database().reference().child("users").child(self.uidKey[sender.tag]).runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var stars : Dictionary<String, Bool>
                stars = post["stars"] as? [String : Bool] ?? [:]
                var starCount = post["starCount"] as? Int ?? 0
                if let _ = stars[uid] {
                    // Unstar the post and remove self from stars
                    starCount -= 1
                    stars.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    starCount += 1
                    stars[uid] = true
                }
                post["starCount"] = starCount as AnyObject
                post["stars"] = stars as AnyObject
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func delete(sender:UIButton){
        
        FIRStorage.storage().reference().child("ios_images").child(self.array[sender.tag].imageName!).delete { (err) in
            if (err != nil){
                print("삭제 에러")
            }else{
                
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


class CustomCell : UICollectionViewCell{
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var explaination: UILabel!
    
    
}
