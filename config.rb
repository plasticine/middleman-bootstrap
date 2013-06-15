require 'dotenv'
Dotenv.load

require './lib/extensions/array'
require './lib/extensions/hash'

set :config, YAML.load(File.read(File.expand_path('../config.yml', __FILE__))).ostructify

Time.zone = config.timezone

# Blogging extension
activate :blog do |blog|
  blog.layout            = "blog"
  blog.prefix            = "blog"
  blog.paginate          = true
  blog.per_page          = 5
  blog.page_link         = "blog/page/:num"
  blog.permalink         = ":title"
  blog.summary_separator = /(READMORE)/
  blog.summary_length    = 50
  blog.default_extension = ".md"
end

# General extensions
activate :i18n
activate :bourbon
activate :neat
activate :syntax
activate :directory_indexes

# Cloudfront Extension
activate :cloudfront do |cloudfront|
  cloudfront.access_key_id     = ENV['AWS_ACCESS_KEY']
  cloudfront.secret_access_key = ENV['AWS_SECRET_KEY']
  cloudfront.distribution_id   = ENV['CLOUDFRONT_DIST_ID']
  cloudfront.filter            = /.*[^\.gz]$/i
  cloudfront.after_build       = false
end

# s3 Redirect Extension
activate :s3_redirect do |s3_redirect|
  s3_redirect.bucket                = ENV['S3_BUCKET']
  s3_redirect.region                = ENV['S3_REGION']
  s3_redirect.aws_access_key_id     = ENV['AWS_ACCESS_KEY']
  s3_redirect.aws_secret_access_key = ENV['AWS_SECRET_KEY']
  s3_redirect.after_build           = true
end

# General Configuration
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
  activate :cache_buster
  activate :directory_indexes

  set :asset_host, config.cdn_url

  # activate :image_optim do |image_optim|
  #   image_optim.image_extensions = ['*.png', '*.jpg', '*.gif']
  # end

  # Configure S3 sync
  activate :s3_sync do |s3_sync|
    s3_sync.bucket                = ENV['S3_BUCKET']
    s3_sync.region                = ENV['S3_REGION']
    s3_sync.aws_access_key_id     = ENV['AWS_ACCESS_KEY']
    s3_sync.aws_secret_access_key = ENV['AWS_SECRET_KEY']
    s3_sync.exclude               = [/\.gz\z/i]
    s3_sync.prefer_gzip           = true
    s3_sync.delete                = true
    s3_sync.after_build           = true
  end

  set_default_headers cache_control: {max_age: 31449600, public: true}

  set_headers 'text/html', cache_control: {max_age: 7200, must_revalidate: true}, content_encoding: 'gzip'
  set_headers 'text/css', cache_control: {max_age: 31449600, public: true}, content_encoding: 'gzip'
  set_headers 'application/javascript', cache_control: {max_age: 31449600, public: true}, content_encoding: 'gzip'
end

# Page configuration
page "*",           :layout => "layouts/base"
page "blog/*",      :layout => "layouts/blog"
page "/blog.xml",   :layout => false

# S3 redirects
redirect "/redirect-from/", "/redirect-to/"
