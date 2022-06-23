//
//  CoreController.swift
//  fefuactivity
//
//  Created by students on 29.05.2022.
//

import Foundation

class CoreController {
    func fetch() throws -> [ActivityData] {
        let context = CoreContainer.instance.context
        let request = ActivityData.fetchRequest()
        let raw = try context.fetch(request)
        return raw
    }
    
    func save(_ distance: Double,
              _ duration: Double,
              _ name: String,
              _ date: Date,
              _ start: String,
              _ end: String) {
        
        let context = CoreContainer.instance.context
        let activity = ActivityData(context: context)
        
        activity.name = name
        activity.date = date
        activity.start = start
        activity.end = end
        activity.distance = distance
        activity.duration = duration
    }
}
