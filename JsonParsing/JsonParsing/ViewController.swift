//
//  ViewController.swift
//  JsonParsing
//
//  Created by Bella Wei on 8/2/21.
//

import UIKit

struct APIResponse: Codable {
    var collection: collections
}

struct collections: Codable {
    var items: [Result]
}

struct Result: Codable {
    var links: [Link]
    var data: [Data]
}

struct Data: Codable {
    var nasa_id: String
    var title: String
}

struct Link: Codable {
    var href: String
    var rel: String
    var render: String
}

class ViewController: UIViewController, UICollectionViewDataSource {
    
    var results: [Result] = []
    var linkResults:[Link] = []
    
    var dataResults:[Data] = []
    let urlString = "http://images-api.nasa.gov/search?q=mars&media_type=image"
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Hit the API endpoint
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
       layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.indentifier)
        collectionView.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height - 55)
        view.addSubview(collectionView)

        
        self.collectionView = collectionView
       collectionView.dataSource = self

        fetchPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.reloadData()
    }
    
    func fetchPhotos(){
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url){
         [weak self]   data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                print(jsonResult.collection.items.count)
                DispatchQueue.main.async { [self] in
                    self?.results = jsonResult.collection.items
                 //   print(self?.results)
                    self?.collectionView?.reloadData()
                }
                
            }catch{
                print(error)
            }
    
        }
        task.resume()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(self.results)

      
     
       
  //   let imageURLString = imageLinks[indexPath.row].href
     //   print(imageURLString)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.indentifier, for: indexPath)as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }

   //    cell.configure(with: imageURLString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.results.count
    }
    

}

