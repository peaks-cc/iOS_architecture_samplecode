//
//  LayerBuilder.swift
//  CleanGitHub
//
//  Created by 加藤寛人 on 2018/09/21.
//  Copyright © 2018年 Peaks. All rights reserved.
//

import Foundation

class Layer {

    /// Shared instance
    static let shared = Layer()

    // Can't initialize from outside
    private init() {
    }

    func build() {

        // Use Case
        let usecase = ReposLikesUseCase(output: nil,
                                        reposGateway: nil,
                                        likesGateway: nil)

        // Interface Adapters
        let usecaseOutput = ReposPresenter(usecaseInput: usecase,
                                           presenterOutput: nil)
        let reposGateway = ReposGateway(repository: nil)
        let likesGateway = LikesGateway(repository: nil)

        usecase.output = usecaseOutput
        usecase.reposGateway = reposGateway
        usecase.likesGateway = likesGateway

        // Framework & Drivers

    }
}
