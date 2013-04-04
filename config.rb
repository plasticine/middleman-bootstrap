require "./lib/extensions/array"
require "./lib/extensions/hash"
require "liquid_blocks"

set :config, YAML.load(File.read(File.expand_path('../config.yml', __FILE__))).ostructify

Time.zone = config.timezone

# Helpers
Dir.glob("./helpers/*") {|file|
  require file
  # helpers TypographyHelpers
  puts file
}

# Activate extensions
activate :bourbon
activate :neat
activate :livereload
activate :directory_indexes
activate :cache_buster

# Configuration
set :css_dir,         'assets/stylesheets'
set :js_dir,          'assets/javascripts'
set :images_dir,      'assets/images'
set :fonts_dir,       'assets/fonts'
set :markdown_engine, :redcarpet
set :markdown,        :fenced_code_blocks => true,
                      :autolink => true,
                      :smartypants => true,
                      :hard_wrap => true,
                      :smart => true,
                      :superscript => true,
                      :no_intra_emphasis => true,
                      :lax_spacing => true,
                      :with_toc_data => true

# Build-specific configuration
configure :build do
  activate :gzip
  activate :minify_html
  activate :minify_css
  activate :minify_javascript
  activate :relative_assets
  activate :asset_host

  set :asset_host,  "/"
end

# Page options, layouts, aliases and proxies
page "*", :layout => nil
