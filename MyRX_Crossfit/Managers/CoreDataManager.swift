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
    
    //MARK: - EXERCISE METHODS -
    func save(exerciseName : String) -> [Exercise] {
        
        let exerciseContext = Exercise(context: context)
        exerciseContext.name = exerciseName
        saveContext()
        return exercisesFromDB()
    }
        
    func exercisesFromDB() -> [Exercise] {
        
        let request : NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
        key: "name",
        ascending: true,
        selector: #selector(NSString.localizedStandardCompare(_:)))]
        do {
            let exercises = try context.fetch(request)
            return exercises
        }
        catch {
            //TODO: show alert with error
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
        
        saveContext()
        return exercisesFromDB()
    }
    
    func delete(exercise : Exercise) -> [Exercise] {
        context.delete(exercise)
        saveContext()
        
        return exercisesFromDB()
    }
    
    func lastRecordedRepsAndWeightOf(exercise : Exercise) -> (Int,Double) {
        let recs =          recsOf(exercise: exercise)
        guard let lastRec = recs.first else { return (0,0) }
        let reps =          Int(lastRec.reps)
        let weight =        lastRec.weight
        return (reps,weight)
    }
    
    //MARK: - WORKOUTS METHODS -
    func workoutsFromDB() -> [Workout] {
        
        let request : NSFetchRequest<Workout> = Workout.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
        key: "date",
        ascending: false)]
        do {
            let workouts = try context.fetch(request)
            return workouts
        }
        catch {
            //TODO: show alert with error
            print(error.localizedDescription)
            return [Workout]()
        }
    }

    func save(workout : Workout) -> [Workout] {
        saveContext()
        return workoutsFromDB()
    }
    
    func delete(workout : Workout) -> [Workout] {
        context.delete(workout)
        saveContext()
        return workoutsFromDB()
    }

    
    //MARK: - RECORDS METHODS -
    func saveNewRecord(toExercise exercise: Exercise, withReps reps : String, dateStr : String, weight : String, date : Date) -> [ExerciseRec] {
        
        let rec = ExerciseRec(context: context)
                
        rec.dateStr = dateStr
        rec.date = date
        
        if let repsDouble = Double(reps) { rec.reps = repsDouble }
        else { }//alert that it should be numba!

        if let weightDouble = Double(weight) { rec.weight = weightDouble }
        else { } //show alert
        
        rec.exercise = exercise
        saveContext()
            
        return recsOf(exercise: exercise)
    }
        
    func recsOf(exercise : Exercise) -> [ExerciseRec] {
            
        let request : NSFetchRequest<ExerciseRec> = ExerciseRec.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: "date",
            ascending: false
            )]
        
        var recs = [ExerciseRec]()

        do {
            let exerciseRecs = try context.fetch(request)
            for rec in exerciseRecs {
                if rec.exercise == exercise {
                    recs.append(rec)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        return recs
    }
        
    func delete(rec : ExerciseRec, inEercise exercise : Exercise) -> [ExerciseRec] {
        context.delete(rec)
        saveContext()
        return recsOf(exercise: exercise)
    }
    
    private func saveContext() {
        do { try context.save() }
        catch { print(error.localizedDescription) }
    }
}
