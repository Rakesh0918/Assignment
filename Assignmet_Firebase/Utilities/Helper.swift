//
//  Helper.swift
//  InstagramClone
//
//  Created by Rakesh Sharma on 18/02/24.
//  Copyright © 2024 Mac Gallagher. All rights reserved.
//

import UIKit

func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        if let image = UIImage(data: data) {
            completion(image)
        } else {
            print("Failed to create image from data")
            completion(nil)
        }
    }.resume()
}

func showAlert(title: String, message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    viewController.present(alertController, animated: true, completion: nil)
}

func formatDate(dateString: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    
    if let date = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_IN")
        outputFormatter.dateFormat = "d MMM yyyy"
        return outputFormatter.string(from: date)
    } else {
        return nil
    }
}
