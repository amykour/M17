//
//  ViewController.swift
//  M17
//
//  Created by Алена on 01.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let service = Service()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 140, height: 140))
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    var imageStore: [UIImage?] = []
    
    let group = DispatchGroup()
    
    let semaphore = DispatchSemaphore(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        
        for i in 0...4 {
            onLoad(counter: i)
        }
        group.notify(queue: .main) {
            print("Tasks are done, making UI...")
            self.activityIndicator.stopAnimating()
            self.imageStore.forEach { image in
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                self.stackView.addArrangedSubview(imageView)
            }
            print("dogs")
        }
        
    }
    
    private func onLoad(counter: Int) {
        group.enter()
        print("Run task - \(counter)")
        service.getImageURL { urlString, error in
            guard let urlString = urlString else { return }
            let image = self.service.loadImage(urlString: urlString)
            self.imageStore.append(image)
            self.group.leave()
            print("Done task - \(counter)")
        }
    }
    
    private func setupConstraints() {
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        stackView.addArrangedSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}


