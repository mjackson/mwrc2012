require File.expand_path('../helper', __FILE__)
require 'yaml'
require 'fetcher'

# Let's use a serialized Hash to keep track of
# requests we've made in past test runs.
CACHE_FILE = File.expand_path('../cache/fetcher.yml', __FILE__)
CACHE = File.exist?(CACHE_FILE) ? YAML.load_file(CACHE_FILE) : Hash.new

MiniTest::Unit.after_tests do
  File.open(CACHE_FILE, 'w') do |file|
    file.write(YAML.dump(CACHE))
  end
end

describe Fetcher do
  before do
    @fetcher = Fetcher.new

    # Stub out the #fetch method.
    def @fetcher.fetch(urls, options={}, callback=Proc.new)
      opts = options_for(options)

      Array(urls).each do |url|
        CACHE[url] ||= %x[curl -s -L --max-redirs #{opts[:max_redirects]} --retry #{opts[:max_retries]} #{url}]
        callback.call(CACHE[url], url)
      end
    end

    @urls = %w[
      http://www.twitter.com/
      http://www.apple.com/
      http://www.google.com/
      http://www.facebook.com/
    ]
  end

  describe 'when requesting some URLs' do
    it 'calls the callback for each URL' do
      count = 0

      @fetcher.fetch(@urls) do |body, url|
        count += 1
      end

      count.must_equal @urls.size
    end
  end
end
