require 'test/unit'
require 'robottler'

class RobottlerTest < Test::Unit::TestCase
  def test_parsing_manifest
  	FileUtils.rm_rf("./test/fixtures/instrumentTest")
    Dir.chdir("./test/fixtures/main") do
		  Robottler.create
		end
  end
end