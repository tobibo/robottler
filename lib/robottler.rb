require 'nokogiri'
require 'fileutils'
require 'erb'
require 'ostruct'
require 'fileutils'

class Robottler

	class Renderer < OpenStruct
	  def render(erb)
	    erb.result(binding)
	  end
	end


	def self.create
		puts __FILE__
		root_dir = File.expand_path("../..", __FILE__)
		
		puts ''
		puts ''
		puts 'creating tests'
		content = File.read("./AndroidManifest.xml")
		@doc = Nokogiri::XML(content)
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
					FileUtils.mkdir_p(file_path)
					activity = attribute.to_s.match(/\w+$/) 
					puts "\tfor #{activity}"
					r = Renderer.new({ activity: activity, package: package})
					File.open("#{file_path}/#{activity}Test.java", 'w') do |f|
					  f.write r.render(erb)
					end
				end
			end
		end
	end



end