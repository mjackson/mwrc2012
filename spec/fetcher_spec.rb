require File.expand_path('../helper', __FILE__)
require 'fetcher'

describe Fetcher do
  before do
    @fetcher = Fetcher.new
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
