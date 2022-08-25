Pod::Spec.new do |s|
  	s.name             = "ConsoleRedirect"
  	s.version          = "1.0.4"
  	s.summary          = "redirect xcode console to klogg"
  	s.description      = <<-DESC
  	ConsoleRedirect is a lightweight Swift library to allow data transmission between xcode/klogg (Lightning port, Dock connector, USB-C) and OSX (USB) at 480MBit. 
                       DESC

  	s.homepage         = "https://github.com/luoqisheng/ConsoleRedirect"
  	s.license          = 'MIT'
  	s.author           = { "luoqisheng" => "luoqisheng@gmail.com" }
  	s.source           = { :git => "https://github.com/luoqisheng/ConsoleRedirect.git", :tag => s.version.to_s }

  	s.requires_arc = true
  	s.ios.deployment_target = '8.0'
  	
	  s.source_files = './**/*.{swift,h,m}', '*.{swift,h,m}'
    s.preserve_paths = '*.sh', 'ConsoleRedirectOSX'
    s.prepare_command = <<-CMD
                            rm -rf $HOME/ConsoleRedirect
                            mkdir $HOME/ConsoleRedirect
                            cp *.sh $HOME/ConsoleRedirect
                            cp ConsoleRedirectOSX $HOME/ConsoleRedirect
                       CMD
					   
    s.subspec "DarkLightning" do |sp|

      sp.source_files = 'DarkLightning/Sources/Port/**/*{swift}', 'DarkLightning/Sources/Utils/**/*{swift}'
      sp.platform     = :ios, '8.0'

    end
    
end
