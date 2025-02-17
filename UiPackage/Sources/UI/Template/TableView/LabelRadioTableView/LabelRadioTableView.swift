//
//  TextViewRadioTableView.swift
//  UI
//
//  Created by Paratthakorn Sribunyong on 10/2/2568 BE.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Utils

public class TextViewRadioTableView: UIView {
  // MARK: - Private Properties
  private let disposeBag = DisposeBag()
  fileprivate let itemsRelay = BehaviorRelay<[TextViewRadioItem]>(value: [])
  fileprivate let editingCompletedRelay = PublishRelay<[TextViewRadioItem]>()
  private var sourceIndexPath: IndexPath?
  
  // MARK: - UI Components
  private let tableView = UITableView().apply {
    $0.register(TextViewRadioTableViewCell.self, forCellReuseIdentifier: TextViewRadioTableViewCell.reuseID)
    $0.showsVerticalScrollIndicator = false
    $0.separatorStyle = .none
    $0.allowsSelection = true
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = 60
  }
  
  private var snapshot: UIView?
  
  // MARK: - Init
  public init() {
    super.init(frame: .zero)
    setupView()
    setupConstraint()
    setupAction()
    setupLongPressGesture()
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
  
  private func setupLongPressGesture() {
    var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    longPressGesture.minimumPressDuration = 0.5
    longPressGesture.shouldRequireFailure(of: UITapGestureRecognizer())
    tableView.addGestureRecognizer(longPressGesture)
    longPressGesture.delegate = self
  }
  
  @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    let location = gesture.location(in: tableView)
    
    switch gesture.state {
    case .began:
      guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else {
        return
      }
      
      tableView.isScrollEnabled = false
      
      sourceIndexPath = indexPath
      
      // Create snapshot
      UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
      cell.layer.render(in: UIGraphicsGetCurrentContext()!)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      // Create snapshot view
      let snapshotView = UIImageView(image: image)
      snapshotView.center = cell.center
      tableView.addSubview(snapshotView)
      
      // Animate snapshot
      UIView.animate(withDuration: 0.2) {
        snapshotView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        snapshotView.alpha = 0.9
        cell.alpha = 0.0
      }
      
      snapshot = snapshotView
      
    case .changed:
      guard let snapshot = snapshot,
            let sourceIndexPath = sourceIndexPath,
            let cell = tableView.cellForRow(at: sourceIndexPath) else {
        return
      }
      
      cell.alpha = 0.0
      // Move snapshot
      snapshot.center.y = location.y
      
      // Update destination index path
      guard let destinationIndexPath = tableView.indexPathForRow(at: location) else {
        return
      }
      
      if sourceIndexPath != destinationIndexPath {
        // Update data source
        var items = itemsRelay.value
        let item = items.remove(at: sourceIndexPath.row)
        items.insert(item, at: destinationIndexPath.row)
        itemsRelay.accept(items)
        editingCompletedRelay.accept(items)
        
        // Update table view
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        self.sourceIndexPath = destinationIndexPath
      }
      
    case .ended, .cancelled:
      guard let sourceIndexPath = sourceIndexPath,
            let cell = tableView.cellForRow(at: sourceIndexPath),
            let snapshot = snapshot else {
        return
      }
      
      tableView.isScrollEnabled = true
      
      // Animate snapshot back to cell
      UIView.animate(withDuration: 0.2, animations: {
        snapshot.center = cell.center
        snapshot.transform = .identity
        snapshot.alpha = 0.0
        cell.alpha = 1.0
      }, completion: { _ in
        snapshot.removeFromSuperview()
        self.sourceIndexPath = nil
        self.snapshot = nil
      })
      
    default:
      break
    }
  }
  
  private func updateItemById(_ id: String, transform: (inout TextViewRadioItem) -> Void) {
    var items = itemsRelay.value
    guard let index = items.firstIndex(where: { $0.id == id }) else { return }
    
    let oldItem = items[index]
    transform(&items[index])
    
    if items[index] != oldItem {
      itemsRelay.accept(items)
      editingCompletedRelay.accept(items)
    }
  }
}

// MARK: - UITableViewDataSource & Delegate implementations
extension TextViewRadioTableView: UITableViewDataSource, UITableViewDelegate {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsRelay.value.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewRadioTableViewCell.reuseID, for: indexPath) as? TextViewRadioTableViewCell else {
      return UITableViewCell()
    }
    
    let item = itemsRelay.value[indexPath.row]
    cell.configure(with: item)
    cell.itemId = item.id
    
    cell.rx.textEditCompleted
      .subscribe(onNext: { [weak self, weak cell] _ in
        guard let self = self,
              let cell = cell,
              let itemId = cell.itemId else { return }
        
        self.updateItemById(itemId) { $0.text = cell.textViewRadio.text }
      })
      .disposed(by: cell.disposeBag)
    
    cell.rx.selectionChanged
      .subscribe(onNext: { [weak self, weak cell] isSelected in
        guard let self = self,
              let cell = cell,
              let itemId = cell.itemId else { return }
        
        self.updateItemById(itemId) { $0.isSelected = isSelected }
      })
      .disposed(by: cell.disposeBag)
    
    return cell
  }
  
  public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
      guard let self = self else { return }
      var items = self.itemsRelay.value
      items.remove(at: indexPath.row)
      self.itemsRelay.accept(items)
      self.editingCompletedRelay.accept(items)
      completion(true)
    }
    
    deleteAction.image = UIImage(systemName: "trash")
    deleteAction.backgroundColor = .systemRed
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}

extension TextViewRadioTableView: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    // Allow simultaneous recognition with text input gestures
    return true
  }
}

// MARK: - Reactive Extension
public extension Reactive where Base: TextViewRadioTableView {
  @MainActor
  var items: Binder<[TextViewRadioItem]> {
    Binder(base) { view, items in
      view.itemsRelay.accept(items)
    }
  }
  
  @MainActor
  var itemsStream: Observable<[TextViewRadioItem]> {
    base.itemsRelay.asObservable()
  }
  
  @MainActor
  var editingCompleted: Observable<[TextViewRadioItem]> {
    base.editingCompletedRelay.asObservable()
  }
  
  @MainActor
  var itemDeleted: Observable<String> {
    base.editingCompletedRelay
      .withLatestFrom(base.itemsRelay) { (editedItems, currentItems) -> String? in
        guard let deletedItem = currentItems.first(where: { item in
          !editedItems.contains(where: { $0.id == item.id })
        }) else { return nil }
        return deletedItem.id
      }
      .compactMap { $0 }
  }
}
