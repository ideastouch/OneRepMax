//
//  WorkoutChart.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/24/24.
//

import SwiftUI
import Charts
import SwiftData

enum YDomainRange: String, Identifiable, CaseIterable {
    case fullRange = "Full Range"
    case minToMax = "Min to Max"
    
    var id: Self { self }
}

struct WorkoutChart: View {
    let exercise: String
    @Query private var workoutList: [Workout]
    @State private var minOneRM: Int16 = 0
    @State private var maxOneRM: Int16 = 0
    @State private var xAxisValues: [Int] = .init()
    @State private var activityIndicatorActive = false
    private let yDomainRange: YDomainRange
    init(exercise: String, yDomainRange: YDomainRange) {
        self.exercise = exercise
        self.yDomainRange = yDomainRange
        let predicateExercise = #Predicate<Workout> {
            $0.exercise == exercise }
        _workoutList = Query(
            filter: predicateExercise,
            sort: [SortDescriptor(\Workout.date, order: .forward)])
    }
    
    
    func equidistantIndexes(count: Int) -> [Int] {
        return [0, count / 4, count / 2, (count * 3) / 4, count - 1]
    }
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yy"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        Chart(Array(workoutList.enumerated()), id: \.element.id) { index, workout in
            LineMark(
                x: .value("Day", index),
                y: .value("One Rep Max", workout.oneRepMax)
            )
            .symbol(by: .value("workout", exercise))
            .interpolationMethod(.linear)
        }
        .chartXAxis {
            AxisMarks(values: self.xAxisValues) {
                value in
                AxisValueLabel {
                    Text(formatDate( workoutList[value.index].date ))
                }
            }
        }
        .chartYScale(domain: (yDomainRange == .fullRange ? 0 : minOneRM) ... maxOneRM)
        .chartLegend(.hidden)
        .onAppear {
            activityIndicatorActive.toggle()
            updateMinMaxOneRM()
            activityIndicatorActive.toggle()
        }
        .activityIndicator(isActive: activityIndicatorActive,
                           label: "Loading Data ..")
    }
    
    private func updateMinMaxOneRM() {
        guard !workoutList.isEmpty else {
            return
        }
        
        let minOneRM = workoutList.reduce(into: Int16.max) { $0 = min($0, $1.oneRepMax) }
        self.minOneRM = max(0, Int16(Float(minOneRM) * 0.7))
        
        let maxOneRM = workoutList.reduce(into: Int16.min) { $0 = max($0, $1.oneRepMax) }
        self.maxOneRM = Int16(Float(maxOneRM) * 1.2)
        let count = workoutList.count
        self.xAxisValues = [0, count / 4, count / 2, (count * 3) / 4, count - 1]
    }
}

fileprivate
struct Proxy: View {
    @Query private var workoutHistoricalList: [WorkoutHistorical]
    @Query private var workoutList: [Workout]
    let yDomainRange: YDomainRange
    init(yDomainRange: YDomainRange) {
        self.yDomainRange = yDomainRange
        let exercise = workoutHistoricalList.first?.exercise ?? "N/A"
        let predicateExercise = #Predicate<Workout> {
            $0.exercise == exercise }
        _workoutList = Query(
            filter: predicateExercise,
            sort: [SortDescriptor(\Workout.date, order: .forward)])
        
    }
    var body: some View {
        WorkoutChart(exercise: workoutHistoricalList.first?.exercise ?? "N/A",
                     yDomainRange: .fullRange)
    }
}
#Preview("Full Range", traits: .sizeThatFitsLayout) {
    LoadingPreviewProxy {
        Proxy(yDomainRange: .fullRange)
            .padding()
    }
}
#Preview("Min Max Range", traits: .sizeThatFitsLayout) {
    LoadingPreviewProxy {
        Proxy(yDomainRange: .minToMax)
            .padding()
    }
}
