# Jekyll::ServerRedirects

This was written because I wanted to migrate my blog from Drupal to Jekyll and I wanted to keep the old URLs.

Most people who use Jekyll seem to prefer to generate HTML pages with a meta refresh tag in them to redirect the browser.
I wanted to do it via the server, so I could have proper 301 redirects and not have to keep a few hundred unwanted files lying around.

There is a Jekyll plugin, [Jekyll::NginxConfig](https://github.com/activelamp/jekyll-nginx-config) that is supposed to do this but for some reason it wasn't working. I also tried other plugins like [Jekyll Pageless Redirects](https://github.com/nquinlan/jekyll-pageless-redirects), [Alias Generator for Posts](https://github.com/tsmango/jekyll_alias_generator) and [JekyllRedirectFrom](https://github.com/jekyll/jekyll-redirect-from), which seemed like the most promising one, but I could get none of them working.

This was driving me insane, so I grabbed Jekyll::NginxConfig and changed it to do what I wanted. While I was at it, I figured I could add the ability to generate redirects for Apache and not just nginx.

### Installation

Add this to your `Gemfile`:

```ruby
group :jekyll_plugins do
  gem 'jekyll-server-redirects'
end
```

> You have to specify it under the `:jekyll_plugins` group otherwise Jekyll won't recognize the `server_redirects` command.

Then run `bundle install`.

> If using a global Jekyll installation, just do `gem install jekyll-server-redirects`

### Basic usage

On each post you want to redirect to from another URL, add the following to the front matter:

```yaml
:redirect_from:
  - blog/old-url
  - node/641
```
This block lists the URLs you want to redirect to your new URL from.

After having all the posts configured, run the following command to generate the server configuration:

```bash
bundle exec jekyll server_redirects --server_type nginx
```

> If you didn't install the plugin with Bundler, drop the `bundle exec` part of the command.

> If you want to use Apache instead of nginx, just replace `nginx` with `apache` in the command.

This will output the list of redirects for your server of choice. If you want to store it directly in a file, you can append ` > redirects.conf` to the command.

### Custom redirects

If you want some custom redirects, you can do so easily by adding a few lines to your Jekyll config file (typically `_config.yml`):

```yaml
custom_redirects:
  - from: ^/old-url$
    to: /blog/new-url
    type: permanent

  - from: ^/another-old-url$
    to: /under-construction
    type: temp
```

Items under `custom_redirects` are simply translated straight into server directives. In this case and assuming nginx:

```nginx
rewrite ^/old-url$ /blog/new-url permanent;
rewrite ^/another-old-url$ /under-construction temp;
```

To know more, [see documentation about Nginx's `rewrite` directives](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)

#### Custom server directives template

You can also specify your own Liquid template file to use if you wish to have complete control on the resulting server redirection directives. Use `--config_template <PATH TO LIQUID TEMPLATE>`.


