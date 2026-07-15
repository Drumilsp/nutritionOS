import Foundation
import HealthKit

/// Maps Apple Health samples to and from HealthKit-independent application values.
enum HealthKitMapper {
    static func weight(_ sample: HKQuantitySample) -> WeightEntry {
        WeightEntry(id: sample.uuid, weight: sample.quantity.doubleValue(for: .gramUnit(with: .kilo)), recordedAt: sample.startDate, source: .healthKit)
    }

    static func activeEnergy(_ sample: HKQuantitySample) -> ActiveEnergySample {
        ActiveEnergySample(id: sample.uuid.uuidString, date: sample.startDate, kilocalories: sample.quantity.doubleValue(for: .kilocalorie()))
    }

    static func workout(_ workout: HKWorkout) -> HealthWorkout {
        HealthWorkout(id: workout.uuid.uuidString, activityType: workout.workoutActivityType.name, startDate: workout.startDate, endDate: workout.endDate, activeEnergyKilocalories: workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()))
    }

    static func nutritionSamples(from food: LoggedFood) -> [HKQuantitySample] {
        let multiplier = food.loggedQuantity / food.referenceQuantity
        return food.nutritionProfileSnapshot.nutrientValues.compactMap { nutrient in
            guard let identifier = dietaryIdentifier(for: nutrient.nutrientType), let type = HKObjectType.quantityType(forIdentifier: identifier) else { return nil }
            let unit: HKUnit = nutrient.nutrientType == .calories ? .kilocalorie() : .gram()
            return HKQuantitySample(type: type, quantity: HKQuantity(unit: unit, doubleValue: nutrient.value * multiplier), start: food.createdAt, end: food.createdAt, metadata: [HKMetadataKeyExternalUUID: food.id.uuidString])
        }
    }

    static func waterSample(from entry: WaterEntry) -> HKQuantitySample? {
        guard let type = HKObjectType.quantityType(forIdentifier: .dietaryWater) else { return nil }
        return HKQuantitySample(type: type, quantity: HKQuantity(unit: .literUnit(with: .milli), doubleValue: entry.amount), start: entry.timestamp, end: entry.timestamp, metadata: [HKMetadataKeyExternalUUID: entry.id.uuidString])
    }

    static func weightSample(from entry: WeightEntry) -> HKQuantitySample? {
        guard let type = HKObjectType.quantityType(forIdentifier: .bodyMass) else { return nil }
        return HKQuantitySample(type: type, quantity: HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: entry.weight), start: entry.recordedAt, end: entry.recordedAt, metadata: [HKMetadataKeyExternalUUID: entry.id.uuidString])
    }

    private static func dietaryIdentifier(for nutrient: NutrientType) -> HKQuantityTypeIdentifier? {
        switch nutrient {
        case .calories: .dietaryEnergyConsumed
        case .protein: .dietaryProtein
        case .carbohydrates: .dietaryCarbohydrates
        case .fat: .dietaryFatTotal
        case .fibre: .dietaryFiber
        default: nil
        }
    }
}

private extension HKWorkoutActivityType {
    var name: String { String(describing: self) }
}
