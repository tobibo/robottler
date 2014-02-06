require 'nokogiri'
require 'fileutils'
require 'erb'
require 'ostruct'
require 'fileutils'
require 'executable'
class Robottler
  include Executable

  class Renderer < OpenStruct
    def render(erb)
     erb.result(binding)
    end
  end

  # Use for eclipse project
  def eclipse=(bool)
    @eclipse = bool
  end

  #
  def eclipse?
    @eclipse
  end

  # Use for gradle project
  def gradle=(bool)
    @gradle = bool
  end

  #
  def gradle?
    @gradle
  end

  # Show this message.
  def help!
    cli.show_help
    exit
  end
  alias :h! :help!

  # add spoon tests to project
  def call()
    name = eclipse? ? "eclipse" : "gradle"
    if eclipse?
      puts "Eclipse support not implemented yet."
      return
    end
    str  = "Hello, #{name}!"
    puts "=================#{str}================="
    puts __FILE__
    root_dir = File.expand_path("../..", __FILE__)

    puts ''
    puts ''
    puts 'creating tests'
    begin
      content = File.read("./AndroidManifest.xml")
      @doc = Nokogiri::XML(content)
      app_package = @doc.xpath("//manifest").attribute('package')
      puts "App package #{app_package}"
      activities = @doc.xpath("//activity")
      if activities.size > 0
        filename = "#{root_dir}/templates/class.erb.java"
        erb = ERB.new(File.read(filename))

        directory_name = "../instrumentTest"
        unless File.exists?(directory_name)
         puts "create directory #{directory_name}"
         test_runner_package = "java/au/com/jtribe/testing"
         FileUtils.mkdir_p("#{directory_name}/#{test_runner_package}")
         FileUtils.cp("#{root_dir}/templates/class_test_runner.java", "#{directory_name}/#{test_runner_package}/WakeUpInstrumentationTestRunner.java")
        end
      end
      puts "\nAdd these permissions to your debug manifest."
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts "!!!!!!!!!!!!! Don't add them to your release apk !!!!!!!!!!!!!"
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n"
      puts File.read("#{root_dir}/templates/debug_manifest.xml")
      puts "\nAdd this to your build.gradle file\n\n"
      puts File.read("#{root_dir}/templates/build.gradle")

      activities.each do |a|
        attribute = a.attribute('name')
        unless attribute.nil?
          package = attribute.to_s.gsub(/\w+$/, '').chop!
          package_dir = package.gsub('.','/')
          file_path = "#{directory_name}/java/#{package_dir}"
          unless File.exists?(file_path)
            FileUtils.mkdir_p(file_path)
            activity = attribute.to_s.match(/\w+$/) 
            puts "\tfor #{activity}"
            activity_file_path = "#{file_path}/#{activity}Test.java"
            unless File.exists?(activity_file_path)
              r = Renderer.new({ activity: activity, package: package, app_package: app_package})
              File.open(, 'w') do |f|
                f.write r.render(erb)
              end
            end
          end
        end
      end
    end
    rescue
      puts '================ Can\'t find AndroidManifest ================'
      puts 'Make sure you are in the folder where your AndroidManifest.xml is!'
    end
  end
end
