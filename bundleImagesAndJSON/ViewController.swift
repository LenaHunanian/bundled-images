//
//  ViewController.swift
//  bundleImagesAndJSON
//
//  Created by Lena Hunanian on 04.07.25.
//

import UIKit

struct Config : Codable {
    let title : String
    let maxVisibleImages : Int
    let images : [String]
    
}


class ViewController: UIViewController {
    
    //UI components
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTitleLabel()
        setupScrollViewAndStackView()
        if let config = loadConfiguration() {
        titleLabel.text = config.title
        loadConfiguredImages(from: config)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    
    private func setupScrollViewAndStackView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)

        ])
    }
    
    //MARK: - loading config from JSON
    
    private func loadConfiguration() -> Config? {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "json") else {
            print("Configuration file not found")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(Config.self, from: data)
        }catch {
            print("failed to decode Configuration")
            return nil
        }
    }
    private func loadConfiguredImages(from config: Config) {
        let imagesToLoad = Array(config.images.prefix(config.maxVisibleImages))
        
        for image in imagesToLoad {
            if let image = UIImage(named:image) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 8
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
                stackView.addArrangedSubview(imageView)
            }else {
                print("Image '\(image)' not found in bundle.")
            }
        }
    }
    


}

