# ConsoleRedirect
## 功能
ConsoleRedirect 是一款通过redirect App的stderr和 stdoutput的将Xcode的输出实时同步写到macosx 下指定目录的工具。配合[klogg](https://github.com/variar/klogg)等日志查看工具，可以实时查看、过滤、查找、高亮Xcode的控制台输出。用于代替比较功能比较单薄的Xcode 控制台。


## ConsoleRedirect的接入非常简单，只需要4步：

* pod 引入 
`pod "ConsoleRedirect", :git => 'https://github.com/luoqisheng/ConsoleRedirect.git', :tag => '1.0.4', :configurations => ['Debug']`
* pod install, 此时ConsoleRedirect会将工具脚本放在$HOME/ConsoleRedirect目录下
* Xcode Behavior，在Running的Generate Output 下新增 run script => $HOME/ConsoleRedirect/console_redirect_start.sh, 在complete和 exit下新增 run script => $HOME/ConsoleRedirect/console_redirect_stop.sh
* Klogg打开项目下console.log,按下F(Follow)键, enjoy it


https://user-images.githubusercontent.com/5061690/185590593-0a5bc411-ae7e-4c58-af9c-0df867ca6142.mov

## 其他
[klogg的使用文档](https://github.com/variar/klogg/blob/master/DOCUMENTATION.md)
