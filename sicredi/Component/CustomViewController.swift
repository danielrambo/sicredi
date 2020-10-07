//
//  CustomViewController.swift
//  sicredi
//
//  Created by Daniel Rambo on 04/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation
import UIKit

open class CustomViewController: UIViewController {
    
    // MARK: - Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Properties
    
    private(set) weak var mainView: UIView!
}

// MARK: - Override

extension CustomViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

// MARK: - Computed Properties

private extension CustomViewController {
    var viewTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.topAnchor
        } else {
            return topLayoutGuide.bottomAnchor
        }
    }
    
    var viewBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomLayoutGuide.topAnchor
        }
    }
}

// MARK: - Public Methods

extension CustomViewController {
    func buildMainStackView(scrollViewEnabled: Bool = false,
                            padding: UIEdgeInsets = .all16) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        var contentView: UIView!
        
        if scrollViewEnabled {
            let scroolView = UIScrollView(frame: .zero)
            scroolView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 12.0, right: 0.0)
            scroolView.scrollIndicatorInsets = UIEdgeInsets(top: 4.0, left: 0.0, bottom: 12.0, right: 0.0)
            contentView = scroolView
            automaticallyAdjustsScrollViewInsets = false
        } else {
            contentView = UIView(frame: .zero)
        }
        
        contentView.embed(newView: stackView, padding: padding)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(contentView)
        
        contentView.topAnchor.constraint(equalTo: viewTopAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewBottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        if scrollViewEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
                let constant = -(padding.left + padding.right)
                stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                 constant: constant).isActive = true
            }
        }
        
        return stackView
    }
    
    func toggleLoading(_ show: Bool) {
        if show {
            self.pendingLoaders += 1
            view.addSubview(blockView)
            view.bringSubviewToFront(blockView)
        } else {
            pendingLoaders -= 1

            if pendingLoaders <= 0 {
                if blockView.superview != nil {
                    blockView.removeFromSuperview()
                }
            }
        }
    }

    var pendingLoaders: Int {
        get {
            if let o = objc_getAssociatedObject(self, &ak_PendingLoaders) as? Int {
                return o
            }
            return 0
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ak_PendingLoaders, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    var blockView: UIView {
        get {
            if let o = objc_getAssociatedObject(self, &ak_ViewBlock) as? UIView {
                return o
            }
            let blockView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            blockView.backgroundColor = UIColor(white: 0, alpha: 0.3)

            let contentView = UIView(frame: CGRect(x: (blockView.frame.midX - 100), y: (blockView.frame.midY - 25), width: 200, height: 50))
            contentView.backgroundColor = UIColor.white
            contentView.alpha = 1
            contentView.layer.cornerRadius = 8

            let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
            textLabel.font = UIFont.systemFont(ofSize: 16.0)
            textLabel.textColor = UIColor.gray
            textLabel.text = "Aguarde..."

            let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityView.startAnimating()

            contentView.addSubview(textLabel)
            contentView.addSubview(activityView)

            blockView.addSubview(contentView)
            blockView.bringSubviewToFront(contentView)

            objc_setAssociatedObject(self, &ak_ViewBlock, blockView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)

            return blockView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ak_ViewBlock, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func presentAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlert(error: Error, isClosedScreen: Bool = true) {
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            if isClosedScreen {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        presentAlert(title: "Atenção", message: error.localizedDescription, actions: [okAction])
    }
    
    func setColorSafeAreaButton(color: UIColor) {
        if #available(iOS 11.0, *) {
            let safeAreaView = UIView(frame: .zero)
            safeAreaView.translatesAutoresizingMaskIntoConstraints = false
            safeAreaView.backgroundColor = color
            view.addSubview(safeAreaView)
            
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
}

private var ak_ViewSpinner: UInt8 = 0
private var ak_ViewBlock: UInt8 = 1
private var ak_PendingLoaders: UInt8 = 2
