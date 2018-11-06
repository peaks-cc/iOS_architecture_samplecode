//
//  ViewController.swift
//  CocoaMVCSample
//
//  Created by 史翔新 on 2018/11/07.
//  Copyright © 2018年 史翔新. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var myModel: Model? {
		didSet { // ViewとModelとを結合し、Modelの監視を開始する
			registerModel()
		}
	}
	
	private(set) lazy var myView: View = View()
	
	override func loadView() {
		view = myView
	}
	
	deinit {
		myModel?.notificationCenter.removeObserver(self)
	}
	
	private func registerModel() {
		
		guard let model = myModel else { return }
		
		myView.label.text = model.count.description
		
		myView.minusButton.addTarget(self, action: #selector(onMinusTapped), for: .touchUpInside)
		myView.plusButton.addTarget(self, action: #selector(onPlusTapped), for: .touchUpInside)
		
		model.notificationCenter.addObserver(forName: .init(rawValue: "count"),
											 object: nil,
											 queue: nil,
											 using: { [unowned self] notification in
												if let count = notification.userInfo?["count"] as? Int {
													self.myView.label.text = "\(count)"
												}
		})
		
	}
	
	@objc func onMinusTapped() {
		myModel?.countDown()
	}
	
	@objc func onPlusTapped() {
		myModel?.countUp()
	}
	
}

class Model {
	
	let notificationCenter = NotificationCenter()
	
	private(set) var count = 0 {
		didSet {
			notificationCenter.post(name: .init(rawValue: "count"),
									object: nil,
									userInfo: ["count": count])
		}
	}
	
	func countDown() {
		count -= 1
	}
	
	func countUp() {
		count += 1
	}
	
}

class View: UIView {
	
	let label = UILabel()
	let minusButton = UIButton()
	let plusButton = UIButton()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setSubviews()
		setLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		return nil
	}
	
	private func setSubviews() {
		
		addSubview(label)
		addSubview(minusButton)
		addSubview(plusButton)
		
		label.textAlignment = .center
		
		label.backgroundColor = .blue
		minusButton.backgroundColor = .red
		plusButton.backgroundColor = .green
		
		minusButton.setTitle("-1", for: .normal)
		plusButton.setTitle("+1", for: .normal)
		
	}
	
	private func setLayout() {
		
		label.translatesAutoresizingMaskIntoConstraints = false
		plusButton.translatesAutoresizingMaskIntoConstraints = false
		minusButton.translatesAutoresizingMaskIntoConstraints = false
		
		label.topAnchor.constraint(equalTo: topAnchor).isActive = true
		label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		label.bottomAnchor.constraint(equalTo: minusButton.topAnchor).isActive = true
		label.bottomAnchor.constraint(equalTo: plusButton.topAnchor).isActive = true
		label.heightAnchor.constraint(equalTo: minusButton.heightAnchor).isActive = true
		label.heightAnchor.constraint(equalTo: plusButton.heightAnchor).isActive = true
		minusButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		plusButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		minusButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		minusButton.rightAnchor.constraint(equalTo: plusButton.leftAnchor).isActive = true
		plusButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		minusButton.widthAnchor.constraint(equalTo: plusButton.widthAnchor).isActive = true
		
	}
	
}
