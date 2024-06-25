//
//  CompanyCellView.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import SwiftUI



struct WorkoutCellView: View {
    //let icon: String
    var workout: WorkoutHistorical
    var body: some View {
        HStack {
//            Image(systemName:Workout.exercise)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(maxWidth: 50, maxHeight: 50)
//                .padding(.trailing, 10)
            Text(workout.exercise)
            Spacer()
            Image(systemName: workout.favorite ? "star.fill" : "star")
                .foregroundColor(workout.favorite ? .yellow : .black)
                .onTapGesture { workout.favorite.toggle() }
        }
        .padding()
        .background(Color.white)
        
    }
}

#Preview {
    ZStack {
        Color.gray
        VStack {
            WorkoutCellView(workout: .init(exercise: "Brench"))
            .padding()
            WorkoutCellView(workout: .init(exercise: "Chest", favorite: true))
            .padding()
            .padding([.horizontal, .bottom])
        }
    }
    .ignoresSafeArea()
}
