
### swift 线程锁
	func synchronized(_ lock: AnyObject, _ closure: () -> ()) {
   	 	objc_sync_enter(lock)
   	 	closure()
    	objc_sync_exit(lock)
	}
	
	func myMethodLocked(anobj: AnyObject) {
    	synchronized(anobj){
    	   // 在括号内 anObj 不会被其他线程改变
    	}
	}	


***
### 安全的资源组织方式 
[@来源](http://swifter.tips/safe-resource/)

	enum ImageName: String {
    	case MyImage = "my_image"
	}

	enum SegueName: String {
    	case MySegue = "my_segue"
	}

	extension UIImage {
    	convenience init!(imageName: ImageName) 
    	{
       	 self.init(named: imageName.rawValue)
   	 	}
	}

	extension UIViewController {
    	func performSegueWithSegueName(segueName: SegueName, sender: AnyObject?) 		{
        	performSegueWithIdentifier(segueName.rawValue, sender: sender)
    	}
	}
** 在使用时，就可以直接用 extension 中的类型安全的版本了：*
	
	let image = UIImage(imageName: .MyImage)

	performSegueWithSegueName(.MySegue, sender: self)
```
但仅仅这样其实还是没有彻底解决名称变更带来的问题。不过在 Swift 中，根据项目内容来自动化生成像是 ImageName 和 SegueName 这样的类型并不是一件难事。Swift 社区中现在也有一些比较成熟的自动化工具了，R.swift 和 SwiftGen 就是其中的佼佼者。它们通过扫描我们的项目文件，来提取出对应的字符串，然后自动生成对应的 enum 或者 struct 文件。当我们之后添加，删除或者改变资源名称的时候，这些工具可以为我们重新生成对应的代表资源名字的类型，从而让我们可以利用编译器的检查来确保代码中所有对该资源的引用都保持正确。这在需要协作的项目中会是非常可靠和值得提倡的做法。 
```
***
### delegate 引用问题
[@来源](http://swifter.tips/delegate/)

想要在 Swift 中使用 weak delegate，我们就需要将 protocol 限制在 class 内。一种做法是将 protocol 声明为 Objective-C 的，这可以通过在 protocol 前面加上 @objc 关键字来达到，Objective-C 的 protocol 都只有类能实现，因此使用 weak 来修饰就合理了：

	@objc protocol MyClassDelegate {
    	func method()
	}


另一种可能更好的办法是在 protocol 声明的名字后面加上 class，这可以为编译器显式地指明这个 protocol 只能由 class 来实现。

	protocol MyClassDelegate: class {
  	  	func method()
	}
	
相比起添加 @objc，后一种方法更能表现出问题的实质，同时也避免了过多的不必要的 Objective-C 兼容，可以说是一种更好的解决方式。

***



	

