open class Mediator<ColleagueType> {
    
    private class ColleagueWrapper {
        var strongColleague: AnyObject?
        weak var weakColleague: AnyObject?
        
        var colleague: ColleagueType? {
            return (weakColleague ?? strongColleague) as? ColleagueType
        }
        
        init(weakColleague: ColleagueType) {
            self.strongColleague = nil
            self.weakColleague = weakColleague as AnyObject
        }
        
        init(strongColleague: ColleagueType) {
            self.strongColleague = strongColleague  as AnyObject
            self.weakColleague = nil
        }
    }
    
    // MARK: - Instance Properties
    private var colleagueWrappers: [ColleagueWrapper] = []
    
    public var colleagues: [ColleagueType] {
        var colleagues: [ColleagueType] = []
        colleagueWrappers = colleagueWrappers.filter {
            guard let colleague = $0.colleague else { return false }
            colleagues.append(colleague)
            return true
        }
        return colleagues
    }
    
    // MARK: - Object Lifecycle
    public init() { }
    
    // MARK: - Colleague Management
    public func addColleague(_ colleague: ColleagueType, strongReference: Bool = true) {
        let wrapper: ColleagueWrapper
        if strongReference {
            wrapper = ColleagueWrapper(strongColleague: colleague)
        } else {
            wrapper = ColleagueWrapper(weakColleague: colleague)
        }
        colleagueWrappers.append(wrapper)
    }
    
    public func removeColleague(_ colleague: ColleagueType) {
        guard let index = colleagues.firstIndex(where: {
            ($0 as AnyObject) === (colleague as AnyObject)
        }) else { return }
        colleagueWrappers.remove(at: index)
    }
    
    public func invokeColleagues(closure: (ColleagueType) -> Void) {
      colleagues.forEach(closure)
    }

    public func invokeColleagues(by colleague: ColleagueType,
                                 closure: (ColleagueType) -> Void) {
      colleagues.forEach {
        guard ($0 as AnyObject) !== (colleague as AnyObject)
          else { return }
        closure($0)
      }
    }
}
