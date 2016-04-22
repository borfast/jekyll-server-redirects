module Jekyll
  module ServerRedirects
    class ServerRedirectsCommand < Jekyll::Command
      class << self

        def init_with_program(prog)
          prog.command(:server_redirects) do |c|
            c.syntax 'server_redirects [options]'
            c.description 'Generate server redirects'
            c.option 'server', '--server_type SERVER', String, 'Type of server to generate redirects for.'
            c.option 'config_template', '-T', '--config_template TEMPLATE_FILE', String, 'Your own Liquid template file from which to generate the redirects configuration.'
            add_build_options(c)
            c.action do |args, options|
              options['quiet'] = true
              exit(1) unless process options
            end
          end
        end


        def process(options)
          options = configuration_from_options(options)
          site = ::Jekyll::Site.new(options)

          site.read
          redirects = Array.new
          custom_redirects = site.config['custom_redirects'] || Array.new

          site.config['custom_redirects'].each do |conf|
            puts "config: #{conf}"
          end

          # Default redirect type for raw redirects
          custom_redirects = custom_redirects.map do |r|
            r['redirect'] ||= 'redirect'
            r
          end

          site.config['custom_redirects'].each do |conf|
            puts "config: #{conf}"
          end

          incomplete = custom_redirects.select do |r|
            puts "from: #{r.has_key?('from')}, to: #{r.has_key?('to')}"
            STDOUT.flush

            !(r.has_key?('from') && r.has_key?('to') && r['from'].length > 0 && r['to'].length > 0)
          end

          if incomplete.length > 0
            Jekyll.logger.error 'Check [site_redirects] in your config for incomplete entries. Entries should at least have `from` and `to`'
            return nil
          end

          site.posts.each do |post|
            if post.data.has_key?(':redirect_from') && post.data[':redirect_from'].is_a?(Array)
              post.data[':redirect_from'].each do |from_url|
                redirects.push('from' => Regexp.escape(from_url), 'to' => post.url)
              end
            end
          end

          template_name = 'nginx-template.conf'
          case options['server']
            when 'nginx'
              template_name = 'nginx-template.conf'
            when 'apache'
              template_name = 'apache-template.conf'
            else
          end

          if options['config_template']
            template = Liquid::Template.parse(File.read(options['config_template']))
          else
            template = Liquid::Template.parse(File.read(File.join(File.dirname(__FILE__), template_name)))
          end

          conf = template.render({
            'redirects' => redirects,
            'raw_redirects' => custom_redirects
          })
          puts conf
          true
        end
      end
    end
  end
end
