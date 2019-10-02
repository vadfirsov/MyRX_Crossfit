//
//  CoreDataManager.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 02/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let context = AppDelegate.viewContext
    let request : NSFetchRequest<Exercise> = Exercise.fetchRequest()
    
    //MARK: - EXERCISE METHODS -
    func save(exerciseName : String) -> [Exercise] {
        
        let exerciseContext = Exercise(context: context)
        exerciseContext.name = exerciseName
            
        do { try context.save() }
        catch { print(error.localizedDescription) }
            
        return exercisesFromDB()
    }
        
    func exercisesFromDB() -> [Exercise] {
            
        request.sortDescriptors = [NSSortDescriptor(
        key: "name",
        ascending: true,
        selector: #selector(NSString.localizedStandardCompare(_:))
        )]
        do {
            let exercises = try context.fetch(request)
            return exercises
        }
        catch {
            print(error.localizedDescription)
            return [Exercise]()
        }
    }
        
    func edit(exercise : Exercise, newName : String) -> [Exercise] {

        let request : NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let exercisesDB = try? context.fetch(request)
        for ex in exercisesDB! {
            if ex.name == exercise.name { ex.name = newName }
        }
        
        do { try context.save() }
        catch { print(error.localizedDescription) }
        return exercisesFromDB()
    }
    
    func delete(exercise : Exercise) -> [Exercise] {
        context.delete(exercise)
        do { try context.save() }
        catch { print(error.localizedDescription) }
        return exercisesFromDB()
    }
}
