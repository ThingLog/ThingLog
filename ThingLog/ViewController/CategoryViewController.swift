//
//  CategoryViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/13.
//

import CoreData
import UIKit

import RxCocoa
import RxSwift

/// 글쓰기 화면에서 카테고리 추가, 선택할 때 사용된다.
final class CategoryViewController: UIViewController {
    /// 카테고리 뷰의 타입에 따라, 선택기능 관련 뷰를 보여줄지, 수정 삭제 기능 관련 뷰를 보여줄지 정하는 타입이다.
    enum CategoryViewType {
        case select
        case modify
    }
    
    // MARK: - View Properties
    private let topBorderLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.gray4.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// 카테고리 선택하는 뷰에서는 필요한 네비게이션 우측 버튼이고, 카테고리 수정하는 뷰에서는 필요하지 않다.
    private let successButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.setTitleColor(SwiftGenColors.gray4.color, for: .disabled)
        button.titleLabel?.font = UIFont.Pretendard.body1
        return button
    }()
    private let textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.font = UIFont.Pretendard.body1
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "카테고리를 만들어보세요! (최대 20자)", attributes: [NSAttributedString.Key.foregroundColor: SwiftGenColors.gray2.color])
        return textField
    }()
    private let bottomLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.gray4.color
        return view
    }()
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = SwiftGenColors.primaryBackground.color
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    // MARK: - Properties
    var coordinator: Coordinator?
    var categoryViewType: CategoryViewType
    private lazy var repository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: self)
    private let disposeBag: DisposeBag = DisposeBag()
    private let leadingTrailingConstant: CGFloat = 18.0
    private let topBottomConstant: CGFloat = 12.0
    private var selectedCategory: [CategoryEntity] = [] {
        didSet { successButton.isEnabled = selectedCategory.isNotEmpty }
    }
    private let textFieldMaxLength: Int = 21
    
    // MARK: - Init
    init(categoryViewType: CategoryViewType) {
        self.categoryViewType = categoryViewType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        setupNavigationBar()
        setupView()
        setupBinding()
        setupToolbar()
    }
    
    // MARK: - setup
    private func setupNavigationBar() {
        setupBaseNavigationBar()
        
        let logoView: LogoView = LogoView("카테고리")
        navigationItem.titleView = logoView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: SwiftGenIcons.longArrowR.image.withRenderingMode(.alwaysTemplate),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = SwiftGenColors.primaryBlack.color
        
        if categoryViewType == .modify { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: successButton)
        successButton.isEnabled = false
    }
    
    private func setupView() {
        setupTextField()
        setupBottomLineView()
        setupTableView()
    }
    
    private func setupBinding() {
        successButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                // 선택한 카테고리를 Category 객체로 변환하여 WriteViewModel에 전달한다.
                let category: [Category] = self.convertSelectedIndexPathToCategory()
                NotificationCenter.default.post(name: .passToSelectedCategories,
                                                object: nil,
                                                userInfo: [Notification.Name.passToSelectedCategories: category])
                self.coordinator?.back()
            }.disposed(by: disposeBag)
    }
    
    private func setupToolbar() {
        let keyboardToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        keyboardToolBar.barStyle = .default
        let cancleButton: UIButton = {
            let button: UIButton = UIButton()
            button.titleLabel?.font = UIFont.Pretendard.title2
            button.setTitle("취소", for: .normal)
            button.setTitleColor(SwiftGenColors.systemBlue.color, for: .normal)
            button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
            return button
        }()
        let cancleBarButton: UIBarButtonItem = UIBarButtonItem(customView: cancleButton)
        cancleBarButton.tintColor = SwiftGenColors.black.color
        keyboardToolBar.barTintColor = SwiftGenColors.gray6.color
        keyboardToolBar.items = [cancleBarButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
        keyboardToolBar.sizeToFit()
        textField.inputAccessoryView = keyboardToolBar
    }
    
    @objc
    private func didTapBackButton() {
        coordinator?.back()
    }
    
    @objc
    private func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
    /// 선택한 카테고리를 Category 객체로 변환해서 오름차순으로 정렬 후 반환한다.
    private func convertSelectedIndexPathToCategory() -> [Category] {
        var categories: [Category] = []
        selectedCategory.forEach {
            categories.append($0.toModel())
        }
        return categories.sorted(by: { $0.title < $1.title })
    }
}

// MARK: - Setup
extension CategoryViewController {
    private func setupTextField() {
        view.addSubview(topBorderLineView)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            topBorderLineView.heightAnchor.constraint(equalToConstant: 0.3),
            topBorderLineView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBorderLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBorderLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingTrailingConstant),
            textField.topAnchor.constraint(equalTo: topBorderLineView.bottomAnchor, constant: topBottomConstant),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -leadingTrailingConstant)
        ])
        
        textField.delegate = self
    }
    
    private func setupBottomLineView() {
        view.addSubview(bottomLineView)
        
        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomLineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: topBottomConstant),
            bottomLineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: bottomLineView.bottomAnchor, constant: topBottomConstant),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RoundLabelWithButtonTableCell.self, forCellReuseIdentifier: RoundLabelWithButtonTableCell.reuseIdentifier)
        tableView.allowsMultipleSelection = true
    }
}

extension CategoryViewController {
    /// 카테고리 수정 및 삭제 기능뷰에서 삭제누를 때 나타나느 뷰,
    func showAlertViewController(indexPath: IndexPath) {
        let category: CategoryEntity = repository.fetchedResultsController.object(at: indexPath)
        
        let alert: AlertViewController = AlertViewController()
        alert.hideTextField()
        alert.titleLabel.text = "\(category.title ?? "")"
        alert.contentsLabel.text = "정말 삭제하시겠어요?\n이 동작은 취소할 수 없습니다."
        alert.leftButton.setTitle("취소", for: .normal)
        alert.rightButton.setTitle("삭제", for: .normal)
        alert.modalPresentationStyle = .overFullScreen
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)
        
        alert.rightButton.rx.tap.bind { [weak self] in
            self?.repository.delete(at: indexPath)
            alert.dismiss(animated: false, completion: nil)
            self?.tableView.contentInset.bottom = 0
        }.disposed(by: disposeBag)
        
        present(alert, animated: false, completion: nil)
    }
}

// MARK: - TableView Delegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categoryViewType == .modify { return } // 터치 발생안하도록 한다.
        let category: CategoryEntity = repository.fetchedResultsController.object(at: indexPath)
        if let index: Int = selectedCategory.firstIndex(of: category) {
            selectedCategory.remove(at: index)
        } else {
            selectedCategory.append(category)
        }
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repository.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: RoundLabelWithButtonTableCell = tableView.dequeueReusableCell(withIdentifier: RoundLabelWithButtonTableCell.reuseIdentifier, for: indexPath) as? RoundLabelWithButtonTableCell else {
            return UITableViewCell()
        }
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    private func configureCell(_ cell: RoundLabelWithButtonTableCell, at indexPath: IndexPath) {
        let category: CategoryEntity = repository.fetchedResultsController.object(at: indexPath)
        cell.backgroundColor = SwiftGenColors.primaryBackground.color
        cell.textFieldMaxLength = textFieldMaxLength
        cell.configure(name: category.title ?? "")
        cell.configure(type: categoryViewType)
        cell.isSelectedCategory = selectedCategory.contains(category)
        
        if categoryViewType == .modify {
            cell.textFieldCancleToolbarCompletion = { [weak self] in
                cell.configure(name: category.title ?? "")
                cell.nameLabel.isUserInteractionEnabled = false
                cell.nameLabel.resignFirstResponder()
                self?.tableView.contentInset.bottom = 0
            }
            
            cell.modifyButton.rx.tap.bind { [weak self] in
                cell.nameLabel.isUserInteractionEnabled = true
                cell.nameLabel.becomeFirstResponder()
                if self?.tableView.contentInset.bottom == 0 {
                    self?.tableView.contentInset.bottom += 500
                }
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }.disposed(by: cell.disposeBag)
                
            cell.deleteButton.rx.tap.bind { [weak self] in
                self?.showAlertViewController(indexPath: indexPath)
            }.disposed(by: cell.disposeBag)
            
            cell.nameLabel.rx.controlEvent(.editingDidEndOnExit).bind { [weak self] in
                cell.nameLabel.isUserInteractionEnabled = false
                self?.tableView.contentInset.bottom = 0
                if let text: String = cell.nameLabel.text, text.isEmpty {
                    cell.configure(name: category.title ?? "")
                    return
                }
                category.title = cell.nameLabel.text
                self?.repository.update()
            }.disposed(by: cell.disposeBag)
        }
    }
}

extension CategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength: Int = text.count + string.count - range.length
        return newLength <= textFieldMaxLength
    }
    
    /// 키보드에서 완료 버튼을 누르면 텍스트 필드에 입력한 내용을 Core Data Category에 저장한다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let name: String = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }
        
        guard !name.isEmpty else {
            return false
        }
        
        repository.create(Category(title: name)) { result in
            switch result {
            case .success:
                textField.text = ""
                textField.sendActions(for: .valueChanged)
                textField.resignFirstResponder()
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
        
        return true
    }
}

extension CategoryViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
