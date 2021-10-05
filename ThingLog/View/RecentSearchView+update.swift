//
//  RecentSearchView+update.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/05.
//

import UIKit

extension RecentSearchView {
    /// 최근 검색어 내역이 없거나, 검색어 저장 기능이 꺼져있는 경우를 표시하기 위해 업데이트하는 메서드다
    private func updateInformationLabel(isAutoSaveMode: Bool) {
        if isAutoSaveMode {
            informationLabel.text = "최근 검색어 내역이 없습니다"
        } else {
            informationLabel.text = "검색어 저장 기능이 꺼져 있습니다"
        }
    }

    /// 자동저장 기능이 켜져있거나 꺼져있을 때 필요한 뷰 전환 메서드다.
    /// - Parameter bool: 자동저장 기능이 켜져있다면 true, 그렇지 않다면 false 를 주입한다.
    private func updateRecentView(_ bool: Bool ) {
        updateInformationLabel(isAutoSaveMode: bool)
        autoSaveButton.setTitle(bool ? "자동저장 끄기" : "자동저장 켜기", for: .normal)
        
        if bool {
            let isEmptyData: Bool = recentSearchDataViewModel.isRecentSearchDataEmpty
            tableView.isHidden = isEmptyData
            informationStackView.isHidden = !isEmptyData
        } else {
            tableView.isHidden = true
            informationStackView.isHidden = false
        }
        
        layoutSubviews()
        layoutSubviews()
    }
    // MARK: - Subscribe
    func setupTableView() {
        // TableView
        recentSearchDataViewModel
            .recentSearchDataSubject
            .bind(to: tableView.rx.items(cellIdentifier: LeftLabelRightButtonTableCell.reuseIdentifier, cellType: LeftLabelRightButtonTableCell.self)) { indexPath, item, cell in
                cell.updateLeftLabelTitle(item)
                cell.rightButton.rx.tap
                    .bind { [weak self] in
                        self?.recentSearchDataViewModel.remove(at: indexPath)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.delegate = self
    }
    
    func subscribeViewModel() {
        // 자동검색 기능의 상태가 변할 때
        recentSearchDataViewModel
            .isAutoSaveModeSubject
            .bind { [weak self] isAutoSaveMode in
                self?.updateRecentView(isAutoSaveMode)
            }
            .disposed(by: disposeBag)
        
        // 최근검색데이터 개수가 변할 때
        recentSearchDataViewModel
            .recentSearchDataSubject
            .bind { [weak self] _ in
                guard let currentAutoSaveMode: Bool = self?.recentSearchDataViewModel.isAutoSaveMode else { return }
                self?.updateRecentView(currentAutoSaveMode)
            }
            .disposed(by: disposeBag)
    }
    
    /// 자동검색 버튼 subsribe
    func subscribeAutoSaveButton() {
        autoSaveButton.rx.tap
            .bind { [weak self] in
                guard let currentAutoSaveMode: Bool = self?.recentSearchDataViewModel.isAutoSaveMode else { return }
                self?.recentSearchDataViewModel.changeAutoSaveMode(isAuto: !currentAutoSaveMode)
            }
            .disposed(by: disposeBag)
    }
    
    /// 전체삭제 버튼 subscribe
    func subscribeClearButton() {
        clearTotalButton.rx.tap
            .bind { [weak self] in
                self?.recentSearchDataViewModel.removeAll()
            }
            .disposed(by: disposeBag)
    }
}

extension RecentSearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? LeftLabelRightButtonTableCell,
              let text = cell.leftLabel.text else { return }
        selectedIndexPathSubject.onNext(text)
    }
}
