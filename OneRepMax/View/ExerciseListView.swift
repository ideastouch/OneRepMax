//
//  CompanyListView.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import SwiftUI
import SwiftData

struct CompanyListView: View {
    @Query private var companyList: [Company]
    init(sortSelection: SortSelection, filter: String) {
        let predicate = #Predicate<Company> {
            $0.name.localizedStandardContains(filter)
            || $0.symbol.localizedStandardContains(filter)
            || filter.isEmpty
        }
        let predicateFavorities = #Predicate<Company> {
            $0.favorite == true
            && (
                $0.name.localizedStandardContains(filter)
                || $0.symbol.localizedStandardContains(filter)
                || filter.isEmpty
                )
        }
        switch sortSelection {
        case .NoOrder:
            _companyList = Query(filter: predicate,
                                 animation: .bouncy)
        case .Name:
            _companyList = Query(filter: predicate,
                                 sort: [SortDescriptor(\Company.name)],
                                 animation: .bouncy)
        case .MarketCap:
            _companyList = Query(filter: predicate,
                                 sort: [SortDescriptor(\Company.marketCap.raw)],
                                 animation: .bouncy)
        case .Favorities:
            _companyList = Query(filter: predicateFavorities,
                                 animation: .bouncy)
        }
    }
    var body: some View {
        Group {
            if companyList.isEmpty {
                Text("There are not company listed at the moment")
            } else {
                List {
                    ForEach(companyList) { company in
                        NavigationLink {
                            CompanyDetailView(company: company)
                        } label: {
                            CompanyCellView(company: company)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @State var sortSelection: SortSelection = .NoOrder
    @State var filterBy: String = .init()
    return LoadingPreviewProxy {
        CompanyListView(sortSelection: sortSelection, filter: filterBy)
    }
}
