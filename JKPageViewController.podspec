#
# Be sure to run `pod lib lint JKPageViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JKPageViewController"
  s.version          = "0.1.0"
  s.summary          = "A simple wrapper class for UIPageViewController with easy implementation."
s.description      = " - encapsulates common delegate methods

- keeps track of indexes

- turns page control on/off with the pageControlEnabled boolean

- comes with an Appearable hook for child view controllers
"
  s.homepage         = "https://github.com/kimjune01/JKPageViewController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
s.author           =  {"June Kim" => "kimjune01@gmail.com"}
s.source           =  {:git => "https://github.com/kimjune01/JKPageViewController.git", :tag =>  s.version.to_s }

  s.platform     = :ios, '8.3'
  s.source_files = 'JKPageViewController.swift'
  s.frameworks = 'UIKit'
end
