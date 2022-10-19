//
//  ViewController.swift
//  swift-drawingapp
//
//  Created by JK on 2022/07/04.
//
import UIKit

protocol DrawingDisplayLogic: AnyObject {
    func disPlayNewSquareView(viewModel: Drawing.AddSquareEvent.ViewModel)
    func disPlayNewDrawView(viewModel: Drawing.DrawEvent.ViewModel)
}

final class DrawingViewController: UIViewController {
    lazy var addSquareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("사각형 추가", for: .normal)
        button.addAction(
            UIAction(handler: { [weak self] action in
                self?.touchedAddSquareButton(action)
            }),
            for: .touchDown)
        return button
    }()
    
    lazy var drawButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("그리기", for: .normal)
        button.addAction(
            UIAction(handler: { [weak self] action in
                self?.touchedDrawButton(action)
            }),
            for: .touchDown)
        return button
    }()
    
    var canvasView: CanvasView = CanvasView()
    
    var interactor: DrawingBusinessLogic?
    var router: (NSObjectProtocol & DrawingRoutingLogic & DrawingDataPassing)?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = DrawingInteractor()
        let presenter = DrawingPresenter()
        let router = DrawingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
}

// MARK: UI + Event
extension DrawingViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        let canvasViewConstraints = [canvasView.topAnchor.constraint(equalTo: view.topAnchor),
                                     canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     canvasView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        NSLayoutConstraint.activate(canvasViewConstraints)
        
        let stackView = UIStackView(arrangedSubviews: [addSquareButton, drawButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let stackViewConstraints = [stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                    stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        NSLayoutConstraint.activate(stackViewConstraints)
    }
    
    func touchedAddSquareButton(_ action: UIAction?) {
    }
    
    func touchedDrawButton(_ action: UIAction?) {
    }
}

// MARK: Present
extension DrawingViewController: DrawingDisplayLogic {
    func disPlayNewDrawView(viewModel: Drawing.DrawEvent.ViewModel) {
    }
    
    func disPlayNewSquareView(viewModel: Drawing.AddSquareEvent.ViewModel) {
    }
}