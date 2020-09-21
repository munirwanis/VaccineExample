//
//  ViewController.swift
//  VaccineExample
//
//  Created by Munir Xavier Wanis on 2020-09-21.
//

import UIKit
import Vaccine

class ViewController: UIViewController {

    @Inject(JokeViewModeling.self) var viewModel
    
    private lazy var jokeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.text = "Loading..."
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var refreshButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapRefreshButton), for: .touchUpInside)
        view.setTitle("Refresh", for: .normal)
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        fetchJoke()
    }
    
    private func setupConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(jokeLabel)
        view.addSubview(refreshButton)
        view.addSubview(loaderView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            jokeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            jokeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            jokeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            jokeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            refreshButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: refreshButton.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: refreshButton.centerYAnchor),
        ])
    }
    
    @objc private func didTapRefreshButton() {
        fetchJoke()
    }
    
    private func fetchJoke() {
        loaderView.startAnimating()
        refreshButton.isHidden = true
        
        viewModel.getRandomJoke { [weak self] result in
            DispatchQueue.main.async {
                self?.loaderView.stopAnimating()
                self?.refreshButton.isHidden = false
                
                switch result {
                case .success(let model):
                    self?.jokeLabel.text = model.joke
                case .failure(let error):
                    self?.jokeLabel.text = error.localizedDescription
                }
            }
        }
    }
}

