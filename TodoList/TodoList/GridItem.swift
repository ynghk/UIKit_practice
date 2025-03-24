//
//  GridItem.swift
//  TodoList
//
//  Created by Yung Hak Lee on 3/21/25.
//

import UIKit
import CoreData

struct GridItem: Hashable {
    let id: UUID
    let title: String
    let imageSystemName: String
    let date: Date
    let category: String
    let memo: String
    
    init(title: String, imageSystemName: String, date: Date = Date(), category: String, memo: String) {
        self.id = UUID()
        self.title = title
        self.imageSystemName = imageSystemName
        self.date = date
        self.category = category
        self.memo = memo
    }
    
    init(id: UUID, title: String, imageSystemName: String, date: Date, category: String, memo: String) {
        self.id = id
        self.title = title
        self.imageSystemName = imageSystemName
        self.date = date
        self.category = category
        self.memo = memo
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: GridItem, rhs: GridItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension GridItem {
    func toManagedObject(in context: NSManagedObjectContext) -> GridItemEntity {
        let entity = GridItemEntity(context: context)
        entity.id = id
        entity.title = title
        entity.imageSystemName = imageSystemName
        entity.date = date
        entity.category = category
        entity.memo = memo
        entity.createdAt = Date()
        return entity
    }
    
    static func from(_ entity: GridItemEntity) -> GridItem? {
        guard let id = entity.id,
              let title = entity.title,
              let imageSystemName = entity.imageSystemName,
              let date = entity.date,
              let category = entity.category,
                let memo = entity.memo else {
            return nil
        }
        
        let item = GridItem(id: id, title: title, imageSystemName: imageSystemName, date: date, category: category, memo: memo)
        return item
    }
}

