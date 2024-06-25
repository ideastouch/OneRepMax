//
//  DayValueView.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/25/24.
//

import Foundation
import SwiftUI
import Charts

struct DataPoint: Identifiable {
    let day: Date
    let value: Int
    
    var id: Date {
        return day
    }
}
struct DataPointFactory {
    var dataPoints: [DataPoint] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dataPoints = [
            DataPoint(day: dateFormatter.date(from: "2023-06-20")!, value: 8),
            DataPoint(day: dateFormatter.date(from: "2023-08-20")!, value: 10),
            DataPoint(day: dateFormatter.date(from: "2024-03-20")!, value: 12),
            DataPoint(day: dateFormatter.date(from: "2024-03-22")!, value: 16),
            DataPoint(day: dateFormatter.date(from: "2024-03-23")!, value: 18),
            DataPoint(day: dateFormatter.date(from: "2024-05-20")!, value: 14),
            DataPoint(day: dateFormatter.date(from: "2024-05-22")!, value: 16),
            DataPoint(day: dateFormatter.date(from: "2024-05-23")!, value: 18),
            DataPoint(day: dateFormatter.date(from: "2024-06-20")!, value: 14),
            DataPoint(day: dateFormatter.date(from: "2024-06-22")!, value: 16),
            DataPoint(day: dateFormatter.date(from: "2024-06-23")!, value: 18)
        ]
        
        return dataPoints
    }
    
    var dataPointsOneDay: [DataPoint] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dataPoints = [
            DataPoint(day: dateFormatter.date(from: "2023-06-10")!, value: 8),
            DataPoint(day: dateFormatter.date(from: "2023-06-11")!, value: 10),
            DataPoint(day: dateFormatter.date(from: "2023-06-12")!, value: 12),
            DataPoint(day: dateFormatter.date(from: "2023-06-13")!, value: 14),
            DataPoint(day: dateFormatter.date(from: "2023-06-14")!, value: 16),
            DataPoint(day: dateFormatter.date(from: "2023-06-15")!, value: 18)
        ]
        
        return dataPoints
    }
    var dataPoints7Days: [DataPoint] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dataPoints = [
            DataPoint(day: dateFormatter.date(from: "2023-06-01")!, value: 8),
            DataPoint(day: dateFormatter.date(from: "2023-06-08")!, value: 10),
            DataPoint(day: dateFormatter.date(from: "2023-06-15")!, value: 12),
            DataPoint(day: dateFormatter.date(from: "2023-06-22")!, value: 14),
            DataPoint(day: dateFormatter.date(from: "2023-06-29")!, value: 16)
        ]
        
        return dataPoints
    }
}
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct DayValueView: View {
    let dataPoints: [DataPoint]
    func equidistantIndexes(count: Int) -> [Int] {
        return [0, count / 4, count / 2, (count * 3) / 4, count - 1]
    }
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yy"
        return dateFormatter.string(from: date)
    }

    var body: some View {
        let indexes = equidistantIndexes(count: dataPoints.count)
        
        return Chart {
            ForEach(Array(dataPoints.enumerated()), id: \.element.id) { index, point in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Value", point.value)
                )
            }
        }
        .chartXAxis {
            AxisMarks(values: indexes) { value in
//                AxisGridLine()
//                AxisTick()
                AxisValueLabel {
                    Text(formatDate( dataPoints[value.index].day ))
                }
            }
        }
    }
    
    var body2: some View {
        Chart(dataPoints) { point in
            LineMark(
                x: .value("Day", point.day),
                y: .value("Value", point.value)
            )
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.year().month().day(), centered: true)
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
    }
}

#Preview("dataPoints") {
    DayValueView(dataPoints: DataPointFactory().dataPoints)
}

#Preview("dataPointsOneDay") {
    DayValueView(dataPoints: DataPointFactory().dataPointsOneDay)
}

#Preview("dataPoints7Days") {
    DayValueView(dataPoints: DataPointFactory().dataPoints7Days)
}


