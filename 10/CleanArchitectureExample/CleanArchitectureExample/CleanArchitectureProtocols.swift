protocol Controller {
    associatedtype UseCase: UseCaseInputPort
    var useCase: UseCase { get set }
}

protocol UseCaseInputPort {}

protocol UseCaseInteractor {
    associatedtype Input: UseCaseInputPort
}

protocol UseCaseOutputPort {}

protocol Presenter {
    associatedtype Output: UseCaseOutputPort
}
