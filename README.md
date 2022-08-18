# ConsoleRedirect
## 功能
ConsoleRedirect 是一款通过redirect App的stderr和 stdoutput的将Xcode的输出实时同步写到macosx 下指定目录的工具。配合klogg等日志查看工具，可以实时查看、过滤、查找、高亮Xcode的控制台输出。用于代替比较功能比较单薄的Xcode 控制台。


## ConsoleRedirect的接入非常简单，只需要4步：

* pod 引入
* pod install, 此时ConsoleRedirect会将工具脚本放在$HOME/ConsoleRedirect目录下
* Xcode Behavior，在Generate Output 下新增 run script => $HOME/ConsoleRedirect/console_redirect_start.sh, 在complete和 exit下新增 run script => $HOME/ConsoleRedirect/console_redirect_stop.sh
* Klogg打开项目下console.log, enjoy it