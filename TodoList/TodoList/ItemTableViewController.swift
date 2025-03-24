//
//  ItemTableViewController.swift
//  TodoList
//
//  Created by Yung Hak Lee on 3/21/25.
//

import UIKit
import CoreData


class ItemTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchGridItems(text)
    }
    
    
    // MARK: Properties
    private var items: [GridItem] = []
    private var categories: [String] {
        Array(Set(items.map { $0.category })).sorted()
    }
    private var itemsByCategory: [String: [GridItem]] {
        Dictionary(grouping: items, by: { $0.category }).mapValues { $0.sorted { $0.date < $1.date} }
    }
    
    private var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureTableView()
        configureSearchController()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        
        loadGridItems()
    }
    
    func configureNavigation() {
        title = "Todo List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search items"
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    func searchGridItems(_ text: String) {
        if text.isEmpty {
            loadGridItems()
            return
        }
        
        let request: NSFetchRequest<GridItemEntity> = GridItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        
        do {
            let result = try viewContext.fetch(request)
            items = result.compactMap { GridItem.from($0) }
            tableView.reloadData()
        } catch {
            print("Failed to search: \(error)")
        }
    }
    
    @objc func addNewItem() {
        let sheetcontroller = createItemSheet(for: nil)
        present(sheetcontroller, animated: true, completion: nil)
    }
    
    private func createItemSheet(for item: GridItem?) -> UIViewController {
        let sheetController = UIViewController()
        sheetController.view.backgroundColor = .white
        
        let listField = UITextField()
        listField.placeholder = "Add a new list.."
        listField.text = item?.title
        listField.textColor = .label
        listField.layer.borderWidth = 1
        listField.layer.borderColor = UIColor.systemGray.cgColor
        listField.layer.cornerRadius = 8
        listField.font = .systemFont(ofSize: 16)
        listField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        listField.leftViewMode = .always
        listField.translatesAutoresizingMaskIntoConstraints = false
        sheetController.view.addSubview(listField)
        
        let memoField = UITextField()
        memoField.placeholder = "Add a memo"
        memoField.text = item?.memo
        memoField.textColor = .label
        memoField.layer.borderWidth = 1
        memoField.layer.borderColor = UIColor.systemGray.cgColor
        memoField.layer.cornerRadius = 8
        memoField.font = .systemFont(ofSize: 16)
        memoField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        memoField.leftViewMode = .always
        memoField.contentVerticalAlignment = .top
        memoField.translatesAutoresizingMaskIntoConstraints = false
        sheetController.view.addSubview(memoField)
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.date = item?.date ?? Date()
        sheetController.view.addSubview(datePicker)
        
        let categoryButton = UIButton(type: .system)
        categoryButton.setTitle(item?.category ?? "Select Category", for: .normal)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addTarget(self, action: #selector(showCategoryPicker), for: .touchUpInside)
        categoryButton.layer.cornerRadius = 8
        categoryButton.tintColor = .white
        categoryButton.backgroundColor = .systemBlue
        sheetController.view.addSubview(categoryButton)
        
        let actionButton = UIButton(type: .system)
        actionButton.setTitle(item != nil ? "Save" : "Add", for: .normal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(saveItemFromSheet(_:)), for: .touchUpInside)
        sheetController.view.addSubview(actionButton)
        actionButton.layer.borderColor = UIColor.systemBlue.cgColor
        actionButton.layer.cornerRadius = 10
        actionButton.layer.borderWidth = 1
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        sheetController.view.addSubview(cancelButton)
        cancelButton.layer.borderColor = UIColor.systemBlue.cgColor
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            listField.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 10),
            listField.leadingAnchor.constraint(equalTo: sheetController.view.leadingAnchor, constant: 20),
            listField.trailingAnchor.constraint(equalTo: sheetController.view.trailingAnchor, constant: -20),
            listField.heightAnchor.constraint(equalToConstant: 50),
            
            
            memoField.topAnchor.constraint(equalTo: listField.bottomAnchor, constant: 10),
            memoField.centerXAnchor.constraint(equalTo: sheetController.view.centerXAnchor),
            memoField.leadingAnchor.constraint(equalTo: sheetController.view.leadingAnchor, constant: 20),
            memoField.trailingAnchor.constraint(equalTo: sheetController.view.trailingAnchor, constant: -20),
            memoField.heightAnchor.constraint(equalToConstant: 130),
            
            datePicker.topAnchor.constraint(equalTo: sheetController.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: sheetController.view.centerXAnchor),
            
            categoryButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            categoryButton.leadingAnchor.constraint(equalTo: sheetController.view.leadingAnchor, constant: 20),
            categoryButton.widthAnchor.constraint(equalToConstant: 120),
            categoryButton.heightAnchor.constraint(equalToConstant: 30),
            
            
            actionButton.leadingAnchor.constraint(equalTo: sheetController.view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: sheetController.view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: sheetController.view.bottomAnchor, constant: -100),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            cancelButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: sheetController.view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: sheetController.view.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        if let sheet = sheetController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        sheetController.view.tag = item != nil ? 1 : 0
        if let item = item {
            sheetController.view.accessibilityIdentifier = item.id.uuidString
        }
        return sheetController
    }
    
    
    @objc func saveItemFromSheet(_ sender: UIButton) {
        guard let sheet = presentedViewController,
              let listField = sheet.view.subviews.compactMap({ $0 as? UITextField }).first(where: { $0.placeholder == "Add a new list.." }),
              let memoField = sheet.view.subviews.compactMap({ $0 as? UITextField }).first(where: { $0.placeholder == "Add a memo" }),
              let datePicker = sheet.view.subviews.compactMap({ $0 as? UIDatePicker }).first,
              let title = listField.text, !title.isEmpty, title != "Add a new list..",
              let categoryButton = sheet.view.subviews.compactMap({ $0 as? UIButton }).first(where: { $0.title(for: .normal) != "Add" && $0.title(for: .normal) != "Cancel"})
        else { return }
        
        let selectedDate = datePicker.date
        let buttonTitle = categoryButton.title(for: .normal) ?? "Undefined"
        let selectedCategory = buttonTitle == "Select Category" ? "Undefined" : buttonTitle
        let memo = memoField.text ?? ""
        
        
        let isEditing = sheet.view.tag == 1
        if isEditing, let itemIdString = sheet.view.accessibilityIdentifier, let itemId = UUID(uuidString: itemIdString) {
            updateGridItem(id: itemId, title: title, date: selectedDate, category: selectedCategory, memo: memo)
        } else {
            
            let newItem = GridItem(title: title, imageSystemName: "star.fill", date: selectedDate, category: selectedCategory, memo: memo)
            saveGridItem(newItem)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showCategoryPicker(_ sender: UIButton) {
        let categories = ["Shopping", "Entertainment", "Grocery", "Work Out", "Work", "Study", "Travel", "Personal"]
        let alert = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        
        for category in categories {
            alert.addAction(UIAlertAction(title: category, style: .default) { _ in sender.setTitle(category, for: .normal)
                print("Selected category: \(category)")})
        }
        alert.addAction(UIAlertAction(title: "Add New Category", style: .default) { _ in
            let addAlert = UIAlertController(title: "New Category", message: "Enter a new category name", preferredStyle: .alert)
            addAlert.addTextField { textField in
                textField.placeholder = "Category name"
            }
            addAlert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
                guard let newCategory = addAlert.textFields?.first?.text, !newCategory.isEmpty else { return }
                sender.setTitle(newCategory, for: .normal)
            })
            addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.presentedViewController?.present(addAlert, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.presentedViewController?.present(alert, animated: true) ?? print("No presented view controller")
    }
    
    // Cancel 버튼 액션
    @objc func dismissSheet() {
        dismiss(animated: true, completion: nil)
    }
    
    private func loadGridItems() {
        let request: NSFetchRequest<GridItemEntity> = GridItemEntity.fetchRequest()
        
        do {
            let result = try viewContext.fetch(request)
            items = result.compactMap { GridItem.from($0) }
            // 테이블 뷰 리로드
            tableView.reloadData()
        } catch {
            print("데이터 로드 실패: \(error)")
        }
    }
    
    private func saveGridItem(_ item: GridItem) {
        let _ = item.toManagedObject(in: viewContext)
        
        do {
            try viewContext.save()
            loadGridItems()
        } catch {
            print("저장 실패: \(error)")
        }
    }
    
    private func deleteGridItem(_ item: GridItem) {
        let request: NSFetchRequest<GridItemEntity> = GridItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", item.id as CVarArg)
        
        do {
            let result = try viewContext.fetch(request)
            guard let object = result.first else { return }
            
            viewContext.delete(object)
            try viewContext.save()
            
            loadGridItems()
        } catch {
            print("Failed to delete: \(error)")
        }
    }
    
    private func updateGridItem(id: UUID, title: String, date: Date, category: String, memo: String) {
        let request: NSFetchRequest<GridItemEntity> = GridItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let result = try viewContext.fetch(request)
            guard let object = result.first else { return }
            
            object.title = title
            object.date = date
            object.category = category
            object.memo = memo
            try viewContext.save()
            
            loadGridItems()
        } catch {
            print("Failed to update: \(error)")
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = categories[section]
        return itemsByCategory[category]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category = categories[indexPath.section]
        let item = itemsByCategory[category]![indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        content.text = formatter.string(from: item.date)

        
        content.secondaryText = item.title
        content.image = UIImage(systemName: item.imageSystemName)
        
        content.textProperties.font = .systemFont(ofSize: 16, weight: .medium)
        content.textProperties.numberOfLines = 0
        
        content.secondaryTextProperties.font = .systemFont(ofSize: 20, weight: .bold)
        content.secondaryTextProperties.color = .label
        content.secondaryTextProperties.numberOfLines = 0
        
        content.imageProperties.maximumSize = CGSize(width: 30, height: 30)
        content.imageProperties.tintColor = .systemBlue
        
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = categories[indexPath.section]
        let item = itemsByCategory[category]![indexPath.row]
        
        let detailVC = DetailViewController(item: item)
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    // MARK: 테이블뷰 델리게이트 메서드
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            let category = self.categories[indexPath.section]
            let item = self.itemsByCategory[category]![indexPath.row]
            
            self.deleteGridItem(item)
            completion(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

