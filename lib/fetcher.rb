require 'patron'

class Fetcher
  def default_options
    { :timeout => 5,
      :max_redirects => 3,
      :max_retries => 3
    }
  end

  def options_for(options)
    default_options.merge(options)
  end

  def fetch(urls, options={}, callback=Proc.new)
    opts = options_for(options)

    threads = Array(urls).map do |url|
      Thread.new(url) do |url|
        session = Patron::Session.new
        session.timeout = opts[:timeout]
        session.max_redirects = opts[:max_redirects]
        session.handle_cookies

        complete = false
        tries = 0

        while !complete && tries < opts[:max_retries]
          tries += 1

          begin
            response = session.get(url)
          rescue Patron::TimeoutError
            next
          rescue Patron::TooManyRedirects
            break
          end

          case response.status
          when 400..499
            break
          when 500..599
            # Server error ... try again!
          else
            callback.call(response.body, url)
            complete = true
          end
        end

        callback.call(nil, nil) unless complete
      end
    end

    threads.map {|t| t.join }
  end
end
