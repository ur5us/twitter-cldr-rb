# encoding: UTF-8

# Copyright 2012 Twitter, Inc
# http://www.apache.org/licenses/LICENSE-2.0

require 'open-uri'
require 'fileutils'

module TwitterCldr
  module Resources
    module Requirements

      class UnicodeRequirement
        BASE_URL = "ftp://ftp.unicode.org/Public/%{version}"

        attr_reader :version, :files

        def initialize(version, files)
          @version = version
          @files = files
        end

        def prepare
          files.each do |file|
            unless File.file?(source_path_for(file))
              STDOUT.write("Downloading #{file} from #{product} v#{version}... ")
              download(file)
              puts 'done'
            end

            puts "Using #{file} from #{product} v#{version}"
          end
        end

        def source_path_for(file)
          File.join(TwitterCldr::VENDOR_DIR, "#{product}_v#{version}", file)
        end

        private

        def product
          'unicode'
        end

        def base_url
          BASE_URL
        end

        def download(file)
          source_path = source_path_for(file)
          FileUtils.mkdir_p(File.dirname(source_path))
          remote_url = File.join(base_url % { version: version}, file)
          open(source_path, 'wb') { |file| file << open(remote_url).read }
        end
      end

    end
  end
end
