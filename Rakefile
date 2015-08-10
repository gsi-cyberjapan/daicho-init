task :default do
  require './init_daicho.rb'
  require 'zlib'
  %w{std}.each {|t|
    mokuroku_path = "/Users/hfu/htdocs/xyz/#{t}/mokuroku.csv.gz"
    daicho_path = "daicho_dev_#{t}.sqlite3"
    sh "rm #{daicho_path}" if File.exist?(daicho_path)
    Zlib::GzipReader.open(mokuroku_path) {|mokuroku_in|
      init_daicho(mokuroku_in, daicho_path, 'png')
    }
  }
end
