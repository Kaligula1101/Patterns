
public class MulticastDelegate<T> {
    
    // MARK: - DelegateWrapper
    private class DelegateWrapper {
        
        weak var delegate: AnyObject?
        
        init(_ delegate: AnyObject) {
            self.delegate = delegate
        }
    }
    
    // MARK: - Instance Properties
    public var delegates: [T] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
        return delegateWrappers.map { $0.delegate! } as! [T]
    }
    private var delegateWrappers: [DelegateWrapper] = []
    
    // MARK: - Object Lifecycle
    public init() { }
    
    // MARK: - Delegate Management
    public func addDelegate(_ delegate: T) {
        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }
    
    public func removeDelegate(_ removeDelegate: T) {
        guard let index = delegateWrappers.firstIndex(where: {
            $0.delegate === (removeDelegate as AnyObject)
        }) else {
            return
        }
        delegateWrappers.remove(at: index)
    }
    
    public func invokeDelegates(_ closure: (T) -> ()) {
        delegates.forEach { closure($0) }
    }
}
