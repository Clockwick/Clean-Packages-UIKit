//
//  LabelRadioTableView.swift
//  UI
//
//  Created by Paratthakorn Sribunyong on 10/2/2568 BE.
//

import UIKit
import RxSwift
import RxCocoa
import Utils

public class LabelRadioTableView: UIView {
  // MARK: - Private Properties
  private let disposeBag = DisposeBag()
  fileprivate let itemsRelay = BehaviorRelay<[LabelRadioItem]>(value: [])
  fileprivate let editingCompletedRelay = PublishRelay<[LabelRadioItem]>()
  
  // MARK: - UI Components
  private let tableView = UITableView().apply {
    $0.register(LabelRadioTableViewCell.self, forCellReuseIdentifier: LabelRadioTableViewCell.reuseID)
    $0.showsVerticalScrollIndicator = false
    $0.separatorStyle = .none
    $0.isEditing = true
    $0.allowsSelectionDuringEditing = true
  }
  
  // MARK: - Init
  public init() {
    super.init(frame: .zero)
    setupView()
    setupConstraint()
    setupAction()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private Methods
  private func setupView() {
    addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func setupConstraint() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupAction() {
    itemsRelay
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] items in
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
  
  
  private func updateItem(at index: Int, transform: (inout LabelRadioItem) -> Void) {
    var items = itemsRelay.value
    guard items.indices.contains(index) else { return }
    let oldItem = items[index]
    transform(&items[index])
    if items[index] != oldItem {
      itemsRelay.accept(items)
      editingCompletedRelay.accept(items)
    }
  }
}

// MARK: - UITableViewDataSource
extension LabelRadioTableView: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsRelay.value.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelRadioTableViewCell.reuseID, for: indexPath) as? LabelRadioTableViewCell else {
      return UITableViewCell()
    }
    
    let item = itemsRelay.value[indexPath.row]
    cell.configure(with: item)
    
    cell.rx.textEditCompleted
      .subscribe(onNext: { [weak self, weak cell] _ in
        guard let self = self,
              let cell = cell else { return }
        self.updateItem(at: indexPath.row) { $0.text = cell.labelRadio.text }
      })
      .disposed(by: cell.disposeBag)
    
    cell.rx.selectionChanged
      .subscribe(onNext: { [weak self] isSelected in
        self?.updateItem(at: indexPath.row) { $0.isSelected = isSelected }
      })
      .disposed(by: cell.disposeBag)
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension LabelRadioTableView: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    var items = itemsRelay.value
    let item = items.remove(at: sourceIndexPath.row)
    items.insert(item, at: destinationIndexPath.row)
    itemsRelay.accept(items)
    editingCompletedRelay.accept(items)
  }
  
  public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }
  
  public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
}

// MARK: - Reactive Extension
public extension Reactive where Base: LabelRadioTableView {
  @MainActor
  var items: Binder<[LabelRadioItem]> {
    Binder(base) { view, items in
      view.itemsRelay.accept(items)
    }
  }
  
  @MainActor
  var itemsStream: Observable<[LabelRadioItem]> {
    base.itemsRelay.asObservable()
  }
  
  @MainActor
  var editingCompleted: Observable<[LabelRadioItem]> {
    base.editingCompletedRelay.asObservable()
  }
}
