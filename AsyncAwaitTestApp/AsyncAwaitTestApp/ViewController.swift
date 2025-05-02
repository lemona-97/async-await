//
//  ViewController.swift
//  AsyncAwaitTestApp
//
//  Created by wooseob on 5/2/25.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBAction func fetchCatImageButton(_ sender: Any) {
        Task {
            let catImage = try await fetchCatImage()
            myImageView.image = catImage
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func fetchCatImage() async throws -> UIImage {
        let request = imageURLRequest()
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badURL) }
        let maybeImage = UIImage(data: data)
        guard let thumbnail = await maybeImage?.thumbnail else { throw URLError(.badURL) }
        return thumbnail
    }
    
    func imageURLRequest() -> URLRequest {
        guard let url = URL(string: "https://d3544la1u8djza.cloudfront.net/APHI/Blog/2020/07-23/How+Much+Does+It+Cost+to+Have+a+Cat+_+ASPCA+Pet+Insurance+_+black+cat+with+yellow+eyes+peeking+out-min.jpg") else {
            return URLRequest(url: URL(string: "https://placeholder")!)
        }
        let request = URLRequest(url: url, timeoutInterval: 30.0)
        return request
    }
}


extension UIImage {
    var thumbnail: UIImage? {
        get async {
            let size = CGSize(width: 80, height: 80)
            return await self.byPreparingThumbnail(ofSize: size)
        }
    }
}
